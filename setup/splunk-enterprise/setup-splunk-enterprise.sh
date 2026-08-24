#!/bin/bash

# Windows SOC Lab - Splunk Enterprise Setup
#
# Configures:
#   1. Splunk Enterprise receiving on TCP 9997
#   2. Windows SOC detection searches
#
# The script is intended to make the Splunk Enterprise
# portion of the lab reproducible after cloning the repository.

set -e

SPLUNK_HOME="${SPLUNK_HOME:-/opt/splunk}"

SYSTEM_LOCAL_DIR="$SPLUNK_HOME/etc/system/local"
INPUTS_FILE="$SYSTEM_LOCAL_DIR/inputs.conf"

SOC_APP_DIR="$SPLUNK_HOME/etc/apps/windows_soc_lab"
SOC_LOCAL_DIR="$SOC_APP_DIR/local"
SAVEDSEARCHES_FILE="$SOC_LOCAL_DIR/savedsearches.conf"
APP_CONF_FILE="$SOC_APP_DIR/default/app.conf"

echo "================================================"
echo " Windows SOC Lab - Splunk Enterprise Setup"
echo "================================================"
echo ""

if [ ! -x "$SPLUNK_HOME/bin/splunk" ]; then
    echo "ERROR: Splunk Enterprise was not found at:"
    echo "$SPLUNK_HOME"
    echo ""
    echo "Set SPLUNK_HOME to your Splunk installation directory."
    exit 1
fi

echo "Splunk Enterprise found at:"
echo "$SPLUNK_HOME"
echo ""

# ------------------------------------------------
# 1. Create required directories
# ------------------------------------------------

mkdir -p "$SYSTEM_LOCAL_DIR"
mkdir -p "$SOC_LOCAL_DIR"
mkdir -p "$(dirname "$APP_CONF_FILE")"

# ------------------------------------------------
# 2. Configure Splunk Enterprise receiver
# ------------------------------------------------

cat > "$INPUTS_FILE" <<'EOF'
# Windows SOC Lab
# Receive data from Splunk Universal Forwarders

