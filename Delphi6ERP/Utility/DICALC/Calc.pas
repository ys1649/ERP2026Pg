unit calc;

(*
//.TITLE Calculator
//.DESC  Simple calculator for standard expressions
//.AUTOR Ivlev M.Dmitry
// Email: Dimon@Diogen.nstu.nsk.su
//.PATCHED Sergey Pedora
// Email: Sergey@mail.fact400.ru
//

  Syntax:
  0xABCD, 0ABCDh, $ABCD - Hex number
  0b0101, 01010b,       - Binary number
  90`15`2               - Degree
   Operators by priorities:
    {  7} () (BRACES)
    {  6} ** (POWER),
    {  5} ~ (INVERSE), ! (NOT),
    {  4} * (MUL), / (DIV), % (MOD), %% (PERSENT),
    {  3} + (ADD), - (SUB),
    {  2} < (LT), <= (LE), == (EQ), <> != (NE), >= (GE), > (GT),
    {  1} | (OR), ^ (XOR), & (AND),

*)

interface

uses SysUtils, Classes;

type
  TToken = (
    { } tkEOF, tkERROR, tkASSIGN,
    {7} tkLBRACE, tkRBRACE, tkNUMBER, tkIDENT, tkSEMICOLON,
    {6} tkPOW,
    {5} tkINV, tkNOT,
    {4} tkMUL, tkDIV, tkMOD, tkPER,
    {3} tkADD, tkSUB,
    {2} tkLT, tkLE, tkEQ, tkNE, tkGE, tkGT,
    {1} tkOR, tkXOR, tkAND
  );

  ECalculate = class(Exception);
  TCalcCBType = (ctGetValue, ctSetValue, ctFunction);
  TCalcCBProc =
    function(ctype: TCalcCBType; const S: String; var Value: Double): Boolean;

  PNamedVar = ^TNamedVar;
  TNamedVar = record
    Value: Double;
    Name: array[0..0] of Char;
  end;

  TCalculator = class(TPersistent)
  private
    FExpression: String;
    FVars: TList;
    function  GetResult: Double;
  protected
    function  Callback(ctype: TCalcCBType;
              const Name: String; var Res: Double): Boolean; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    function  NameOf(Index: Word): String;
    procedure ClearVars;
  published
    property Expression: String Read FExpression Write FExpression;
    property Result: Double Read GetResult;
  end;


resourcestring
  SSyntaxError = 'Syntax error.';
  SFunctionError = 'Unknown function or variable';
  SInvalidDegree = 'Invalid degree %s';

{ Default calculator callback proc }
function DefCalcProc(ctype: TCalcCBType; const S: String;
  var V: Double): Boolean;
  
{ some math functions}
function fmod(x, y: extended): extended;
function power(x, y: Double): Double;

{ Degree convertation functions }
function DegreeToStr(Angle: Extended): String;

{ Calculate functions }
function StrCalculate(Buff: PChar;
  var R: Double; Proc: TCalcCBProc): Boolean;
function Calculate(const Formula: String;
  var R: Double; Proc: TCalcCBProc): Boolean;

function EVal(const Formula: String): Double;


implementation

function DefCalcProc(ctype: TCalcCBType; const S: String;
  var V: Double): Boolean;
begin
  Result := TRUE;
  case ctype of
    ctGetValue: begin
      if S = 'pi' then V := Pi else
      if S = 'e' then V := 2.718281828 else
      Result := FALSE;
    end;
    ctSetValue: begin
      Result := FALSE;
    end;
    ctFunction: begin
      if S = 'round'  then V := Round(V) else
      if S = 'trunc'  then V := Trunc(V) else
      if S = 'int'  then V := Int(V) else
      if S = 'frac'  then V := Frac(V) else
      if S = 'sin'  then V := sin(V) else
      if S = 'cos'  then V := cos(V) else
      if S = 'tan'  then V := sin(V)/cos(V) else
      if S = 'atan' then V := arctan(V) else
      if S = 'ln'   then V := ln(V) else
      if S = 'exp'  then V := exp(V) else
      if S = 'sign' then begin if (V>0) then V := 1 else if(V<0) then V := -1 end else
      if S = 'sgn' then begin if (V>0) then V := 1 else if(V<0) then V := 0 end else
      if S = 'xsgn' then begin if(V<0) then V := 0 end else
      Result := FALSE;
    end;
  end;
end;

function fmod(x, y: extended): extended;
begin
  Result := x - Int(x / y) * y;
end;

function power(x, y: Double): Double;
begin
  if (x = 0)
  then power := 1.0
  else power := Exp(Ln(x)*y);
end;

function DegreeToStr(Angle: extended): String;
var
  ang, min, sec: LongInt;
