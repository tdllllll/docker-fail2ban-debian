#!/bin/bash

echo "Initializing files and folders..."
mkdir -p /data/run /data/lib /data/db /data/action.d /data/filter.d /data/jail.d

docker compose up -d
