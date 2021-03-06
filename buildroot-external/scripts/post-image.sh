#!/bin/bash
# shellcheck disable=SC1090
set -e

SCRIPT_DIR=${BR2_EXTERNAL_HASSOS_PATH}/scripts
BOARD_DIR=${2}
HOOK_FILE=${3}

. "${BR2_EXTERNAL_HASSOS_PATH}/meta"
. "${BOARD_DIR}/meta"

. "${SCRIPT_DIR}/hdd-image.sh"
. "${SCRIPT_DIR}/rootfs-layer.sh"
. "${SCRIPT_DIR}/name.sh"
. "${SCRIPT_DIR}/rauc.sh"
. "${SCRIPT_DIR}/ota.sh"
. "${HOOK_FILE}"

# Cleanup
rm -rf "$(path_boot_dir)"
mkdir -p "$(path_boot_dir)"

# Hook pre image build stuff
hassos_pre_image

# Recovery
if [ -n "$DISTRO_RECOVERY_IMAGE" ]; then
  prepare_disk_image
  create_disk_image
  hassos_post_image
  exit 0
fi

# OTA
prepare_disk_image
create_ota_update

if [ -n "$DISTRO_OTA_ONLY" ]; then
  exit 0
fi

# Disk
create_disk_image
hassos_post_image
