#
# Copyright (C) 2013-2014 wrtnode.com
# Copyright (C) 2015-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=opencv
PKG_VERSION:=3.3.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).zip
PKG_SOURCE_URL:=http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/$(PKG_VERSION)/
PKG_MD5SUM:=cc586ebe960a7cdd87100e89088abc06

PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=LICENSE


PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/opencv/Default/description
 OpenCV (Open Source Computer Vision Library) is an open source computer
 vision and machine learning software library. OpenCV was built to provide
 a common infrastructure for computer vision applications and to accelerate
 the use of machine perception in the commercial products. Being a
 BSD-licensed product, OpenCV makes it easy for businesses to utilize
 and modify the code.
endef

define Package/opencv
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=OpenCV
  URL:=http://opencv.org/
  MAINTAINER:=WRTnode Team <pub@wrtnode.com>
  DEPENDS:=+libpthread +librt +libstdcpp +zlib +libjpeg +glib2 +armcl +mali-opencl
endef

PKG_INSTALL:=1

#CMAKE_OPTIONS += -DBUILD_opencv_gpu:BOOL=OFF \
	-DWITH_1394:BOOL=OFF -DBUILD_opencv_stitching:BOOL=OFF \
	-DWITH_FFMPEG:BOOL=OFF \
	-DWITH_GSTREAMER:BOOL=OFF \
	-DWITH_LIBV4L:BOOL=OFF \
	-DCMAKE_VERBOSE:BOOL=OFF \

CMAKE_OPTIONS +=  -DWITH_PNG:BOOL=OFF -DWITH_FFMPEG:BOOL=OFF -DWITH_GSTREAMER:BOOL=OFF

MAKE_PATH:=build
CMAKE_SOURCE_DIR:=${PKG_BUILD_DIR}
define Build/Configure/Default
	(mkdir -p $(PKG_BUILD_DIR)/build; cd $(PKG_BUILD_DIR)/build; \
		CFLAGS="$(TARGET_CFLAGS) $(EXTRA_CFLAGS)" \
		CXXFLAGS="$(TARGET_CFLAGS) $(EXTRA_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(EXTRA_LDFLAGS)" \
		cmake \
			-DCMAKE_SYSTEM_NAME=Linux \
			-DCMAKE_SYSTEM_VERSION=1 \
			-DCMAKE_SYSTEM_PROCESSOR=$(ARCH) \
			-DCMAKE_BUILD_TYPE=Release \
			-DCMAKE_C_FLAGS_RELEASE="-DNDEBUG" \
			-DCMAKE_CXX_FLAGS_RELEASE="-DNDEBUG" \
			-DCMAKE_C_COMPILER="$(CMAKE_C_COMPILER)" \
			-DCMAKE_C_COMPILER_ARG1="$(CMAKE_C_COMPILER_ARG1)" \
			-DCMAKE_CXX_COMPILER="$(CMAKE_CXX_COMPILER)" \
			-DCMAKE_CXX_COMPILER_ARG1="$(CMAKE_CXX_COMPILER_ARG1)" \
			-DCMAKE_ASM_COMPILER="$(CMAKE_C_COMPILER)" \
			-DCMAKE_ASM_COMPILER_ARG1="$(CMAKE_C_COMPILER_ARG1)" \
			-DCMAKE_EXE_LINKER_FLAGS:STRING="$(TARGET_LDFLAGS)" \
			-DCMAKE_MODULE_LINKER_FLAGS:STRING="$(TARGET_LDFLAGS) $(CMAKE_SHARED_LDFLAGS)" \
			-DCMAKE_SHARED_LINKER_FLAGS:STRING="$(TARGET_LDFLAGS) $(CMAKE_SHARED_LDFLAGS)" \
			-DCMAKE_AR="$(CMAKE_AR)" \
			-DCMAKE_NM="$(CMAKE_NM)" \
			-DCMAKE_RANLIB="$(CMAKE_RANLIB)" \
			-DCMAKE_FIND_ROOT_PATH="$(CMAKE_FIND_ROOT_PATH)" \
			-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=BOTH \
			-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
			-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
			-DCMAKE_STRIP=: \
			-DCMAKE_INSTALL_PREFIX=/usr \
			-DDL_LIBRARY=$(STAGING_DIR) \
			-DCMAKE_PREFIX_PATH=$(STAGING_DIR) \
			-DCMAKE_SKIP_RPATH=TRUE  \
			$(CMAKE_OPTIONS) \
		$(CMAKE_SOURCE_DIR) \
	)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/share
	$(CP) $(PKG_INSTALL_DIR)/usr/share $(1)/usr/

	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/opencv $(1)/usr/include/
	$(CP) $(PKG_INSTALL_DIR)/usr/include/opencv2 $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libopencv* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/opencv.pc $(1)/usr/lib/pkgconfig/
endef

define Package/opencv/install
	$(INSTALL_DIR) $(1)/usr/share
	$(CP) $(PKG_INSTALL_DIR)/usr/share $(1)/usr/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libopencv* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,opencv))
