#!/usr/bin/env bash

log() {
    echo "assume.sh: $1" 1>&2
}

assume() {
    local user="$1"
    log "assuming into $user"
    sudo runuser -l "$user" -c 'bash'
}

assume "debian-transmission"