begin
  Result := '';
  if Abs(Angle) < 1E-20 then Angle := 0.;
  if Angle < 0 then begin
    Result := '-';
    Angle := -Angle;
  end;
  Angle := Angle * 180.0 / Pi; ang := Trunc(Angle+5E-10);
  Angle := (Angle - ang) * 60; min := Trunc(Angle+5E-10);
  Angle := (Angle - min) * 60; sec := Trunc(Angle+5E-10);
  Result := Result + IntToStr(ang)+'`';
  if min <> 0 then Result := Result + IntToStr(min);
  if sec <> 0 then Result := Result + '`' + IntToStr(sec);
end;



(*
// Static functions
*)

var
  ptr: PChar;
  lineno: Word;
  fvalue: Double;
  svalue: String[32];
  token: TToken;
  CalcProc: TCalcCBProc;

procedure RaiseError(const Msg: String);
begin
  raise ECalculate.Create(Msg);
end;

function tofloat(B: Boolean): Double;
begin
  if (B) then tofloat := 1.0 else tofloat := 0.0;
end;

{ yylex like function }

procedure lex;
label
  Error;
var
  c, sign: char;
  frac: Double;
  exp: LongInt;
  s_pos: PChar;

  function ConvertNumber(first, last: PChar; base: Word): boolean;
  var
    c: Byte;
  begin
    fvalue := 0;
    while first < last do begin
      c := Ord(first^) - Ord('0');
      if (c > 9) then begin
        Dec(c, Ord('A') - Ord('9') - 1);
        if (c > 15) then Dec(c, Ord('a') - Ord('A'));
      end;
      if (c >= base) then break;
      fvalue := fvalue * base + c;
      Inc(first);
    end;
    Result := (first = last);
  end;

