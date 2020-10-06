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
	dd if=/dev/zero of=$(BINARIES_DIR)/data.ext4 bs=4G count=1
	mkfs.ext4 -L "hassos-data" -E lazy_itable_init=0,lazy_journal_init=0 $(BINARIES_DIR)/data.ext4
	mkdir -p /mnt/data/
	sudo mount -o loop $(BINARIES_DIR)/data.ext4 /mnt/data

	cd /mnt/data
	mkdir -p channels-dvr/$(CHANNELS_DVR_BUILD_VERSION)
	cd channels-dvr/$(CHANNELS_DVR_BUILD_VERSION)
	curl -f -s "https://channels-dvr.s3.amazonaws.com/$(CHANNELS_DVR_BUILD_VERSION)/ffmpeg-linux-arm64" -o ffmpeg
	curl -f -s "https://channels-dvr.s3.amazonaws.com/$(CHANNELS_DVR_BUILD_VERSION)/ffprobe-linux-arm64" -o ffprobe
	curl -f -s "https://channels-dvr.s3.amazonaws.com/$(CHANNELS_DVR_BUILD_VERSION)/comskip-linux-arm64" -o comskip
	curl -f -s "https://channels-dvr.s3.amazonaws.com/$(CHANNELS_DVR_BUILD_VERSION)/channels-dvr-linux-arm64" -o channels-dvr
	chmod +x *
	curl -f -s "https://channels-dvr.s3.amazonaws.com/$(CHANNELS_DVR_BUILD_VERSION)/linux-arm64.sha256" -o linux-arm64.sha256
	cd ../
	ln -nsf $(CHANNELS_DVR_BUILD_VERSION) latest
	mkdir -p data
	cd ..
	chown -R 501:501 channels-dvr

	if ! sudo umount /mnt/data; then
		sudo umount -f /mnt/data || echo "umount force fails!"
	fi
endef

$(eval $(generic-package))
