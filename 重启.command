#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
bash "停止.command"
bash "启动.command"
