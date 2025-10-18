async function loadRecent() {
  // بارگذاری 20 رکورد اخیر
  const now = new Date();
  const from = new Date(now.getFullYear(), now.getMonth(), now.getDate() - 7).toISOString(); // 7 روز گذشته
  const res = await fetch(`/api/report?from=${encodeURIComponent(from)}`);
  const rows = await res.json();
  const el = document.getElementById('recent');
  if (!rows.length) { el.innerHTML = '<p>اطلاعی موجود نیست.</p>'; return; }
  el.innerHTML = '<ul class="list-group">'+rows.slice(-20).reverse().map(r=>`<li class="list-group-item">${r.timestamp} — ${r.name} — ${r.type}${r.note? ' — '+r.note : ''}</li>`).join('')+'</ul>';
}

document.getElementById('attendanceForm').addEventListener('submit', async (e)=>{
  e.preventDefault();
  const code = document.getElementById('code').value.trim();
  const type = document.getElementById('type').value;
  const note = document.getElementById('note').value;
  const msg = document.getElementById('msg');
  try {
    const res = await fetch('/api/attendance', {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({ employee_code: code, type, note })
    });
    const j = await res.json();
    if (!res.ok) {
      msg.innerText = j.error || 'خطا';
      msg.style.color = 'red';
    } else {
      msg.innerText = 'ثبت شد';
      msg.style.color = 'green';
      loadRecent();
    }
  } catch (err) {
    msg.innerText = 'خطا';
    msg.style.color = 'red';
  }
});

loadRecent();
