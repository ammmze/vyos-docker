#!/usr/bin/env bash

ISO=$1
NAME=$2
shift 2

# Mount ISO
mkdir rootfs
sudo mount -o loop "$ISO" rootfs

# Unpack Filesystem
mkdir unsquashfs
sudo unsquashfs -f -d unsquashfs rootfs/live/filesystem.squashfs

# Create Docker Image
IMAGE=$(sudo tar -C unsquashfs -c . | docker import - "${NAME}")
for TAG in "$@"; do
    docker tag "$IMAGE" "${NAME}:${TAG}"
done

