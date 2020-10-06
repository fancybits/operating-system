################################################################################
#
# Channels DVR
#
################################################################################

CHANNELS_DVR_VERSION = 1.0.0
CHANNELS_DVR_SITE = $(BR2_EXTERNAL_HASSOS_PATH)/package/channels-dvr
CHANNELS_DVR_SITE_METHOD = local
CHANNELS_DVR_BUILD_VERSION = 2020.10.06.2128

define CHANNELS_DVR_USERS
	channels 501 channels 501 * /mnt/data/channels-dvr/data - video Channels
endef

define CHANNELS_DVR_INSTALL_TARGET_CMDS
	sudo umount /mnt/data || true
	dd if=/dev/zero of=$(BINARIES_DIR)/data.ext4 bs=4G count=1
	mkfs.ext4 -L "hassos-data" -E lazy_itable_init=0,lazy_journal_init=0 $(BINARIES_DIR)/data.ext4
	mkdir -p /mnt/data/
	sudo mount -o loop,umask=0022,gid=$(id -g),uid=$(id -u) $(BINARIES_DIR)/data.ext4 /mnt/data

	mkdir -p /mnt/data/channels-dvr/{data,$(CHANNELS_DVR_BUILD_VERSION)}
	curl "https://channels-dvr.s3.amazonaws.com/$(CHANNELS_DVR_BUILD_VERSION)/ffmpeg-linux-arm64" -o /mnt/data/channels-dvr/$(CHANNELS_DVR_BUILD_VERSION)/ffmpeg
	curl "https://channels-dvr.s3.amazonaws.com/$(CHANNELS_DVR_BUILD_VERSION)/ffprobe-linux-arm64" -o /mnt/data/channels-dvr/$(CHANNELS_DVR_BUILD_VERSION)/ffprobe
	curl "https://channels-dvr.s3.amazonaws.com/$(CHANNELS_DVR_BUILD_VERSION)/comskip-linux-arm64" -o /mnt/data/channels-dvr/$(CHANNELS_DVR_BUILD_VERSION)/comskip
	curl "https://channels-dvr.s3.amazonaws.com/$(CHANNELS_DVR_BUILD_VERSION)/channels-dvr-linux-arm64" -o /mnt/data/channels-dvr/$(CHANNELS_DVR_BUILD_VERSION)/channels-dvr
	chmod +x /mnt/data/channels-dvr/$(CHANNELS_DVR_BUILD_VERSION)/*
	curl -f -s "https://channels-dvr.s3.amazonaws.com/$(CHANNELS_DVR_BUILD_VERSION)/linux-arm64.sha256" -o /mnt/data/channels-dvr/$(CHANNELS_DVR_BUILD_VERSION)/linux-arm64.sha256
	ln -nsf /mnt/data/channels-dvr/$(CHANNELS_DVR_BUILD_VERSION) /mnt/data/channels-dvr/latest
	chown -R 501:501 /mnt/data/channels-dvr

	if ! sudo umount /mnt/data; then
		sudo umount -f /mnt/data || echo "umount force fails!"
	fi
endef

$(eval $(generic-package))
