#
# Copyright (C) 2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/MediaNAS
  NAME:=MediaNAS
endef

define Profile/MediaNAS/Description
	MediaNAS V0.1 board with 3-bay HDD support
endef

$(eval $(call Profile,MediaNAS))

