#!/bin/bash

# List of apps and ports for optional warmup
declare -A apps=(
  ["inquiries"]=21000
  ["tickets"]=21001
  ["technical"]=21002
)

# Step 1: Install dependencies
echo "📦 Installing dependencies..."
for app in "${!apps[@]}"; do
  (
    cd ./$app && npm install
  ) &
done
wait

# Step 2: Start dev servers
echo "🚀 Starting development servers..."
for app in "${!apps[@]}"; do
  (
    cd ./$app && npm run dev
  ) &
done

# Step 3: Optional warmup (can be removed if unnecessary)
echo "🔥 Warming up apps..."
for port in "${apps[@]}"; do
  (
    curl -sSL "http://localhost:$port" > /dev/null 2>&1 || wget -q -O /dev/null "http://localhost:$port"
  ) &
done

wait
echo "✅ All apps are started (no port check, no process killing)."
