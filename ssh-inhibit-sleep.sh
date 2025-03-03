#!/usr/bin/env bash

INHIBIT_COMMAND="systemd-inhibit --what=sleep --why=ssh_connection sleep infinity"

log() {
    echo "$1"
}

cleanup() {
    log "[cleanup] Cleaning up..."

    # Find and stop any transient systemd-inhibit units started by this script.
    for unit in $(systemctl list-units --no-legend "ssh-inhibit-*.service" | awk '{print $1}'); do
        systemctl stop "$unit"
        log "[cleanup] Stopped unit: $unit"
    done
    log "[cleanup] Cleanup complete."
}


if ss -t state established | grep -q ':ssh[[:space:]]'; then
    log "SSH connections detected."

    if ! systemctl list-units --no-legend "ssh-inhibit-*.service" | grep -q running; then
        # Start systemd-inhibit as a *transient user service*.
        systemd-run --unit=ssh-inhibit-$RANDOM.service --no-block -p "Description=SSH Inhibit" $INHIBIT_COMMAND
        log "Started systemd-inhibit unit."
    else
        log "systemd-inhibit unit already running."
    fi
else
    cleanup
    log "No active SSH connections."
fi

exit 0