[splunktcp://9997]
disabled = 0
EOF

echo "Created receiver configuration:"
echo "$INPUTS_FILE"
echo ""

# ------------------------------------------------
# 3. Create Windows SOC Lab Splunk app
# ------------------------------------------------

cat > "$APP_CONF_FILE" <<'EOF'
[install]
is_configured = 1

[ui]
is_visible = 1
label = Windows SOC Lab

[launcher]
author = Windows SOC Lab
description = Windows SOC Lab detection searches and configuration
version = 1.0.0
EOF

echo "Created Windows SOC Lab Splunk app:"
echo "$SOC_APP_DIR"
echo ""

# ------------------------------------------------
# 4. Install all SOC detection searches
# ------------------------------------------------

cat > "$SAVEDSEARCHES_FILE" <<'EOF'
[SOC - PowerShell Activity]
search = index=* source="WinEventLog:Microsoft-Windows-PowerShell/Operational"
description = Detects PowerShell activity collected from the Windows PowerShell Operational log.
cron_schedule = */5 * * * *
dispatch.earliest_time = -5m
dispatch.latest_time = now
alert_type = number of events
alert_comparator = greater than
alert_threshold = 0
disabled = 0
enableSched = 1
alert.track = 1

[SOC - Sysmon DNS Query]
search = index=* source="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=22
description = Detects DNS query activity using Sysmon Event ID 22.
cron_schedule = */5 * * * *
dispatch.earliest_time = -5m
dispatch.latest_time = now
alert_type = number of events
alert_comparator = greater than
alert_threshold = 0
disabled = 0
enableSched = 1
alert.track = 1

[SOC - Sysmon File Creation]
search = index=* source="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=11
description = Detects file creation activity using Sysmon Event ID 11.
cron_schedule = */5 * * * *
dispatch.earliest_time = -5m
dispatch.latest_time = now
alert_type = number of events
alert_comparator = greater than
alert_threshold = 0
disabled = 0
enableSched = 1
alert.track = 1

[SOC - Sysmon Network Connection]
search = index=* source="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=3
description = Detects network connection activity using Sysmon Event ID 3.
cron_schedule = */5 * * * *
dispatch.earliest_time = -5m
dispatch.latest_time = now
alert_type = number of events
alert_comparator = greater than
alert_threshold = 0
disabled = 0
enableSched = 1
alert.track = 1

[SOC - Sysmon Process Creation]
search = index=* source="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=1
description = Detects process creation activity using Sysmon Event ID 1.
cron_schedule = */5 * * * *
dispatch.earliest_time = -5m
dispatch.latest_time = now
alert_type = number of events
alert_comparator = greater than
alert_threshold = 0
disabled = 0
enableSched = 1
alert.track = 1

[SOC - Sysmon Registry Activity]
search = index=* source="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode IN (12,13,14)
description = Detects registry activity using Sysmon Event IDs 12, 13 and 14.
cron_schedule = */5 * * * *
dispatch.earliest_time = -5m
dispatch.latest_time = now
alert_type = number of events
alert_comparator = greater than
alert_threshold = 0
disabled = 0
enableSched = 1
alert.track = 1

[SOC - Windows Failed Logon]
search = index=* EventCode=4625
description = Detects failed Windows authentication attempts using Security Event ID 4625.
cron_schedule = */5 * * * *
dispatch.earliest_time = -5m
dispatch.latest_time = now
alert_type = number of events
alert_comparator = greater than
alert_threshold = 0
disabled = 0
enableSched = 1
alert.track = 1
EOF

echo "Created SOC detection searches:"
echo "$SAVEDSEARCHES_FILE"
echo ""

# ------------------------------------------------
# 5. Set ownership
# ------------------------------------------------

if id splunk >/dev/null 2>&1; then
    chown -R splunk:splunk "$SOC_APP_DIR"
    chown splunk:splunk "$INPUTS_FILE"
fi

# ------------------------------------------------
# 6. Validate configuration
# ------------------------------------------------

echo "Validating Splunk configuration..."
"$SPLUNK_HOME/bin/splunk" btool inputs list --debug >/dev/null

if [ -f "$SAVEDSEARCHES_FILE" ]; then
    echo "Detection search configuration file exists."
else
    echo "ERROR: Detection search configuration was not created."
    exit 1
fi

echo ""

# ------------------------------------------------
# 7. Restart Splunk Enterprise
# ------------------------------------------------

echo "Restarting Splunk Enterprise..."
"$SPLUNK_HOME/bin/splunk" restart

echo ""

# ------------------------------------------------
# 8. Check Splunk status
# ------------------------------------------------

echo "Checking Splunk Enterprise status..."
"$SPLUNK_HOME/bin/splunk" status

echo ""

# ------------------------------------------------
# 9. Check TCP 9997
# ------------------------------------------------

echo "Checking TCP port 9997..."

if command -v ss >/dev/null 2>&1; then
    ss -lnt | grep ':9997' || true
elif command -v netstat >/dev/null 2>&1; then
    netstat -lnt | grep ':9997' || true
else
    echo "Neither ss nor netstat is available."
fi

echo ""

# ------------------------------------------------
# 10. Completion
# ------------------------------------------------

echo "================================================"
echo " Splunk Enterprise setup completed"
echo "================================================"
echo ""
echo "Configured:"
echo "  - TCP receiving port: 9997"
echo "  - SOC detection searches: 7"
echo "  - Detection schedule: Every 5 minutes"
echo "  - Detection time range: Last 5 minutes"
echo "  - Trigger condition: Results greater than 0"
echo ""
echo "Next:"
echo "  1. Configure the Universal Forwarder."
echo "  2. Restart the Universal Forwarder."
echo "  3. Verify forwarded events."
echo "  4. Verify the seven SOC detections."
echo ""
