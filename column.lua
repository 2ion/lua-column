#!./lua

assert(_VERSION == "Lua 5.3", "This program requires Lua 5.3")

local function columnate(s, csep, rsep)
  local r = { { {} } }
  for _,c in utf8.codes(s) do
    local c = utf8.char(c)
    local cr = r[#r]
    local cc = cr[#cr]
    if c == csep then
      table.insert(cr, {})
    elseif c == rsep then
      table.insert(r, {})
    else
      table.insert(cc, c)
    end
  end
end

columnate("Hello World", ' ')
