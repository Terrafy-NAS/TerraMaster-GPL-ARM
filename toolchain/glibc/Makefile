PATH_PREFIX := .
VARIANT:=final
HOST_BUILD_PARALLEL:=0

include ./common.mk

define Host/Compile
	$(MAKE) -C $(CUR_BUILD_DIR) \
		PARALLELMFLAGS="$(HOST_JOBS)" \
		BUILD_CFLAGS="$(HOST_CFLAGS)" \
		all
endef

define Host/Install
	$(call Host/SetToolchainInfo)
	$(MAKE) -C $(CUR_BUILD_DIR) \
		BUILD_CFLAGS="$(HOST_CFLAGS)" \
		install_root="$(TOOLCHAIN_DIR)" \
		install
	( cd $(TOOLCHAIN_DIR) ; \
		for d in lib usr/lib ; do \
		  for f in libc.so libpthread.so libgcc_s.so ; do \
		    if [ -f $$$$d/$$$$f -a ! -L $$$$d/$$$$f ] ; then \
		      $(SED) 's,/usr/lib/,,g;s,/lib/,,g' $$$$d/$$$$f ; \
		    fi \
		  done \
		done \
	)
	$(call Host/PatchShebang)
endef

$(eval $(call HostBuild))
