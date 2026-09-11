"""
Minimal binary-DFM ("TPF0") stream parser, for reading ReportBuilder report
templates stored in TBLSYSREPORT.SRP_REPORTFILE (MSSQL, legacy Delphi6ERP).

Delphi's binary component-stream format ("TPF0" signature) is the same
format used for .dfm files -- ReportBuilder's Template.SaveToDatabase just
runs a TppReport component tree through the standard Delphi filer, so this
is a generic reader, not something ReportBuilder-specific.

Not a full round-trip implementation (no writer) -- just enough to read the
component/property tree back out, which convert_report.py then walks to
build the equivalent Stimulsoft JSON.
"""
import struct

VA_NULL = 0
VA_LIST = 1
VA_INT8 = 2
VA_INT16 = 3
VA_INT32 = 4
VA_EXTENDED = 5
VA_STRING = 6
VA_IDENT = 7
VA_FALSE = 8
VA_TRUE = 9
VA_BINARY = 10
VA_SET = 11
VA_LSTRING = 12
VA_NIL = 13
VA_COLLECTION = 14
VA_SINGLE = 15
VA_CURRENCY = 16
VA_DATE = 17
VA_WSTRING = 18
VA_INT64 = 19
VA_UTF8STRING = 20


class DFMParseError(Exception):
    pass


class Reader:
    def __init__(self, data):
        self.data = data
        self.pos = 0

    def eof(self):
        return self.pos >= len(self.data)

    def read_bytes(self, n):
        if self.pos + n > len(self.data):
            raise DFMParseError(f"EOF at {self.pos}, need {n} more bytes (len={len(self.data)})")
        b = self.data[self.pos:self.pos + n]
        self.pos += n
        return b

    def read_byte(self):
        return self.read_bytes(1)[0]

    def read_int8(self):
        return struct.unpack('<b', self.read_bytes(1))[0]

    def read_int16(self):
        return struct.unpack('<h', self.read_bytes(2))[0]

    def read_int32(self):
        return struct.unpack('<i', self.read_bytes(4))[0]

    def read_int64(self):
        return struct.unpack('<q', self.read_bytes(8))[0]

    def read_shortstring(self):
        n = self.read_byte()
        return self.read_bytes(n).decode('cp950', errors='replace')

    def read_lstring(self):
        n = self.read_int32()
        return self.read_bytes(n).decode('cp950', errors='replace')

    def read_wstring(self):
        n = self.read_int32()
        return self.read_bytes(n * 2).decode('utf-16-le', errors='replace')

    def read_utf8string(self):
        n = self.read_int32()
        return self.read_bytes(n).decode('utf-8', errors='replace')


def read_value(r: Reader):
    tag = r.read_byte()
    if tag == VA_LIST:
        items = []
        while True:
            save = r.pos
            t = r.read_byte()
            if t == VA_NULL:
                break
            r.pos = save
            items.append(read_value(r))
        return items
    if tag == VA_INT8:
        return r.read_int8()
    if tag == VA_INT16:
        return r.read_int16()
    if tag == VA_INT32:
        return r.read_int32()
    if tag == VA_EXTENDED:
        raw = r.read_bytes(10)
        return f"<extended {raw.hex()}>"
    if tag == VA_STRING:
        return r.read_shortstring()
    if tag == VA_IDENT:
        return r.read_shortstring()
    if tag == VA_FALSE:
        return False
    if tag == VA_TRUE:
        return True
    if tag == VA_BINARY:
        n = r.read_int32()
        data = r.read_bytes(n)
        return f"<binary {n} bytes: {data[:32].hex()}{'...' if n > 32 else ''}>"
    if tag == VA_SET:
        items = []
        while True:
            n = r.read_byte()
            if n == 0:
                break
            items.append(r.read_bytes(n).decode('cp950', errors='replace'))
        return "[" + ",".join(items) + "]"
    if tag == VA_LSTRING:
        return r.read_lstring()
    if tag == VA_NIL:
        return None
    if tag == VA_COLLECTION:
        return read_collection(r)
    if tag == VA_SINGLE:
        return struct.unpack('<f', r.read_bytes(4))[0]
    if tag == VA_CURRENCY:
        v = r.read_int64()
        return v / 10000.0
    if tag == VA_DATE:
        return struct.unpack('<d', r.read_bytes(8))[0]
    if tag == VA_WSTRING:
        return r.read_wstring()
    if tag == VA_INT64:
        return r.read_int64()
    if tag == VA_UTF8STRING:
        return r.read_utf8string()
    raise DFMParseError(f"unknown value tag {tag} at pos {r.pos - 1}")


def read_properties(r: Reader):
    props = []
    while True:
        name = r.read_shortstring()
        if name == '':
            break
        value = read_value(r)
        props.append((name, value))
    return props


def read_collection(r: Reader):
    items = []
    while True:
        save = r.pos
        b = r.read_byte()
        if b == 0:
            break
        r.pos = save
        index = None
        if b in (VA_INT8, VA_INT16, VA_INT32):
            index = read_value(r)
        props = read_properties(r)
        items.append({"index": index, "props": props})
    return items


def read_object(r: Reader):
    cls = r.read_shortstring()
    name = r.read_shortstring()
    props = read_properties(r)
    children = []
    while True:
        save = r.pos
        b = r.read_byte()
        if b == 0:
            break
        r.pos = save
        children.append(read_object(r))
    return {"class": cls, "name": name, "props": props, "children": children}


def parse_dfm(data: bytes):
    """Parse a TBLSYSREPORT.SRP_REPORTFILE blob into a component tree.

    Returns (root, reader). Check `len(data) - reader.pos` after calling --
    it should be 0 or 1 (a single trailing terminator byte); anything larger
    means the parse likely went off the rails partway through.
    """
    if data[:4] != b'TPF0':
        raise DFMParseError(f"missing TPF0 signature, got {data[:4]!r}")
    r = Reader(data)
    r.pos = 4
    root = read_object(r)
    return root, r


def format_value(v, maxlen=120):
    if isinstance(v, list):
        inner = ", ".join(format_value(x, 40) for x in v[:15])
        more = f", ...(+{len(v)-15})" if len(v) > 15 else ""
        return f"[{inner}{more}]"
    if isinstance(v, dict):
        return str(v)
    s = str(v)
    if len(s) > maxlen:
        s = s[:maxlen] + "...(truncated)"
    return s


def dump_tree(obj, indent=0, out=None):
    """Human-readable dump of a parsed tree, DFM-text-like. Handy for
    eyeballing what a given legacy report layout actually contains."""
    pad = "  " * indent
    line = f"{pad}object {obj['name']}: {obj['class']}"
    print(line, file=out)
    for k, v in obj['props']:
        print(f"{pad}  {k} = {format_value(v)}", file=out)
    for child in obj['children']:
        dump_tree(child, indent + 1, out=out)
