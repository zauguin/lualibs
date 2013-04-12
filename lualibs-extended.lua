--  This is file `lualibs-extended.lua',
module('lualibs-extended', package.seeall)

local lualibs_basic_module = {
  name          = "lualibs-extended",
  version       = 1.01,
  date          = "2013/04/10",
  description   = "Basic Lua extensions, meta package.",
  author        = "Hans Hagen, PRAGMA-ADE, Hasselt NL & Elie Roux",
  copyright     = "PRAGMA ADE / ConTeXt Development Team",
  license       = "See ConTeXt's mreadme.pdf for the license",
}

--[[doc--
Here we define some functions that fake the elaborate logging/tracking
mechanism Context provides.
--doc]]--
local error, logger, mklog
if luatexbase and luatexbase.provides_module then
  --- TODO test how those work out when running tex
  local __error,_,_,__logger = luatexbase.provides_module(lualibs_module)
  error  = __error
  logger = __logger
  mklog = function ( ) return logger end
else
  local texiowrite    = texio.write
  local texiowrite_nl = texio.write_nl
  local stringformat  = string.format
  mklog = function (t)
    local prefix = stringformat("[%s] ", t)
    return function (...)
      texiowrite_nl(prefix)
      texiowrite   (stringformat(...))
    end
  end
  error  = mklog"ERROR"
  logger = mklog"INFO"
end

--[[doc--
We temporarily put our own global table in place and restore whatever
we overloaded afterwards.

\CONTEXT\ modules each have a custom logging mechanism that can be
enabled for debugging.
In order to fake the presence of this facility we need to define at
least the function \verb|logs.reporter|.
For now it’s sufficient to make it a reference to \verb|mklog| as
defined above.
--doc]]--

local dummy_function = function ( ) end
local newline        = function ( ) texiowrite_nl"" end

local fake_logs = function (name)
  return {
    name     = name,
    enable   = dummy_function,
    disable  = dummy_function,
    reporter = mklog,
    newline  = newline
  }
end

local fake_trackers = function (name)
  return {
    name     = name,
    enable   = dummy_function,
    disable  = dummy_function,
    register = mklog,
    newline  = newline,
  }
end

local backup_store
local fake_context = function ( )
  if not backup_store then
    backup_store = utilities.storage.allocate()
  end
  if _G.logs     then backup_store.logs     = _G.logs     end
  if _G.trackers then backup_store.trackers = _G.trackers end
  _G.logs     = fake_logs"logs"
  _G.trackers = fake_trackers"trackers"
end

--[[doc--
Restore a backed up logger if appropriate.
--doc]]--
local unfake_context = function ( )
  if backup_store then
    local bl, bt = backup_store.logs, backup_store.trackers
    if bl then _G.logs     = bl end
    if bt then _G.trackers = bt end
  end
end

local loadmodule = lualibs.loadmodule

loadmodule("lualibs-util-str.lua")--- string formatters (fast)
loadmodule("lualibs-util-tab.lua")--- extended table operations
loadmodule("lualibs-util-sto.lua")--- storage (hash allocation)
----------("lualibs-util-pck.lua")---!packers; necessary?
----------("lualibs-util-seq.lua")---!sequencers (function chaining)
----------("lualibs-util-mrg.lua")---!only relevant in mtx-package
loadmodule("lualibs-util-prs.lua")--- miscellaneous parsers; cool. cool cool cool
----------("lualibs-util-fmt.lua")---!column formatter (rarely used)
loadmodule("lualibs-util-dim.lua")--- conversions between dimensions
loadmodule("lualibs-util-jsn.lua")--- JSON parser


fake_context()
----------("lualibs-trac-set.lua")---!generalization of trackers
----------("lualibs-trac-log.lua")---!logging
loadmodule("lualibs-trac-inf.lua")--- timing/statistics
loadmodule("lualibs-util-lua.lua")--- operations on lua bytecode
loadmodule("lualibs-util-deb.lua")--- extra debugging
loadmodule("lualibs-util-tpl.lua")--- templating

unfake_context() --- TODO check if this works at runtime

-- vim:tw=71:sw=2:ts=2:expandtab
--  End of File `lualibs-extended.lua'.