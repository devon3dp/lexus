CREATE TABLE IF NOT EXISTS wallets (
    id INTEGER PRIMARY KEY,
    address TEXT NOT NULL,
    balance REAL DEFAULT 0,
    blockchain TEXT NOT NULL,
    last_checked TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS scans (
    id INTEGER PRIMARY KEY,
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP,
    status TEXT DEFAULT 'In Progress'
);

CREATE TABLE IF NOT EXISTS recovery_attempts (
    id INTEGER PRIMARY KEY,
    mnemonic TEXT,
    generated_address TEXT,
    success INTEGER DEFAULT 0,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
