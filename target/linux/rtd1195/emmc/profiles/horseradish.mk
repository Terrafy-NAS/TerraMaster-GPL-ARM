#
# Copyright (C) 2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/Horseradish
  NAME:=Horseradish board other than V2.0
endef

define Profile/Horseradish/Description
	Horseradish board
endef

$(eval $(call Profile,Horseradish))

define Profile/HorseradishV2
  NAME:=Horseradish board V2.0
endef

define Profile/HorseradishV2/Description
	Horseradish board V2.0
endef

$(eval $(call Profile,HorseradishV2))

