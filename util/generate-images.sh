#!/bin/bash

FEDORA_RELEASE=38
UBLUE_IMAGES=(
    silverblue-main
    silverblue-nvidia
    bazzite
    #bazzite-gnome
    bazzite-gnome-nvidia
    bazzite-gnome-deck
    bazzite-deck
    bazzite-nvidia
    bluefin
    bluefin-nvidia
    bluefin-dx
)

printf '%s\n' "${UBLUE_IMAGES[@]}" | xargs -P1 -tI{} ./util/mkociso -i "ghcr.io/ublue-os/{}:${FEDORA_RELEASE}" -r "${FEDORA_RELEASE}"
