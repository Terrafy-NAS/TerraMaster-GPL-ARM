#
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI Statistics Application
LUCI_DEPENDS:= \
	+collectd +rrdtool +collectd-mod-rrdtool +collectd-mod-iwinfo \
	+collectd-mod-interface +collectd-mod-load +collectd-mod-network

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
