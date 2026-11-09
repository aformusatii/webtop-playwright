#!/usr/bin/env bash
set -euo pipefail

# LinuxServer runs this hook before starting Xvfb, D-Bus, and Selkies.
# Run only during container initialization, never against a running desktop.
# After a power loss, old PIDs can belong to unrelated processes, so checking
# whether the recorded PID exists cannot establish that these files are valid.
display="${DISPLAY:-:1}"
if [[ ! "$display" =~ ^:([0-9]+)(\.[0-9]+)?$ ]]; then
  printf '[desktop-runtime] Unsupported local DISPLAY: %s\n' "$display" >&2
  exit 1
fi
display_number="${BASH_REMATCH[1]}"

rm -f -- \
  "/tmp/.X${display_number}-lock" \
  "/tmp/.X11-unix/X${display_number}" \
  /run/dbus/pid \
  /run/dbus/system_bus_socket

printf '[desktop-runtime] Cleared previous X11 (%s) and D-Bus runtime files\n' "$display"
