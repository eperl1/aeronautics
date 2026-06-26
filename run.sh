#!/bin/bash

# Define the backup function
backup_server() {
    # Prevent this trap from running multiple times
    trap - EXIT SIGINT SIGTERM
    
    echo "⚠️ Server stopped or Codespace shutting down! Initiating emergency cloud backup loop..."
    
    # Disable VS Code's broken credential helpers for this script
    unset GIT_ASKPASS
    unset SSH_ASKPASS
    
    # Ensure Git uses 'gh' (GitHub CLI) for credentials
    git config --local credential.helper '!gh auth git-credential'
    
    # Reset the origin to standard HTTPS
    git remote set-url origin https://github.com/eperl1/aeronautics.git
    
    # Commit and push all changes
    git add .
    git commit -m "Auto-Saved Server Data: $(date '+%Y-%m-%d %H:%M:%S')"
    git push origin main
    
    echo "✅ Backup complete! It is now safe to close your Codespace tab."
}

# Trap termination signals to trigger the backup function
# EXIT = Normal stop/crash
# SIGINT = You pressing Ctrl+C
# SIGTERM = GitHub Codespace timeout/shutdown signal
trap backup_server EXIT SIGINT SIGTERM

echo "🚀 Firing up the NeoForge Server..."

# Run Java in the background (&) so Bash can instantly intercept shutdown signals
java -Xmx10G -Xms4G @user_jvm_args.txt @libraries/net/neoforged/neoforge/21.1.230/unix_args.txt "$@" &
JAVA_PID=$!

# Wait for the Java process. If the Codespace shuts down, this wait is interrupted and the trap runs.
wait $JAVA_PID