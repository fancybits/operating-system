################################################################################
#
# exfat-linux
#
################################################################################

EXFAT_LINUX_VERSION = 4a5c1b2064f2ceb03c34c94f9b331191e8683cee
EXFAT_LINUX_SITE = $(call github,namjaejeon,linux-exfat-oot,$(EXFAT_LINUX_VERSION))
EXFAT_LINUX_LICENSE = GPL-2.0
EXFAT_LINUX_LICENSE_FILES = LICENSE
EXFAT_LINUX_MODULE_MAKE_OPTS = CONFIG_EXFAT_FS=m CONFIG_EXFAT_VIRTUAL_XATTR=y

$(eval $(kernel-module))
$(eval $(generic-package))
