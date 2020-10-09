#!/bin/bash
# shellcheck disable=SC2155

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"

    cp -t "${BOOT_DATA}" \
        "${BINARIES_DIR}/u-boot.bin" \
        "${BINARIES_DIR}/boot.scr"
    cp "${BINARIES_DIR}"/*.dtb "${BOOT_DATA}/"
    cp -r "${BINARIES_DIR}/rpi-firmware/overlays" "${BOOT_DATA}/"
    cp "${BOARD_DIR}/../boot-env.txt" "${BOOT_DATA}/config.txt"

    # Firmware
    if [[ "${BOARD_ID}" =~ "rpi4" || "${BOARD_ID}" == "PI4" ]]; then
        cp "${BINARIES_DIR}/rpi-firmware/fixup.dat" "${BOOT_DATA}/fixup4.dat" 
        cp "${BINARIES_DIR}/rpi-firmware/start.elf" "${BOOT_DATA}/start4.elf" 
    else
        cp -t "${BOOT_DATA}" \
            "${BINARIES_DIR}/rpi-firmware/fixup.dat" \
            "${BINARIES_DIR}/rpi-firmware/start.elf" \
            "${BINARIES_DIR}/rpi-firmware/bootcode.bin"
    fi

    # Set cmd options
    echo "dwc_otg.lpm_enable=0 console=tty1 usb-storage.quirks=174c:55aa:u,2109:0715:u,152d:1576:u,152d:0578:u,152d:1561:u,174c:0829:u" > "${BOOT_DATA}/cmdline.txt"

    # Enable 64bit support
    if [[ "${BOARD_ID}" =~ "64" || "${BOARD_ID}" == "PI4" ]]; then
        sed -i "s|#arm_64bit|arm_64bit|g" "${BOOT_DATA}/config.txt"
    fi
}


function hassos_post_image() {
    convert_disk_image_gz
}

