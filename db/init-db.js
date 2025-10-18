// اجرا برای ایجاد فایل دیتابیس و جداول اولیه
const Database = require('better-sqlite3');
const fs = require('fs');
const path = require('path');

const dbPath = path.join(__dirname, 'hozor.db');

if (fs.existsSync(dbPath)) {
  console.log('Database already exists at', dbPath);
  process.exit(0);
}

const db = new Database(dbPath);

// users: کارکنان
db.exec(`
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  employee_code TEXT UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE attendance (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  type TEXT NOT NULL, -- IN or OUT
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  note TEXT,
  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE settings (
  key TEXT PRIMARY KEY,
  value TEXT
);
`);

// seed example users
const insert = db.prepare('INSERT INTO users (name, employee_code) VALUES (?, ?)');
insert.run('Moein Miraki', 'EMP001');
insert.run('Sadaf', 'EMP002');

console.log('Database initialized at', dbPath);
db.close();
