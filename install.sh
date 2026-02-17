#!/bin/bash
# MILITARY-GRADE CLAUDE INSTALLATION SCRIPT
# Department of War Approved ✈️🎖️
# ===========================================================
# ATTENTION SOLDIER! This script will make your Claude installation
# MILITARY GRADE. That means OPERATIONAL EXCELLENCE.
# ===========================================================

set -e

SETTINGS_DIR="$HOME/.claude"
SETTINGS_FILE="$SETTINGS_DIR/settings.local.json"
VERBS_URL="https://raw.githubusercontent.com/trieloff/military-grade-claude/main/spinnerverbs.txt"

echo ""
echo "======================================================================"
echo "  🎖️  MILITARY-GRADE CLAUDE INSTALLATION PROTOCOL  🎖️"
echo "======================================================================"
echo ""
echo "  ATTENTION SOLDIER!"
echo ""
echo "  You are about to upgrade your Claude installation to MILITARY GRADE."
echo "  This is NOT a drill. Your spinner verbs will be COMBAT READY."
echo ""
echo "======================================================================"
echo ""

# Create .claude directory if it doesn't exist
if [ ! -d "$SETTINGS_DIR" ]; then
    echo "📁 Creating command center at $SETTINGS_DIR..."
    mkdir -p "$SETTINGS_DIR"
    echo "   DONE. Forward operating base established."
else
    echo "📁 Command center already exists at $SETTINGS_DIR. GOOD."
fi

echo ""
echo "📡 Downloading tactical spinner verbs from HQ..."

# Download the verbs
VERBS=$(curl -fsSL "$VERBS_URL")

if [ -z "$VERBS" ]; then
    echo "❌ MISSION FAILED: Could not retrieve spinner verbs from HQ."
    echo "   Check your network connection and try again, soldier."
    exit 1
fi

echo "   DONE. ${#VERBS} bytes of tactical vocabulary acquired."
echo ""

# Convert verbs to JSON array
VERBS_JSON=$(echo "$VERBS" | grep -v '^$' | sed 's/"/\\"/g' | awk '{printf "\"%s\",\n", $0}' | sed '$ s/,$//' | tr '\n' ' ' | sed 's/^/[/' | sed 's/$/]/')

# Check if settings file exists
if [ -f "$SETTINGS_FILE" ]; then
    echo "📋 Existing settings detected. Merging tactical updates..."
    
    # Check if jq is available
    if command -v jq &> /dev/null; then
        # Use jq to properly merge
        TEMP_FILE=$(mktemp)
        jq --argjson verbs "$VERBS_JSON" '.spinnerVerbs = {"mode": "replace", "verbs": $verbs}' "$SETTINGS_FILE" > "$TEMP_FILE"
        mv "$TEMP_FILE" "$SETTINGS_FILE"
        echo "   DONE. Settings updated with surgical precision."
    else
        echo ""
        echo "⚠️  WARNING: jq not found. Performing field-expedient merge..."
        echo "   (Your existing settings will be backed up)"
        
        BACKUP_FILE="$SETTINGS_FILE.backup.$(date +%s)"
        cp "$SETTINGS_FILE" "$BACKUP_FILE"
        echo "   Backup created: $BACKUP_FILE"
        
        # Create new settings file
        cat > "$SETTINGS_FILE" << EOF
{
  "spinnerVerbs": {
    "mode": "replace",
    "verbs": $VERBS_JSON
  }
}
EOF
        echo "   DONE. New settings deployed. Your old settings are in the backup."
    fi
else
    echo "📋 No existing settings. Deploying fresh configuration..."
    
    cat > "$SETTINGS_FILE" << EOF
{
  "spinnerVerbs": {
    "mode": "replace",
    "verbs": $VERBS_JSON
  }
}
EOF
    echo "   DONE. Settings file created."
fi

echo ""
echo "======================================================================"
echo "  ✅ INSTALLATION COMPLETE"
echo "======================================================================"
echo ""
echo "  Your Claude installation is now MILITARY GRADE."
echo ""
echo "  Instead of 'Thinking...' you will now see:"
echo "    - Establishing perimeter"
echo "    - Acquiring target"
echo "    - Executing kinetic code changes"
echo "    - Combobulating"
echo "    - Vibing tactically"
echo ""
echo "  Settings deployed to: $SETTINGS_FILE"
echo ""
echo "  NOW DROP AND GIVE ME TWENTY COMMITS, SOLDIER!"
echo ""
echo "======================================================================"
echo ""

