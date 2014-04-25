#!./lua

assert(_VERSION == "Lua 5.3", "This program requires Lua 5.3")

local function track_cwidth(rt, tt)
  local cr = rt[#rt]
  local ci = #cr
  local cmt = getmetatable(cr[ci])
  tt[ci] = math.max(tt[ci] or 0, cmt.width)
end

local function columnate(s, csep, rsep)

  local csep = csep or ' '
  local rsep = rsep or '\n'
  local s = s
  local r = { { {} } }
  local maxc = 0
  local maxcwidth = {}

  for _,c in utf8.codes(s) do
    local c = utf8.char(c)
    local cr = r[#r]
    if c == csep then
      track_cwidth(r, maxcwidth)
      table.insert(cr, {})
    elseif c == rsep then
      maxc = math.max(maxc, #cr)
      table.insert(r, {})
    else
      local cc = cr[#cr]
      local ccmt = getmetatable(cc) or getmetatable(setmetatable(cc, { width = 0 }))
      ccmt.width = ccmt.width + 1
      table.insert(cc, c)
    end
  end

  track_cwidth(r, maxcwidth) -- terminate column in tracking table

  for _,row in ipairs(r) do
    for ci,col in ipairs(row) do
      for i=1,(maxcwidth[ci]-getmetatable(col).width) do
        table.insert(col, ' ')
      end
    end
  end



end

columnate([[Hello World
Sauerstofflashe im Parfait]], ' ')
