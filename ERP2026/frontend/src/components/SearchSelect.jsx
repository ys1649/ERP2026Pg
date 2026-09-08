import { useState, useEffect, useCallback } from 'react'
import { Select } from 'antd'

export function SearchSelect({ fetcher, valueField, labelFn, value, initialLabel, onChange, placeholder, disabled, style }) {
  const [options, setOptions] = useState([])
  const [loading, setLoading] = useState(false)

  const search = useCallback(async (q) => {
    setLoading(true)
    try {
      const res = await fetcher(q)
      const rows = res.data.data || res.data
      setOptions(rows.map((r) => ({ value: r[valueField], label: labelFn(r) })))
    } catch {
      setOptions([])
    } finally {
      setLoading(false)
    }
  }, [fetcher, valueField, labelFn])

  // eslint-disable-next-line react-hooks/exhaustive-deps
  useEffect(() => { search('') }, [])

  const hasCurrent = value != null && options.some((o) => o.value === value)
  const mergedOptions = (!hasCurrent && value != null)
    ? [{ value, label: initialLabel || value }, ...options]
    : options

  return (
    <Select
      showSearch
      allowClear
      filterOption={false}
      loading={loading}
      onSearch={search}
      options={mergedOptions}
      value={value || undefined}
      onChange={onChange}
      placeholder={placeholder}
      disabled={disabled}
      style={style}
    />
  )
}
