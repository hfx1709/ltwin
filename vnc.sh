#!/bin/bash

set -e  # 出错就退出

# 启动 noVNC，把 VNC :5902 映射到 Web :6001
novnc --listen :6001 --vnc :5902
