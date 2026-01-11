#!/bin/bash

set -e  # 出错就退出

# 系统盘
WIN_VMDK="win10.vmdk"

# Chrome ISO（当前目录）
CHROME_ISO="./Chrome.iso"
CHROME_URL="https://archive.org/download/chrome_20240526/Chrome.iso"

# 检查 Chrome.iso 是否存在，如果不存在就下载
if [ ! -f "$CHROME_ISO" ]; then
    echo "Chrome.iso not found, downloading..."
    wget -c -O "$CHROME_ISO" "$CHROME_URL"
else
    echo "Found Chrome.iso in current directory."
fi

# 启动 QEMU（virtio 全家桶）
qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -smp 6 \
  -m 12G \
  -M q35 \
  -drive file="$WIN_VMDK",if=virtio,cache=none,aio=io_uring,format=vmdk \
  -drive file="$CHROME_ISO",if=ide,media=cdrom,readonly=on \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0 \
  -vga virtio \
  -usb -device usb-tablet \
  -vnc :2
