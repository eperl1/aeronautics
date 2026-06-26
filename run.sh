#!/bin/bash
echo "🚀 Firing up the NeoForge Server..."
java -Xmx12G -Xms4G @user_jvm_args.txt @libraries/net/neoforged/neoforge/21.1.230/unix_args.txt "$@"

echo "⚠️ Server stopped! Initiating emergency cloud backup loop..."
git add .
git commit -m "Auto-Saved Server Data: $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main
echo "✅ Backup complete! It is now safe to close your Codespace tab."
