#!/usr/bin/env lua

-- column.lua - columnate multi-line strings
-- Copyright (C) 2013 Jens Oliver John <asterisk@2ion.de>
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

local strlen_ger_utf8_t = { [0xc3] = { 0xa4, 0x84, 0xbc, 0x9c, 0xb6, 0x96, 0x9f } }

-- FIXME: check also the byte *after* occurences of 0xc3 (and keep the
-- loop for that)
local function strlen_ger_utf8(w)
    local s = {}
    local len = 0
    w:gsub("(.)", function (c)
        table.insert(s, c:byte())
    end)
    for i=1,#s do
        if strlen_ger_utf8_t[s[i]] then
            i = i + 1
        else
            len = len + 1
        end
    end
    return len
end

return function (s, ofile, sep, blind)
    local s = s
    local sep = sep or "    "
    local blind = blind or ""
    local ofile = ofile or io.stdout

    local y = {}
    local x = {}
    local cm = 0
    local i = 0

    for line in s:gmatch("[^\r\n]+") do
        local ly = {}
        local cc = 0
        line:gsub("[^%s]+", function (m)
            local len = #m
            cc = cc + 1
            if cc > cm then 
                x[cc] = 0
                cm = cc
            end
            if len > x[cc] then
                x[cc] = len
            end
            table.insert(ly, m)
        end)
        table.insert(y, ly)
    end
    for _,line in ipairs(y) do
        for tmp=1,(#x-#line) do
            table.insert(line, blind)
        end
        for i,word in ipairs(line) do
            -- workaround for common German utf-8 umlauts
            local wl = word:match("[öäüÖÄÜß]") and strlen_ger_utf8(word) or #word
            if wl < x[i] then
                for tmp=1,(x[i]-wl) do
                    word = word .. " "
                end
            end
           ofile:write(word .. sep)
        end
        ofile:write("\n")
    end
end
