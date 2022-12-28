#
# Copyright (C) 2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/Transcend
  NAME:=Transcend
endef

define Profile/Transcend/Description
	Transcend NAS/Wifi HDD boards
endef

$(eval $(call Profile,Transcend))

