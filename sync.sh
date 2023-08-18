#!/usr/bin/env bash

echo "running new hook script"
/home/alex/transmission.py

echo "running old stuff"
rsync \
    --quiet \
    --recursive \
    --exclude "*.txt" \
    --exclude "*.part" \
    --exclude "*.jpg" \
    --exclude "*.nfo" \
    /var/lib/transmission-daemon/downloads/ alex@10.0.0.5:/volume1/downloads/