begin
  { skip blanks }
  while ptr^ <> #0 do begin
    if (ptr^ = #13) then Inc(lineno)
    else if (ptr^ > ' ') then break;
    Inc(ptr);
  end;

  { check EOF }
  token := tkEOF;
  if (ptr^ = #0) then Exit;

  s_pos := ptr;
  token := tkNUMBER;

  { match pascal like hex number }
  if (ptr^ = '$') then begin
    Inc(ptr);
    while (ptr^ in ['0'..'9', 'A'..'H', 'a'..'h']) do Inc(ptr);
    if not ConvertNumber(s_pos, ptr, 16) then goto Error;
    Exit;
  end;

  { match numbers }
  if (ptr^ in ['0'..'9']) then begin

    { C like mathing }
    if (ptr^ = '0') then begin
      Inc(ptr);

      { match C like hex number }
      if (ptr^ in ['x', 'X']) then begin
        Inc(ptr);
        s_pos := ptr;
        while (ptr^ in ['0'..'9', 'A'..'H', 'a'..'h']) do Inc(ptr);
        if not ConvertNumber(s_pos, ptr, 16) then goto Error;
        Exit;
      end;

      { match C like binary number }
      if (ptr^ in ['b', 'B']) then begin
        Inc(ptr);
        s_pos := ptr;
        while (ptr^ in ['0'..'1']) do Inc(ptr);
        if not ConvertNumber(s_pos, ptr, 2) then goto Error;
        Exit;
      end;
    end;

    while (ptr^ in ['0'..'9', 'A'..'F', 'a'..'f']) do Inc(ptr);

    { match assembler like hex number }
    if (ptr^ in ['H', 'h']) then begin
      if not ConvertNumber(s_pos, ptr, 16) then goto Error;
      Inc(ptr);
      Exit;
    end;

    { match assembler like binary number }
    if (ptr^ in ['B', 'b']) then begin
      if not ConvertNumber(s_pos, ptr, 2) then goto Error;
      Inc(ptr);
      Exit;
    end;

    { match simple decimal number }
    if not ConvertNumber(s_pos, ptr, 10) then goto Error;

    { match degree number }
    if (ptr^ = '`') then begin
      fvalue := fvalue * Pi / 180.0;
      Inc(ptr); frac := 0;
      while (ptr^ in ['0'..'9']) do begin
        frac := frac * 10 + (Ord(ptr^) - Ord('0'));
        Inc(ptr);
      end;
      fvalue := fvalue + (frac * Pi / 180.0 / 60);
      if (ptr^ = '`') then begin
      Inc(ptr); frac := 0;
      while (ptr^ in ['0'..'9']) do begin
        frac := frac * 10 + (Ord(ptr^) - Ord('0'));
        Inc(ptr);
      end;
      fvalue := fvalue + (frac * Pi / 180.0 / 60 / 60);
      end;
      fvalue := fmod(fvalue, 2*Pi);
      Exit;
    end;

    { match float numbers }
    if (ptr^ = '.') then begin Inc(ptr);
      frac := 1;
      while (ptr^ in ['0'..'9']) do begin
        frac := frac / 10;
        fvalue := fvalue + frac * (Ord(ptr^) - Ord('0'));
        Inc(ptr);
      end;
    end;

    if (ptr^ in ['E', 'e']) then begin Inc(ptr);
      exp := 0;
      sign := ptr^;
      if (ptr^ in ['+', '-']) then Inc(ptr);
      if not (ptr^ in ['0'..'9']) then goto Error;
      while (ptr^ in ['0'..'9']) do begin
        exp := exp * 10 + Ord(ptr^) - Ord('0');
        Inc(ptr);
      end;
      if (exp = 0)
      then fvalue := 1.0
      else if (sign = '-')
      then while exp > 0 do begin fvalue := fvalue * 10; Dec(exp); end
      else while exp > 0 do begin fvalue := fvalue / 10; Dec(exp); end
    end;
    Exit;
  end;

  { match identifiers }
  if (ptr^ in ['A'..'Z','a'..'z','_']) then begin
    svalue := ptr^;
    Inc(ptr);
    while (ptr^ in ['A'..'Z','a'..'z','0'..'9']) and
          (Length(svalue) < sizeof(svalue)-1) do
    begin
      svalue := svalue + ptr^;
      Inc(ptr);
    end;
    token := tkIDENT;
    Exit;
  end;

  { match operators }
  c := ptr^; Inc(ptr);
  case c of
    '=': begin token := tkASSIGN; 
      if (ptr^ = '=') then begin Inc(ptr); token := tkEQ; end;
    end;
    '+': begin token := tkADD; end;
    '-': begin token := tkSUB; end;
    '*': begin token := tkMUL;
      if (ptr^ = '*') then begin Inc(ptr); token := tkPOW; end;
    end;
    '/': begin token := tkDIV; end;
    '%': begin token := tkMOD;
      if (ptr^ = '%') then begin Inc(ptr); token := tkPER; end;
    end;
    '~': begin token := tkINV; end;
    '^': begin token := tkXOR; end;
    '&': begin token := tkAND; end;
    '|': begin token := tkOR; end;
    '<': begin token := tkLT;
      if (ptr^ = '=') then begin Inc(ptr); token := tkLE; end else
      if (ptr^ = '>') then begin Inc(ptr); token := tkNE; end;
    end;
    '>': begin token := tkGT;
      if (ptr^ = '=') then begin Inc(ptr); token := tkGE; end else
      if (ptr^ = '<') then begin Inc(ptr); token := tkNE; end;
    end;
    '!': begin token := tkNOT;
      if (ptr^ = '=') then begin Inc(ptr); token := tkNE; end;
    end;
    '(': begin token := tkLBRACE; end;
    ')': begin token := tkRBRACE; end;
    ';': begin token := tkSEMICOLON end;
    else begin token := tkERROR; dec(ptr); end;
  end;
  Exit;

Error:
  token := tkERROR;
end;

(*
// LL grammatic for calculator, priorities from down to up
//
// start: expr6;
// expr6: expr5 { & expr5 | ^ expr5 | & expr5 }*;
// expr5: expr4 { < expr4 | > expr4 | <= expr4 | >= expr4 | != expr4 | == expr4 }*;
// expr4: expr3 { + expr3 | - expr3 }*;
// expr3: expr2 { * expr2 | / expr2 | % expr2 | %% expr2 }*;
// expr2: expr1 { ! expr1 | ~ expr1 | - expr1 | + expr1 };
// expr1: term ** term
// term: tkNUMBER | tkIDENT | (start) | tkIDENT(start) | tkIDENT = start;
//
*)
procedure start(var R: Double); forward;
procedure term (var R: Double); forward;
procedure expr6(var R: Double); forward;
procedure expr5(var R: Double); forward;
procedure expr4(var R: Double); forward;
procedure expr3(var R: Double); forward;
procedure expr2(var R: Double); forward;
procedure expr1(var R: Double); forward;

procedure term(var R: Double); var S: String[32];
begin
  case token of
    tkNUMBER: begin
      R := fvalue;
      lex;
    end;
    tkLBRACE: begin lex;
      expr6(R);
      if (token = tkRBRACE)
        then lex
        else RaiseError(SSyntaxError);
    end;
    tkIDENT: begin
      S := LowerCase(svalue); lex;
      if token = tkLBRACE then begin
        lex; expr6(R);
        if (token = tkRBRACE)
          then lex
          else RaiseError(SSyntaxError);
        if not CalcProc(ctFunction, s, R)
          then RaiseError(SFunctionError+' "'+s+'".');
      end else
      if (token = tkASSIGN) then begin
        lex; expr6(R);
        if not calcProc(ctSetValue, s, R)
          then RaiseError(SFunctionError+' "'+s+'".');
      end else
      if not CalcProc(ctGetValue, s, R)
        then RaiseError(SFunctionError+' "'+s+'".');
    end;
    else {case}
      RaiseError('Syntax error.');
  end;
end;

procedure expr1(var R: Double); var V: Double;
begin
  term(R);
  if (token = tkPOW) then begin
    lex; term(V);
    R := power(R, V);
  end;
end;

procedure expr2(var R: Double); var oldt: TToken;
begin
  if (token in [tkNOT, tkINV, tkADD, tkSUB]) then begin
    oldt := token; lex; expr2(R);
    case oldt of
      tkNOT: R := tofloat(not(Boolean(Trunc(R))));//tofloat(R <> 0.0);
      tkINV: R := (not Trunc(R));
      tkADD: ;
      tkSUB: R := -R;
    end;
  end
  else expr1(R);
end;

procedure expr3(var R: Double); var V: Double; oldt: TToken;
begin
  expr2(R);
  while token in [tkMUL, tkDIV, tkMOD, tkPER] do begin
    oldt := token; lex; expr2(V);
    case oldt of
      tkMUL: R := R * V;
      tkDIV: R := R / V;
      tkMOD: R := Trunc(R) mod Trunc(V);
      tkPER: R := R * V / 100.0;
    end;
  end;
end;

procedure expr4(var R: Double); var V: Double; oldt: TToken;
begin
  expr3(R);
  while token in [tkADD, tkSUB] do begin
    oldt := token; lex; expr3(V);
    case oldt of
      tkADD: R := R + V;
      tkSUB: R := R - V;
    end;
  end;
end;

procedure expr5(var R: Double); var V: Double; oldt: TToken;
begin
  expr4(R);
  while token in [tkLT, tkLE, tkEQ, tkNE, tkGE, tkGT] do begin
    oldt := token; lex; expr4(V);
    case oldt of
      tkLT: R := tofloat(R < V);
      tkLE: R := tofloat(R <= V);
      tkEQ: R := tofloat(R = V);
      tkNE: R := tofloat(R <> V);
      tkGE: R := tofloat(R >= V);
      tkGT: R := tofloat(R > V);
    end;
  end;
end;

procedure expr6(var R: Double); var V: Double; oldt: TToken;
begin
  expr5(R);
  while token in [tkOR, tkXOR, tkAND] do begin
    oldt := token; lex; expr5(V);
    case oldt of
      tkOR : R := Trunc(R) or  Trunc(V);
      tkAND: R := Trunc(R) and Trunc(V);
      tkXOR: R := Trunc(R) xor Trunc(V);
    end;
  end;
end;

procedure start(var R: Double);
begin
  expr6(R);
  while (token = tkSEMICOLON) do begin lex; expr6(R); end;
  if not (token = tkEOF) then RaiseError(SSyntaxError);
end;

function StrCalculate(Buff: PChar;
  var R: Double; Proc: TCalcCBProc): Boolean;
begin
  if (@Proc = Nil)
    then CalcProc := @DefCalcProc
    else CalcProc := Proc;
  ptr := Buff; lineno := 1;
  lex; start(R);
  Result := TRUE;
end;

function Calculate(const Formula: String;
  var R: Double; Proc: TCalcCBProc): Boolean;
begin
  Result := StrCalculate(PChar(Formula), R, Proc);
end;

function EVal(const Formula: String): Double;
var r:double;
begin
  StrCalculate(PChar(Formula), r, nil);
  result:=r;
end;



(*
// TCalculator component
*)

constructor TCalculator.Create;
begin
  inherited Create;
  FVars := TList.Create;
end;

destructor TCalculator.Destroy;
begin
  ClearVars;
  FVars.Free;
  inherited Destroy;
end;


var Calculator: TCalculator;
function RedirectCalcProc(ctype: TCalcCBType;
  const Name: String; var Res: Double): Boolean; far;
begin
  Result := Calculator.Callback(ctype, Name, Res);
end;

function TCalculator.GetResult: Double;
begin
  Calculator := Self;
  calculate(FExpression, Result, @RedirectCalcProc);
end;

function TCalculator.Callback(ctype: TCalcCBType;
  const Name: String; var Res: Double): Boolean; far;
begin
  Result := DefCalcProc(ctype, name, Res);
  if Result then Exit;
  Result := TRUE;
  case ctype of
//    ctGetValue: Res := Vars[Name];
//    ctSetValue: Vars[Name] := Res;
    ctFunction: Result := FALSE;
  end;
end;

function TCalculator.NameOf(Index: Word): String;
begin
  Result := StrPas(PNamedVar(FVars[Index])^.Name);
end;

procedure TCalculator.ClearVars;
var
  i: Integer;
  V: PNamedVar;
begin
  for i := 0 to FVars.Count-1 do begin
    V := FVars[i];
    FreeMem(V, sizeof(TNamedVar)+StrLen(V^.Name));
    FVars[i] := Nil;
  end;
  FVars.Clear;
end;

begin
end.

