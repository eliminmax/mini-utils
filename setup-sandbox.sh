#!/bin/sh

# Copyright © 2023 Eli Array Minkoff
# SPDX-FileCopyrightText: 2023 Eli Array Minkoff
#
# SPDX-License-Identifier: 0BSD

PS4='[38;5;195msetup-sandbox.sh »[m'
set -x

# Usage: setup-sandbox.sh SANDBOX_DIR EXEC_NAME ARGS
# When used, setup-sandbox.sh does the following:
# * Creates an isolated X11 environment using Xephyr, and launches the awesome window manager within it.
# * Runs SANDBOX_DIR/EXEC_NAME ARGS in a simple bubblewrap container, which remounts SANDBOX_DIR over your HOME.
# Useful if you don't want EXEC_NAME from accessing your actual home. It makes no effort to cut off access to anything outside of your HOME, so it's not the most robust or bulletproof, just useful in a pinch.

sandbox_dir="$1"
shift

# ensure that Xephyr and Awesome start from the user's home directory
cd "$HOME" || exit 200

# Get an appropriate number for the Xephyr DISPLAY value

while [ -f /tmp/.get-sandbox-num ]; do
    echo Waiting for lock held by process "$(cat /tmp/.get-sandbox-num)"
    sleep 5
done

# avoid race conditions
printf '%s' "$$" > /tmp/.get-sandbox-num
chmod 644 /tmp/.get-sandbox-num

client_display=0
while [ -S "/tmp/.X11-unix/X$client_display" ]; do
    client_display="$((client_display+1))"
done

rm /tmp/.get-sandbox-num

Xephyr -fullscreen ":$client_display" &
xephyr_pid="$?"

# hang until Xephyr is running - this avoids a race condition with awesome
until xdpyinfo -display ":$client_display" >/dev/null 2>&1; do true ; done

DISPLAY=":$client_display" awesome &
awesome_pid="$?"

timestamp="$(date +%s)"
bus_dir="/run/user/$(id -u)/bus"

cd "$sandbox_dir" || exit 200
# shellcheck disable=SC2086
bwrap  \
    --new-session \
    --bind /proc /proc \
    --ro-bind /usr /usr \
    --ro-bind /var /var \
    --ro-bind /etc /etc \
    --dev-bind /dev /dev \
    --symlink /usr/bin /bin \
    --symlink /usr/sbin /sbin \
    --symlink /usr/lib /lib \
    --symlink /usr/libx32 /libx32 \
    --symlink /usr/lib32 /lib32 \
    --symlink /usr/lib64 /lib64 \
    --setenv DISPLAY ":$client_display" \
    --bind "$sandbox_dir" "$HOME" \
    --tmpfs /tmp \
    --dir /tmp/.X11-unix \
    --bind "/tmp/.X11-unix/X$client_display" "/tmp/.X11-unix/X$client_display" \
    --tmpfs /run \
    --ro-bind "$bus_dir" "$bus_dir" \
    $SANDBOX_FLAGS -- "$@"

kill "$awesome_pid"
kill "$xephyr_pid"
