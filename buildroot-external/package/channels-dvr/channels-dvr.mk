################################################################################
#
# Channels DVR
#
################################################################################

CHANNELS_DVR_VERSION = 1.0.0

define CHANNELS_DVR_BUILD_CMDS
	
endef

define CHANNELS_DVR_INSTALL_TARGET_CMDS
	dd if=/dev/zero of=$(BINARIES_DIR)/data.ext4 bs=4G count=1
	mkfs.ext4 -L "hassos-data" -E lazy_itable_init=0,lazy_journal_init=0 $(BINARIES_DIR)/data.ext4
endef

$(eval $(generic-package))
