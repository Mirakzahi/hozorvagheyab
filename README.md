# hozorvagheyab

سیستم ساده حضور و غیاب با Node.js + Express + SQLite

## نصب و اجرا محلی

1. کد را کلون کن یا فایل‌ها را در پوشه قرار بده.
2. `npm install`
3. یک فایل `.env` بساز و `ADMIN_PASSWORD` را تعیین کن یا از `.env.example` کپی کن.
4. دیتابیس را ایجاد کن:
   ```
   npm run init-db
   ```
5. سرور را اجرا کن:
   ```
   npm start
   ```
6. صفحه کاربر: `http://localhost:3000/`  
   پنل مدیریت: `http://localhost:3000/admin.html` (مرورگر ازت auth می‌خواد؛ user: admin و pass از متغیر ADMIN_PASSWORD)

## API
- `POST /api/attendance` { employee_code, type: "IN"|"OUT", note? }
- `GET /api/report?from=YYYY-MM-DD&to=YYYY-MM-DD&employee_code=EMP001`
- `GET /api/users`
- `POST /api/users` { name, employee_code }

## یادداشت‌ها
- دیتابیس در `db/hozor.db` ساخته می‌شود.
- برای تولید نمودارها می‌شه در آینده Chart.js اضافه کرد.
