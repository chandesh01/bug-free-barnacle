#!/usr/bin/env bash
# optimize_android.sh — Trim cache and reoptimize apps on Android via ADB
# Requires adb installed and device connected

set -e

echo "📱 Starting Android optimization..."

# 1️⃣ Trim app caches
echo "🧹 Trimming caches..."
adb shell pm trim-caches 999G

# 2️⃣ Compile apps with speed-profile
echo "⚡ Compiling apps (speed-profile)..."
adb shell "cmd package compile -m speed-profile -f -a"

# 3️⃣ Run background dexopt job
echo "🔧 Running background dexopt job..."
adb shell pm bg-dexopt-job

echo "✅ Optimization complete!"
