const express = require('express');
const Router = express.Router();
const Database = require('better-sqlite3');
const path = require('path');
const db = new Database(path.join(__dirname, '..', 'db', 'hozor.db'));

// ثبت کاربر جدید (در صورت نیاز)
Router.post('/users', (req, res) => {
  const { name, employee_code } = req.body;
  if (!name || !employee_code) return res.status(400).json({ error: 'name and employee_code required' });
  try {
    const stmt = db.prepare('INSERT INTO users (name, employee_code) VALUES (?, ?)');
    const info = stmt.run(name, employee_code);
    res.json({ id: info.lastInsertRowid, name, employee_code });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// لیست کاربران
Router.get('/users', (req, res) => {
  const rows = db.prepare('SELECT id, name, employee_code, created_at FROM users').all();
  res.json(rows);
});

// ثبت ورود/خروج
Router.post('/attendance', (req, res) => {
  const { employee_code, type, note } = req.body;
  if (!employee_code || !type) return res.status(400).json({ error: 'employee_code and type required' });
  const user = db.prepare('SELECT * FROM users WHERE employee_code = ?').get(employee_code);
  if (!user) return res.status(404).json({ error: 'user not found' });
  const stmt = db.prepare('INSERT INTO attendance (user_id, type, note) VALUES (?, ?, ?)');
  const info = stmt.run(user.id, type.toUpperCase(), note || null);
  res.json({ ok: true, id: info.lastInsertRowid, user: user.name, type: type.toUpperCase(), timestamp: new Date().toISOString() });
});

// گزارش ساده بین دو تاریخ
Router.get('/report', (req, res) => {
  const { from, to, employee_code } = req.query;
  let q = `SELECT a.id, u.name, u.employee_code, a.type, a.timestamp, a.note
           FROM attendance a JOIN users u ON a.user_id = u.id WHERE 1=1`;
  const params = [];
  if (employee_code) { q += ' AND u.employee_code = ?'; params.push(employee_code); }
  if (from) { q += ' AND datetime(a.timestamp) >= datetime(?)'; params.push(from); }
  if (to)   { q += ' AND datetime(a.timestamp) <= datetime(?)'; params.push(to); }
  q += ' ORDER BY a.timestamp ASC';
  const rows = db.prepare(q).all(...params);
  res.json(rows);
});

module.exports = Router;
