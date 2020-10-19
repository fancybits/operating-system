#############################################################
#
# wsdd2
#
#############################################################
WSDD2_VERSION = 4e6845046698dfa068cf3434887100ca3f283b64
WSDD2_SITE = $(call github,Andy2244,wsdd2,$(WSDD2_VERSION))
WSDD2_LICENSE = GPL-3
WSDD2_LICENSE_FILES = LICENSE
WSDD2_INSTALL_STAGING = YES

define WSDD2_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define WSDD2_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) PREFIX=/usr install
endef

$(eval $(generic-package))
