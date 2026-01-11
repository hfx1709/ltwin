#!/bin/bash

# 系统盘
WIN_VMDK="win10.vmdk"

# 启动 QEMU（virtio 全家桶）
qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -smp 6 \
  -m 12G \
  -M q35 \
  -drive file="$WIN_VMDK",if=virtio,cache=none,aio=io_uring,format=vmdk \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0 \
  -vga virtio \
  -usb -device usb-tablet \
  -vnc :2
