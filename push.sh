#!/bin/bash
echo "🔄 Syncing with GitHub..."
git push origin main
if [ $? -eq 0 ]; then
  echo "✅ GitHub is up to date — Railway will auto-deploy now."
else
  echo "❌ Push failed. Check your connection or GitHub token."
fi
