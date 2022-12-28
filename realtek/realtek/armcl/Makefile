#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=armcl
PKG_VERSION:=17.12
PKG_RELEASE:=1

PKG_SOURCE:=v$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/ARM-software/ComputeLibrary/archive/
PKG_MD5SUM:=f0226b3bfc752847509a28ac14298522
PKG_BUILD_DIR ?= $(BUILD_DIR)/ComputeLibrary-$(PKG_VERSION)
PKG_LICENSE:=MIT

#PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/scons.mk

define Package/armcl
  SECTION:=libs
  CATEGORY:=Libraries
  SUBMENU:=Mali
  TITLE:=ARM Compute Library for computer vision and machine learning
  URL:=https://developer.arm.com/technologies/compute-library
  DEPENDS:=+libstdcpp
  DEPENDS+= +kmod-lib-mali +mali-opencl
endef

define Package/armcl/description
       The Compute Library is a collection of low-level functions optimized
       for Arm CPU and GPU architectures targeted at image processing,
       computer vision, and machine learning. It is available free of charge
       under a permissive MIT open source license.

       The Compute Library contains a comprehensive collection of software
       functions implemented for the Arm Cortex-A family of CPU processors
       and the Arm Mali family of GPUs. It is a convenient repository of
       low-level optimized functions that developers can source individually
       or use as part of complex pipelines in order to accelerate their
       algorithms and applications.
endef

#scons Werror=1 debug=0 asserts=0 neon=1 opencl=1 os=linux arch=armv7a examples=1
SCONS_OPTIONS+= Werror=1 debug=0 asserts=0 neon=1 opencl=1 os=linux build=native examples=1
ifeq ($(BOARD), rtd1295)
SCONS_OPTIONS+= arch=arm64-v8a
else ifeq ($(BOARD), rtd1195)
SCONS_OPTIONS+= arch=armv7a
endif
SCONS_OPTIONS+= -j $(shell grep -c ^processor /proc/cpuinfo)

define Build/Configure
	(cd $(PKG_BUILD_DIR); \
		$(SCONS_VARS) \
		scons \
			prefix=/usr \
			$(SCONS_OPTIONS) \
	)
endef

#define Build/Install
#endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/build/*.{a,so} $(1)/usr/lib/
endef

examples=
# OpenCL examples
examples+= cl_convolution cl_events graph_alexnet graph_lenet neoncl_scale_median_gaussian
# NEON examples
examples+= neon_cartoon_effect neon_cnn neon_convolution neon_copy_objects neon_scale
define Package/armcl/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DIR) $(1)/usr/local/bin
	$(CP) $(PKG_BUILD_DIR)/build/*.so $(1)/usr/lib/
	for bin in $(examples); do \
	    $(CP) $(PKG_BUILD_DIR)/build/examples/$$$$bin $(1)/usr/local/bin/; \
	done
	$(CP) $(PKG_BUILD_DIR)/src/core/CL/cl_kernels $(1)/usr/local/bin/
endef

$(eval $(call BuildPackage,armcl))
