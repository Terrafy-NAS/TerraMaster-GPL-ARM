-- Copyright 2012 Gabor Juhos <juhosg@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.bluetooth", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/bluetooth") then
		return
	end

	local page

	page = entry({"admin", "network", "bluetooth"}, cbi("bluetooth"), _("Bluetooth"))
	page.dependent = true

	entry({"admin", "network", "bluetooth_status"}, call("bluetooth_status"))
	entry({"admin", "network", "bluetooth_advertise"}, call("bluetooth_advertise"))
	entry({"admin", "network", "bluetooth_no_advertise"}, call("bluetooth_no_advertise"))
end

function bluetooth_status()
	local sys  = require "luci.sys"
	local uci  = require "luci.model.uci".cursor()

	local status = {
		running = (sys.call("pgrep bluetoothd >/dev/null && hciconfig hci0 | grep RUNNING >/dev/null") == 0)
	}

	luci.http.prepare_content("application/json")
	luci.http.write_json(status)
end

function bluetooth_advertise()
	local sys  = require "luci.sys"
	local uci  = require "luci.model.uci".cursor()

	sys.call("hciconfig hci0 piscan")
	sys.call("hciconfig hci0 leadv")
	luci.http.redirect(luci.dispatcher.build_url("admin/network/bluetooth"))
end

function bluetooth_no_advertise()
	local sys  = require "luci.sys"
	local uci  = require "luci.model.uci".cursor()

	sys.call("hciconfig hci0 noscan")
	sys.call("hciconfig hci0 noleadv")
	luci.http.redirect(luci.dispatcher.build_url("admin/network/bluetooth"))
end
