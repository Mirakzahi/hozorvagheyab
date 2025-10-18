const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const apiRoutes = require('./routes/api');
const adminRoutes = require('./routes/admin');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Static files (frontend)
app.use('/', express.static(path.join(__dirname, 'public')));

// API routes
app.use('/api', apiRoutes);

// Admin routes (simple basic auth inside)
app.use('/admin-api', adminRoutes);

// fallback
app.use((req, res) => {
  res.status(404).send('Not Found');
});

app.listen(PORT, () => {
  console.log(`Hozorvagheyab running on http://localhost:${PORT}`);
});
