# Use the default kernel version if the Makefile doesn't override it

LINUX_RELEASE?=1

LINUX_VERSION-3.10 = .24
LINUX_VERSION-3.18 = .21
LINUX_VERSION-4.1 = .7
LINUX_VERSION-4.4 = .18

#LINUX_KERNEL_MD5SUM-3.10.24 = 01f4ecbec71c2b1cc68509ee595d6233
LINUX_KERNEL_MD5SUM-3.18.21 = e4248caaa4cef318c04657e971b37298
LINUX_KERNEL_MD5SUM-4.4.18 = e728f3d03930b19242e5c7d135611590

ifdef KERNEL_PATCHVER
  LINUX_VERSION:=$(KERNEL_PATCHVER)$(strip $(LINUX_VERSION-$(KERNEL_PATCHVER)))
endif

split_version=$(subst ., ,$(1))
merge_version=$(subst $(space),.,$(1))
KERNEL_BASE=$(firstword $(subst -, ,$(LINUX_VERSION)))
KERNEL=$(call merge_version,$(wordlist 1,2,$(call split_version,$(KERNEL_BASE))))
KERNEL_PATCHVER ?= $(KERNEL)

# disable the md5sum check for unknown kernel versions
LINUX_KERNEL_MD5SUM:=$(LINUX_KERNEL_MD5SUM-$(strip $(LINUX_VERSION)))
LINUX_KERNEL_MD5SUM?=x
