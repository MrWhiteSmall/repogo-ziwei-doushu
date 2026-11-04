#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
ROOT="$PWD"
RUN="$ROOT/.run"
mkdir -p "$RUN"
PORT="${REPOGO_PORT:-4819}"
case "$PORT" in ''|*[!0-9]*) printf '端口必须是数字。\n'; exit 1;; esac
if [ "$PORT" -lt 1024 ] || [ "$PORT" -gt 65535 ]; then printf '端口须在 1024 到 65535 之间。\n'; exit 1; fi
if [ "$(uname -s)" != Darwin ] || [ "$(uname -m)" != arm64 ]; then
  printf '这份运行包适用于苹果芯片 Mac。Windows、Linux、Intel Mac 尚未验收。\n'; exit 1
fi
if [ -s "$RUN/server.pid" ] && [ -s "$RUN/started" ]; then
  PID=$(cat "$RUN/server.pid")
  case "$PID" in ''|*[!0-9]*) PID=0;; esac
  CURRENT=$(ps -p "$PID" -o lstart= 2>/dev/null || true)
  if [ "$PID" -gt 1 ] && [ "$CURRENT" = "$(cat "$RUN/started")" ] && kill -0 "$PID" 2>/dev/null; then
    printf '本项目已在运行：http://127.0.0.1:%s/\n' "$(cat "$RUN/port")"; exit 0
  fi
fi
if lsof -nP -iTCP:"$PORT" -sTCP:LISTEN >/dev/null 2>&1; then
  printf '端口 %s 已被占用。请先停止原服务，或使用 REPOGO_PORT=4829 bash 启动.command。\n' "$PORT"; exit 1
fi
ARCHIVE="$ROOT/resources/node-v22.21.1-darwin-arm64-minimal.tar.gz"
EXPECTED=e4173c79b3053e13def36f354c08983e4442d65672bdc08ec9df25d591d744d0
ACTUAL=$(shasum -a 256 "$ARCHIVE" | awk '{print $1}')
if [ "$ACTUAL" != "$EXPECTED" ]; then printf '自备运行环境校验失败，请重新取得完整运行包。\n'; exit 1; fi
NODE="$ROOT/.runtime/node-v22.21.1-darwin-arm64/bin/node"
if [ ! -x "$NODE" ]; then
  printf '正在准备随包提供的运行环境……\n'
  mkdir -p "$ROOT/.runtime"
  tar -xzf "$ARCHIVE" -C "$ROOT/.runtime"
fi
printf '正在启动中文排盘页面……\n'
nohup env HOSTNAME=127.0.0.1 PORT="$PORT" NEXT_TELEMETRY_DISABLED=1 "$NODE" "$ROOT/app/server.js" > "$RUN/server.log" 2>&1 < /dev/null &
PID=$!
printf '%s\n' "$PID" > "$RUN/server.pid"
ps -p "$PID" -o lstart= > "$RUN/started"
printf '%s\n' "$PORT" > "$RUN/port"
for _ in {1..40}; do
  if curl -fsS --max-time 1 "http://127.0.0.1:$PORT/" > /dev/null 2>&1; then
    printf '已启动：http://127.0.0.1:%s/\n停止时双击“停止.command”。\n' "$PORT"
    if [ "${REPOGO_NO_OPEN:-0}" != 1 ]; then open "http://127.0.0.1:$PORT/"; fi
    exit 0
  fi
  if ! kill -0 "$PID" 2>/dev/null; then printf '启动失败，请查看 .run/server.log。\n'; exit 1; fi
  sleep 0.25
done
printf '服务尚未就绪，请查看 .run/server.log。\n'; exit 1
