#!/usr/bin/env bash
# Starts the app and runs two sequential molerat-mcp clients

set -u
cd "$(dirname "$0")"
cargo build --quiet || exit 1

APP=target/debug/molerat-repro
"$APP" > app.log 2>&1 &
APP_PID=$!
trap 'kill $APP_PID 2>/dev/null' EXIT
sleep 2

mcp_call() {
    {
        printf '%s\n' \
            '{"jsonrpc":"2.0", "id":1, "method":"initialize", "params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"repro","version":"0"}}}' \
            '{"jsonrpc":"2.0", "method":"notifications/initialized"}' \
            '{"jsonrpc":"2.0", "id":2, "method":"tools/call", "params":{"name":"get_ui", "arguments":{}}}'
        sleep 1
    } | molerat-mcp 2>&1
}

echo "== client 1 =="
mcp_call
echo

echo "=== client 2 ==="
mcp_call
echo

echo "=== app.log ==="
cat app.log
