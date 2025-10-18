const express = require('express');
const basicAuth = require('express-basic-auth');
const path = require('path');
const Database = require('better-sqlite3');

const Router = express.Router();
const db = new Database(path.join(__dirname, '..', 'db', 'hozor.db'));

// simple basic auth using ADMIN_PASSWORD
const adminUser = { admin: process.env.ADMIN_PASSWORD || 'admin' };
Router.use(basicAuth({
  users: adminUser,
  challenge: true,
  realm: 'Hozor Admin'
}));

// نمونه اندپوینت admin: لیست تمام حضورها
Router.get('/attendance', (req, res) => {
  const rows = db.prepare('SELECT a.id, u.name, u.employee_code, a.type, a.timestamp, a.note FROM attendance a JOIN users u ON a.user_id = u.id ORDER BY a.timestamp DESC').all();
  res.json(rows);
});

// قابلیت حذف رکورد
Router.delete('/attendance/:id', (req, res) => {
  const id = req.params.id;
  const stmt = db.prepare('DELETE FROM attendance WHERE id = ?');
  const info = stmt.run(id);
  res.json({ deleted: info.changes });
});

module.exports = Router;
