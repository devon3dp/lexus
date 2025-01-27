import sqlite3

def initialize_database():
    conn = sqlite3.connect("app/crypto_scanner.db")
    cursor = conn.cursor()
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS wallets (
        id INTEGER PRIMARY KEY,
        address TEXT NOT NULL,
        balance REAL DEFAULT 0,
        blockchain TEXT NOT NULL,
        last_checked TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    """)
    conn.commit()
    conn.close()
