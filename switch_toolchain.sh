#!/bin/bash

TARGET_CONFIG=.config

if grep -q "CONFIG_TARGET_rtd1295=y" $TARGET_CONFIG; then
    TARGET_NAME="aarch64-openwrt-linux"
    TOOLCHAIN_SUFFIX="aarch64_cortex-a53+neon_gcc-4.9-linaro_glibc-2.19"
else
    TARGET_NAME="arm-openwrt-linux"
    TOOLCHAIN_SUFFIX="arm_cortex-a7+neon_gcc-4.9-linaro_glibc-2.19_eabi"
fi

# Pre-built
read -r -d '' prebuilt_opts << EOM
CONFIG_EXTERNAL_TOOLCHAIN=y
# CONFIG_NATIVE_TOOLCHAIN is not set
CONFIG_TARGET_NAME="${TARGET_NAME}"
CONFIG_TOOLCHAIN_PREFIX="${TARGET_NAME}-"
CONFIG_TOOLCHAIN_ROOT="\$(TOPDIR)/staging_dir/toolchain-${TOOLCHAIN_SUFFIX}"
CONFIG_TOOLCHAIN_LIBC="glibc"
# CONFIG_USE_EXTERNAL_LIBC is not set
CONFIG_LDD_FILE_SPEC="./bin/ldd"
EOM

# Rebuild toolchain
read -r -d '' toolchain_opts << EOM
# CONFIG_EXTERNAL_TOOLCHAIN is not set
CONFIG_NEED_TOOLCHAIN=y
CONFIG_TOOLCHAINOPTS=y
CONFIG_GCC_USE_VERSION_4_9_LINARO=y
CONFIG_EGLIBC_OPTION_EGLIBC_NIS=y
CONFIG_EGLIBC_OPTION_EGLIBC_SUNRPC=y
EOM

TOOLCHAIN_SRC="prebuilt scratch"
if [ "$1" = "" ]; then
    echo "Please select toolchain source:"
    select TOOLCHAIN in $TOOLCHAIN_SRC;
    do
        echo "$TOOLCHAIN selected!"
        break
    done
else
    TOOLCHAIN=$1
fi

case "$TOOLCHAIN" in
    prebuilt)
        echo "$prebuilt_opts" >> $TARGET_CONFIG
        yes "" | make oldconfig
    ;;
    scratch)
        echo "$toolchain_opts" >> $TARGET_CONFIG
        yes "" | make oldconfig
    ;;
    *)
        echo "Unsupported toolchain source:$TOOLCHAIN is selected!"
        exit 1
    ;;
esac
