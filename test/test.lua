#!/usr/bin/env lua5.2
local column = require("column")

column([[Dieser Buffer enthält Zeilen mit
Wörtern ganz ausgesprochen unterschiedlicher Länge, die
nun in ihre Glieder gesplittet und in
Spalten ausgegeben werden.
Dabei werden auch Unwörter mit mehreren Umlauten wie öäüÜÖÄ korrekt ausgegeben.]], io.stdout, "    ", "*")


