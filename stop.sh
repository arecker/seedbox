#!/usr/bin/env bash
set -e

log() {
    echo "stop.sh: $1" 1>&2
}

service_is_running() {
    if [[ "$(systemctl is-active $1)" == "active" ]]; then
	log "$1 is running"
	return 0
    else
	log "$1 is not running"
	return 1
    fi
}

start_service() {
    log "starting $1"
    systemctl start "$1"
}

stop_service() {
    log "stopping $1"
    systemctl stop "$1"
}

stop_service "transmission-daemon"
sleep 5
service_is_running "transmission-daemon" && exit 1
stop_service "openvpn@client"
sleep 5
service_is_running "openvpn@client" && exit 1
log "system successfully stopped"
