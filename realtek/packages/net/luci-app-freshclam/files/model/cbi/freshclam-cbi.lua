--[[

LuCI Freshclam module

Copyright (C) 2015, Itus Networks, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Author: Marko Ratkaj <marko.ratkaj@sartura.hr>
	Luka Perkov <luka.perkov@sartura.hr>

]]--

local fs = require "nixio.fs"
local sys = require "luci.sys"
require "ubus"

m = Map("freshclam", translate("Freshclam"))
m.on_after_commit = function() luci.sys.call("/etc/init.d/freshclam restart") end

s = m:section(TypedSection, "freshclam")
s.anonymous = true
s.addremove = false

s:tab("tab_advanced", translate("Settings"))
s:tab("tab_logs", translate("Log"))

--------------- Settings --------------

UpdateLogFile = s:taboption("tab_advanced", TextValue, "UpdateLogFile", translate("Path of log file"))
UpdateLogFile.default = "/tmp/freshclam.log"

DatabaseMirror = s:taboption("tab_advanced", TextValue, "DatabaseMirror", translate("URL of ClamAV database mirror"))
DatabaseMirror.default = "database.clamav.net"

NotifyClamd = s:taboption("tab_advanced", TextValue, "NotifyClamd", translate("Path of config file of ClamAV"))
NotifyClamd.default = "/etc/clamav/clamd.conf"

DatabaseOwner = s:taboption("tab_advanced", TextValue, "DatabaseOwner", translate("Owner of ClamAV database"))
DatabaseOwner.default = "root"

CompressLocalDatabase = s:taboption("tab_advanced", ListValue, "CompressLocalDatabase", translate("Compress local ClamAV database"))
CompressLocalDatabase:value("no",  translate("No"))
CompressLocalDatabase:value("yes",  translate("Yes"))
CompressLocalDatabase.default = "yes"

------------------ Log --------------------

freshclam_logfile = s:taboption("tab_logs", TextValue, "lines", "")
freshclam_logfile.wrap = "off"
freshclam_logfile.rows = 25
freshclam_logfile.rmempty = true

function freshclam_logfile.cfgvalue()
	local uci = require "luci.model.uci".cursor_state()
	local file = "/tmp/freshclam.log"
	if file then
		return fs.readfile(file) or ""
	else
		return ""
	end
end

function freshclam_logfile.write()
end

return m
