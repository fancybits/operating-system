#!/bin/bash

function hassos_image_name() {
    local filenamever = $(hassos_version | sed -e 's,\.,,g')
    echo "${BINARIES_DIR}/${HASSOS_ID}_${BOARD_ID}_${filenamever}.${1}"
}

function hassos_rauc_compatible() {
    echo "${HASSOS_ID}-${BOARD_ID}"
}

function hassos_version() {
    echo "${VERSION_MAJOR}.${VERSION_BUILD}"
}

function path_spl_img() {
    echo "${BINARIES_DIR}/spl.img"
}

function path_kernel_img() {
    echo "${BINARIES_DIR}/kernel.ext4"
}

function path_boot_img() {
    echo "${BINARIES_DIR}/boot.vfat"
}

function path_boot_dir() {
    echo "${BINARIES_DIR}/boot"
}

function path_data_img() {
    echo "${BINARIES_DIR}/data.ext4"
}

function path_overlay_img() {
    echo "${BINARIES_DIR}/overlay.ext4"
}

function path_rootfs_img() {
    echo "${BINARIES_DIR}/rootfs.squashfs"
}

