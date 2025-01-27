#!/bin/bash

# Lexus Comprehensive Setup Script
echo "Starting Lexus setup..."

# Step 1: Update System and Install Prerequisites
echo "Updating system packages and installing required dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git build-essential python3-tk sqlite3 libsqlite3-dev python3-venv || {
    echo "Error: Failed to install system dependencies."
    exit 1
}

# Step 2: Install Python 3.11 and tkinter
echo "Installing Python 3.11 and tkinter..."
sudo apt install -y python3.11 python3.11-tk || {
    echo "Error: Failed to install Python 3.11 and tkinter."
    exit 1
}

# Step 3: Remove Existing Virtual Environment (if any)
if [ -d "venv" ]; then
    echo "Removing existing virtual environment..."
    rm -rf venv
fi

# Step 4: Create a New Python Virtual Environment
echo "Creating a new Python virtual environment..."
python3.11 -m venv venv || {
    echo "Error: Failed to create virtual environment."
    exit 1
}

# Step 5: Activate the Virtual Environment
echo "Activating the virtual environment..."
source venv/bin/activate || {
    echo "Error: Failed to activate virtual environment."
    exit 1
}

# Step 6: Upgrade pip, setuptools, and wheel
echo "Upgrading pip, setuptools, and wheel..."
pip install --upgrade pip setuptools wheel || {
    echo "Error: Failed to upgrade pip, setuptools, or wheel."
    exit 1
}

# Step 7: Install Python Dependencies
echo "Installing Python dependencies..."
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt || {
        echo "Error: Failed to install Python dependencies from requirements.txt."
        exit 1
    }
else
    echo "requirements.txt not found. Installing dependencies manually..."
    pip install web3 solana mnemonic requests python-dotenv openai pycryptodome cryptography pandas numpy flask || {
        echo "Error: Failed to install required Python libraries."
        exit 1
    }
fi

# Step 8: Install Node.js and NPM
if ! command -v node &> /dev/null; then
    echo "Installing Node.js and NPM..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - || {
        echo "Error: Failed to add Node.js source."
        exit 1
    }
    sudo apt install -y nodejs || {
        echo "Error: Failed to install Node.js and NPM."
        exit 1
    }
else
    echo "Node.js is already installed."
fi

# Verify Node.js and NPM installation
echo "Verifying Node.js and NPM..."
node -v || {
    echo "Error: Node.js is not installed correctly."
    exit 1
}
npm -v || {
    echo "Error: NPM is not installed correctly."
    exit 1
}

# Step 9: Install NPM Dependencies (if package.json exists)
if [ -f "package.json" ]; then
    echo "Installing NPM dependencies..."
    npm install || {
        echo "Error: Failed to install NPM dependencies."
        exit 1
    }
else
    echo "package.json not found. Skipping NPM setup."
fi

# Step 10: Initialize SQLite Database
echo "Checking SQLite database..."
if [ ! -f "app/crypto_scanner.db" ]; then
    if [ -f "app/database_setup.sql" ]; then
        echo "Initializing SQLite database..."
        sqlite3 app/crypto_scanner.db < app/database_setup.sql || {
            echo "Error: Failed to initialize the database."
            exit 1
        }
        echo "Database initialized successfully."
    else
        echo "Error: database_setup.sql not found. Skipping database setup."
    fi
else
    echo "Database already exists. Skipping initialization."
fi

# Step 11: Create .env File if Missing
echo "Checking for .env file..."
if [ ! -f ".env" ]; then
    echo "Creating .env file..."
    cat <<EOT > .env
# Add your environment variables here
OPENAI_API_KEY=your_openai_api_key
ETHERSCAN_API_KEY=
INFURA_PROJECT_ID=
ETH_RPC_URL=https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID
SOLANA_RPC_URL=https://api.mainnet-beta.solana.com
BITCOIN_RPC_URL=https://blockchain.info
EOT
    echo ".env file created. Please update it with your API keys."
else
    echo ".env file already exists. Skipping creation."
fi

# Step 12: Launch Lexus Backend and GUI
echo "Launching Lexus backend (Python)..."
nohup python3 app/main.py > backend.log 2>&1 &
echo "Launching Lexus GUI (GeekGUI)..."
nohup python3 app/frontend.py > gui.log 2>&1 &

# Step 13: Launch Lexus JavaScript Logic (if available)
if [ -f "index.js" ]; then
    echo "Launching Lexus JavaScript logic..."
    nohup node index.js > javascript.log 2>&1 &
else
    echo "No index.js file found. Skipping JavaScript logic."
fi

# Final Message
echo "Setup complete! Lexus is now running."
echo "Python backend logs: backend.log"
echo "GUI logs: gui.log"
echo "JavaScript logic logs (if applicable): javascript.log"
