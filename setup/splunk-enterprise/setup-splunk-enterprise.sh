#!/bin/bash

# Windows SOC Lab - Splunk Enterprise Receiver Setup
#
# Configures Splunk Enterprise to receive data from
# Splunk Universal Forwarders on TCP port 9997.

set -e

SPLUNK_HOME="${SPLUNK_HOME:-/opt/splunk}"
INPUTS_DIR="$SPLUNK_HOME/etc/system/local"
INPUTS_FILE="$INPUTS_DIR/inputs.conf"

echo "============================================="
echo " Windows SOC Lab - Splunk Enterprise Setup"
echo "============================================="
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

mkdir -p "$INPUTS_DIR"

cat > "$INPUTS_FILE" <<'EOF'
# Windows SOC Lab
# Receive data from Splunk Universal Forwarders

[splunktcp://9997]
disabled = 0
EOF

echo "Created receiver configuration:"
echo "$INPUTS_FILE"
echo ""

echo "Restarting Splunk Enterprise..."

"$SPLUNK_HOME/bin/splunk" restart

echo ""
echo "Checking Splunk Enterprise status..."

"$SPLUNK_HOME/bin/splunk" status

echo ""
echo "Checking TCP port 9997..."

if command -v ss >/dev/null 2>&1; then
    ss -lnt | grep ':9997' || true
elif command -v netstat >/dev/null 2>&1; then
    netstat -lnt | grep ':9997' || true
else
    echo "Neither ss nor netstat is available."
fi

echo ""
echo "============================================="
echo " Splunk Enterprise setup completed"
echo "============================================="
echo ""
echo "Splunk Enterprise is configured to receive"
echo "Universal Forwarder data on TCP port 9997."
echo ""
echo "Next:"
echo "1. Configure the Universal Forwarder with this server address."
echo "2. Restart the Universal Forwarder."
echo "3. Verify events in Splunk."
