#
# Copyright (C) 2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/Horseradish
  NAME:=Horseradish
endef

define Profile/Horseradish/Description
	Horseradish board
endef

$(eval $(call Profile,Horseradish))

