#!/bin/bash
# shellcheck disable=SC1090
set -e

SCRIPT_DIR=${BR2_EXTERNAL_HASSOS_PATH}/scripts
BOARD_DIR=${2}

. "${BR2_EXTERNAL_HASSOS_PATH}/meta"
. "${BOARD_DIR}/meta"

. "${SCRIPT_DIR}/rootfs-layer.sh"
. "${SCRIPT_DIR}/name.sh"
. "${SCRIPT_DIR}/rauc.sh"


# HassOS tasks
fix_rootfs
install_tini_docker
#install_hassos_cli

# Write os-release
# shellcheck disable=SC2153
(
    echo "NAME=\"${HASSOS_NAME}\""
    echo "VERSION=\"${VERSION_MAJOR}.${VERSION_BUILD} (${BOARD_NAME})\""
    echo "ID=${HASSOS_ID}"
    echo "VERSION_ID=${VERSION_MAJOR}.${VERSION_BUILD}"
    echo "PRETTY_NAME=\"${HASSOS_NAME} ${VERSION_MAJOR}.${VERSION_BUILD}\""
    echo "CPE_NAME=cpe:2.3:o:getchannels.com:${HASSOS_ID}:${VERSION_MAJOR}.${VERSION_BUILD}:*:${DEPLOYMENT}:*:*:*:${BOARD_ID}:*"
    echo "HOME_URL=https://getchannels.com/"
    echo "VARIANT=\"${HASSOS_NAME} ${BOARD_NAME}\""
    echo "VARIANT_ID=${BOARD_ID}"
) > "${TARGET_DIR}/usr/lib/os-release"

# Write machine-info
(
    echo "CHASSIS=${CHASSIS}"
    echo "DEPLOYMENT=${DEPLOYMENT}"
) > "${TARGET_DIR}/etc/machine-info"

# Channels DVR (remove hassos customizations)
rm -f "${TARGET_DIR}"/usr/libexec/hassos-{apparmor,data}
rm -f "${TARGET_DIR}"/usr/bin/datactl
rm -f "${TARGET_DIR}"/usr/sbin/hassos-{cli,supervisor}
rm -f "${TARGET_DIR}"/usr/libexec/hassos-{apparmor,data}
rm -f "${TARGET_DIR}"/usr/lib/systemd/system/hassos-{supervisor,apparmor,data}.service
rm -f "${TARGET_DIR}"/etc/systemd/system/*getty*service.d/hassos.conf
rm -f "${TARGET_DIR}"/etc/systemd/system/dropbear.service.d/docker.conf
rm -f "${TARGET_DIR}"/etc/avahi/services/{sftp-ssh,ssh}.service
sed -i "s|\(root:.*\)/bin/sh|\1/bin/bash|" "${TARGET_DIR}/etc/passwd"
mkdir -p "${TARGET_DIR}/media"
touch "${TARGET_DIR}/etc/channelsdistro"

# Setup RAUC
write_rauc_config
install_rauc_certs
install_bootloader_config

# Fix overlay presets
"${HOST_DIR}/bin/systemctl" --root="${TARGET_DIR}" preset-all
