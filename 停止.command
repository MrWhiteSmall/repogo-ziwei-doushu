#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
RUN="$PWD/.run"
if [ ! -s "$RUN/server.pid" ] || [ ! -s "$RUN/started" ]; then printf '本项目当前没有已记录的服务。\n'; exit 0; fi
PID=$(cat "$RUN/server.pid")
case "$PID" in ''|*[!0-9]*) printf '服务记录无效，未操作其他进程。\n'; exit 1;; esac
CURRENT=$(ps -p "$PID" -o lstart= 2>/dev/null || true)
if [ "$PID" -gt 1 ] && [ -n "$CURRENT" ] && [ "$CURRENT" = "$(cat "$RUN/started")" ]; then
  kill -TERM "$PID"
  for _ in {1..40}; do
    if ! kill -0 "$PID" 2>/dev/null; then break; fi
    sleep 0.25
  done
  if kill -0 "$PID" 2>/dev/null; then printf '服务仍在退出，请稍后再检查。\n'; exit 1; fi
  printf '本地排盘服务已停止。\n'
else
  printf '原服务已经退出。\n'
fi
rm -f "$RUN/server.pid" "$RUN/started" "$RUN/port"
