#!/bin/bash
# Quick: clear logs, then show only ERROR lines from PM2 after a fresh restart
# Run on VPS: bash scripts/vps_tail_error.sh
# After running this, trigger the 500 from admin dashboard, then Ctrl+C to stop tail

pm2 flush bibek-backend
echo "Logs cleared. Now trigger the failing action in admin dashboard..."
echo "Watching for errors (Ctrl+C to stop):"
echo "---"
pm2 logs bibek-backend --raw 2>&1 | grep --line-buffered -E "ERROR|Traceback|Exception|500|error|Error|IntegrityError|column|relation|does not exist" | head -50
