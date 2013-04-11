--  This is file `lualibs-basic.lua',
module('lualibs-basic', package.seeall)

local lualibs_basic_module = {
  name          = "lualibs-basic",
  version       = 1.01,
  date          = "2013/04/10",
  description   = "Basic Lua extensions, meta package.",
  author        = "Hans Hagen, PRAGMA-ADE, Hasselt NL & Elie Roux",
  copyright     = "PRAGMA ADE / ConTeXt Development Team",
  license       = "See ConTeXt's mreadme.pdf for the license",
}

if luatexbase and luatexbase.provides_module then
  local _,_,_ = luatexbase.provides_module(lualibs_module)
end

local loadmodule = lualibs.loadmodule

loadmodule("lualibs-lua.lua")
loadmodule("lualibs-lpeg.lua")
loadmodule("lualibs-function.lua")
loadmodule("lualibs-string.lua")
loadmodule("lualibs-table.lua")
loadmodule("lualibs-boolean.lua")
loadmodule("lualibs-number.lua")
loadmodule("lualibs-math.lua")
loadmodule("lualibs-io.lua")
loadmodule("lualibs-os.lua")
loadmodule("lualibs-file.lua")
loadmodule("lualibs-md5.lua")
loadmodule("lualibs-dir.lua")
loadmodule("lualibs-unicode.lua")
loadmodule("lualibs-url.lua")
loadmodule("lualibs-set.lua")

-- these don’t look much basic to me:
--l-pdfview.lua
--l-xml.lua


-- vim:tw=71:sw=2:ts=2:expandtab
--  End of File `lualibs.lua'.