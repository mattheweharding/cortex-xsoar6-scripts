#!/bin/bash

# =================================================================
# XSOAR Reset Script - v8 (Nested Data + Aggressive Docker Reset)
# TARGET: /var/lib/demisto/data
# ACTION: Wipe DB + Logs + Force Kill Docker Containers
# =================================================================

# 1. TARGET THE NESTED FOLDER
DATA_DIR="/var/lib/demisto/data"
LOG_DIR="/var/log/demisto"
BACKUP_ROOT="/var/lib/demisto"
NEW_BACKUP_NAME="data_backup_$(date +%Y%m%d_%H%M%S)"
FULL_BACKUP_PATH="$BACKUP_ROOT/$NEW_BACKUP_NAME"

# 2. Check for Root
if [ "$(id -u)" -ne 0 ]; then
  echo "❌ Error: Please run as root (sudo)."
  exit 1
fi

# 3. Verify the target actually exists
if [ ! -d "$DATA_DIR" ]; then
    echo "❌ Error: Directory $DATA_DIR does not exist."
    echo "   Please check if the 'data' folder is actually named something else."
    exit 1
fi

echo "⚠️  CRITICAL WARNING ⚠️"
echo "Targeting Nested DB: $DATA_DIR"
echo "This will restart XSOAR, FORCE KILL all Docker containers, and wipe incidents."
echo ""
read -p "Proceed? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then exit 1; fi

# 4. Stop Services
echo "1️⃣  Stopping Demisto service..."
service demisto stop

# Force kill Demisto if needed
PID=$(pgrep -u demisto server)
if [ -n "$PID" ]; then
    echo "   - Force killing Demisto PID $PID..."
    kill -9 "$PID"
fi

echo "2️⃣  Stopping Docker containers..."
# Aggressively kill running containers before stopping the service
if [ -n "$(docker ps -q)" ]; then
    echo "   - Killing running containers..."
    docker kill $(docker ps -q)
fi

# We restart the docker daemon to flush all running containers
service docker stop

# 5. Move Data to Backup
echo "3️⃣  Moving data to: $FULL_BACKUP_PATH"
mkdir -p "$FULL_BACKUP_PATH"
mkdir -p "$FULL_BACKUP_PATH/logs"

# Move Index
if [ -d "$DATA_DIR/demistoidx" ]; then
    mv "$DATA_DIR/demistoidx" "$FULL_BACKUP_PATH/"
    echo "   - demistoidx moved."
fi

# Move Partitions (The Incidents)
if find "$DATA_DIR" -maxdepth 1 -name "partitions*" | read; then
    find "$DATA_DIR" -maxdepth 1 -name "partitions*" -exec mv {} "$FULL_BACKUP_PATH/" \;
    echo "   - partitions moved."
fi

# 6. Wipe Logs
if [ -d "$LOG_DIR" ]; then
    mv "$LOG_DIR"/* "$FULL_BACKUP_PATH/logs/" 2>/dev/null
    echo "   - logs moved."
fi

# 7. Start Services
echo "4️⃣  Starting Docker service..."
service docker start

echo "5️⃣  Starting Demisto service..."
service demisto start

# 8. Cleanup old backups (3 days)
find "$BACKUP_ROOT" -maxdepth 1 -type d -name "data_backup_*" -mtime +2 -exec rm -rf {} +

echo "✅ Done. Docker flushed and DB reset. Please clear your browser cache."