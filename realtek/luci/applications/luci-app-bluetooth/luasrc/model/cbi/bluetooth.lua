-- Copyright 2012 Gabor Juhos <juhosg@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

local m, s, o

m = Map("bluetooth", translate("Bluetooth"),
	translate("Bluetooth."))

m:section(SimpleSection).template  = "bluetooth_status"

s = m:section(TypedSection, "bluetoothd", "Bluetooth Settings")
s.addremove = false
s.anonymous = true

o = s:option(Flag, "enabled", translate("Enable:"))
o.rmempty = false

function o.write(self, section, value)
	if value == "1" then
		luci.sys.init.enable("bluetooth")
		luci.sys.call("/etc/init.d/bluetoothd start >/dev/null")
	else
		luci.sys.call("/etc/init.d/bluetoothd stop >/dev/null")
		luci.sys.init.disable("bluetooth")
	end

	return Flag.write(self, section, value)
end


o = s:option(Value, "name", translate("Adapter name:"),
	translate("Set this if you want to customize the name that shows up on other BT devices."))
o.rmempty = true
o.placeholder = "OpenWRT BT"

return m
