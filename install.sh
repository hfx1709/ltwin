#!/bin/bash

set -e

# 下载目录和文件
WIN_ISO="/tmp/win.iso"
VIO_ISO="/tmp/vio.iso"

# 下载 Tiny10 ISO（如果不存在）
if [ ! -f "$WIN_ISO" ]; then
    echo "Downloading Tiny10 ISO..."
    wget -c -O "$WIN_ISO" "https://archive.org/download/tiny-10-b-2/Tiny10%20B4%20x64.iso"
else
    echo "Found Tiny10 ISO at $WIN_ISO"
fi

# 下载 VirtIO ISO（如果不存在）
if [ ! -f "$VIO_ISO" ]; then
    echo "Downloading VirtIO ISO..."
    wget -c -O "$VIO_ISO" "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"
else
    echo "Found VirtIO ISO at $VIO_ISO"
fi

# 系统盘文件
WIN_VMDK="win10.vmdk"

# 如果系统盘不存在，创建 15G VMDK
if [ ! -f "$WIN_VMDK" ]; then
    echo "Creating system disk $WIN_VMDK (15G)..."
    qemu-img create -f vmdk "$WIN_VMDK" 15G
fi

# 启动 QEMU（virtio 全家桶）
qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -smp 6 \
  -m 12G \
  -M q35 \
  -drive file="$WIN_VMDK",if=virtio,cache=none,aio=io_uring,format=vmdk \
  -cdrom "$WIN_ISO" \
  -drive file="$VIO_ISO",if=ide,media=cdrom,readonly=on \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0 \
  -vga virtio \
  -usb -device usb-tablet \
  -vnc :2
