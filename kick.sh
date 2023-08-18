#!/usr/bin/env bash

log() {
    echo "kick.sh: $1" 1>&2
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

fetch_public_ip() {
    curl -s https://www.ipinfo.io/ip
}

stop_service "transmission-daemon"
sleep 5
service_is_running "transmission-daemon" && exit 1
stop_service "openvpn@client"
sleep 5
service_is_running "openvpn@client" && exit 1
IP_BEFORE="$(fetch_public_ip)"
log "fetched public IP $IP_BEFORE"
start_service "openvpn@client"
sleep 5
service_is_running "openvpn@client" || exit 1
IP_AFTER="$(fetch_public_ip)"
log "fetched public IP $IP_AFTER"

if [ "$IP_BEFORE" == "$IP_AFTER" ]; then
    log "expected $IP_BEFORE != $IP_AFTER"
    exit 1
else
    log "vpn changed public IP $IP_BEFORE -> $IP_AFTER"
fi

start_service "transmission-daemon"
sleep 5
service_is_running "transmission-daemon" || exit 1

log "system successfully kicked off!"
