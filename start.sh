#!/bin/bash

docker run -it --rm --name windows \
  -e "VERSION=https://tianyios.ntbsd.eu.org/luo.iso" \
  -e "DISK_SIZE=30G" \
  -e "RAM_SIZE=max" \
  -e "CPU_CORES=max" \
  -p 8006:8006 \
  --device=/dev/kvm \
  --device=/dev/net/tun \
  --cap-add NET_ADMIN \
  --stop-timeout 60 \
  -v ./windows:/storage \
  -v /tmp:/shared \
  docker.io/dockurr/windows

