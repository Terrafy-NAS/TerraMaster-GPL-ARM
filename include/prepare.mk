prepare: staging-install

staging-install:
	@( \
	mkdir -p staging_dir; \
	if ! ls staging_dir | grep -q ^toolchain-; then \
	    cd staging_dir; \
	    for part in ../prebuilt/staging_toolchain*.txz; do \
		tar --checkpoint=6000 -xf $$part; \
	    done; \
	fi; \
	)
