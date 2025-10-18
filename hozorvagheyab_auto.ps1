# ----------------------------
# 🚀 پروژه حضور و غیاب - اجرای لوکال + Commit/Push خودکار
# ----------------------------

$projectPath = "D:\hozorvagheyab\hozorvagheyab"
$logFile = "$projectPath\hozorvagheyab_log.txt"

# 1️⃣ بررسی مسیر پروژه
if (-Not (Test-Path $projectPath)) {
    Write-Host "❌ مسیر پروژه یافت نشد: $projectPath" -ForegroundColor Red
    exit
} else {
    cd $projectPath
    Write-Host "📂 مسیر پروژه: $(Get-Location)" -ForegroundColor Green
}

# 2️⃣ نصب وابستگی‌ها
if (-Not (Test-Path "node_modules")) {
    Write-Host "📦 نصب وابستگی‌ها..."
    npm install 2>&1 | Tee-Object -FilePath $logFile
} else { Write-Host "✅ وابستگی‌ها قبلاً نصب شده‌اند." }

# 3️⃣ بررسی یا ساخت فایل .env
if (-Not (Test-Path ".env")) {
    New-Item .env -ItemType File | Out-Null
    Add-Content .env "PORT=3000"
    Add-Content .env "ADMIN_PASSWORD=یک_پسورد_قوی"
    Write-Host "⚠️ فایل .env ساخته شد. لطفاً پسورد ادمین را تغییر بده." -ForegroundColor Yellow
} else { Write-Host "✅ فایل .env از قبل موجود است." }

# 4️⃣ تغییر شاخه Git به main
git branch -M main 2>&1 | Tee-Object -Append -FilePath $logFile

# 5️⃣ گرفتن GitHub Token امن
$token = Read-Host -Prompt "🔑 لطفاً GitHub Personal Access Token خود را وارد کنید" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($token)
$plainToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
$remoteUrl = "https://Mirakzahi:$plainToken@github.com/Mirakzahi/hozorvagheyab.git"
git remote set-url origin $remoteUrl 2>&1 | Tee-Object -Append -FilePath $logFile

# 6️⃣ اجرای پروژه در ترمینال جدید
Write-Host "🚀 اجرای پروژه..."
Start-Process powershell -ArgumentList "npm start" -NoNewWindow

# 7️⃣ باز کردن مرورگر
Start-Sleep -Seconds 5
Start-Process "http://localhost:3000"
Start-Process "http://localhost:3000/admin.html"

# 8️⃣ تنظیم Watcher برای commit/push خودکار
Write-Host "🔄 مانیتور کردن تغییرات و commit/push خودکار..."
$fsw = New-Object System.IO.FileSystemWatcher $projectPath -Property @{
    IncludeSubdirectories = $true
    NotifyFilter = [System.IO.NotifyFilters]'FileName, LastWrite, DirectoryName'
    Filter = "*.*"
}

Register-ObjectEvent $fsw Changed -SourceIdentifier FileChanged -Action {
    Start-Sleep -Milliseconds 500
    git add . 2>&1 | Tee-Object -Append -FilePath $logFile
    $status = git status --porcelain
    if ($status) {
        $commitMessage = "Auto commit - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        git commit -m "$commitMessage" 2>&1 | Tee-Object -Append -FilePath $logFile
        git push origin main 2>&1 | Tee-Object -Append -FilePath $logFile
        Write-Host "✅ تغییرات خودکار push شد: $commitMessage" -ForegroundColor Green
    }
}

Write-Host "✅ پروژه در حال اجرا و تغییرات خودکار به GitHub push می‌شوند."
Write-Host "🔹 لاگ‌ها در فایل: $logFile"
Write-Host "⏳ برای پایان مانیتور، PowerShell را ببندید."
[ m a i n   2 7 e a d e f ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 6 : 4 7  
   2   f i l e s   c h a n g e d ,   7 4   i n s e r t i o n s ( + )  
   c r e a t e   m o d e   1 0 0 6 4 4   . e n v  
   c r e a t e   m o d e   1 0 0 6 4 4   h o z o r v a g h e y a b _ l o g . t x t  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       6 b b f c d 8 . . 2 7 e a d e f     m a i n   - >   m a i n  
 [ m a i n   6 2 d f 2 3 3 ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 6 : 5 0  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       2 7 e a d e f . . 6 2 d f 2 3 3     m a i n   - >   m a i n  
 [ m a i n   c f 5 3 c a b ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 6 : 5 3  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       6 2 d f 2 3 3 . . c f 5 3 c a b     m a i n   - >   m a i n  
 [ m a i n   9 3 2 d b 3 3 ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 6 : 5 6  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       c f 5 3 c a b . . 9 3 2 d b 3 3     m a i n   - >   m a i n  
 [ m a i n   f 7 4 4 8 6 f ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 6 : 5 9  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       9 3 2 d b 3 3 . . f 7 4 4 8 6 f     m a i n   - >   m a i n  
 [ m a i n   0 d 7 d e b 2 ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 7 : 0 1  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       f 7 4 4 8 6 f . . 0 d 7 d e b 2     m a i n   - >   m a i n  
 [ m a i n   7 b 9 8 3 7 7 ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 7 : 0 4  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       0 d 7 d e b 2 . . 7 b 9 8 3 7 7     m a i n   - >   m a i n  
 [ m a i n   c 7 1 4 8 d 0 ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 7 : 0 6  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       7 b 9 8 3 7 7 . . c 7 1 4 8 d 0     m a i n   - >   m a i n  
 [ m a i n   5 d 2 e c a f ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 7 : 0 9  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       c 7 1 4 8 d 0 . . 5 d 2 e c a f     m a i n   - >   m a i n  
 [ m a i n   8 8 5 2 f 6 4 ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 7 : 1 2  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       5 d 2 e c a f . . 8 8 5 2 f 6 4     m a i n   - >   m a i n  
 [ m a i n   f 6 5 c 5 9 5 ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 7 : 1 5  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       8 8 5 2 f 6 4 . . f 6 5 c 5 9 5     m a i n   - >   m a i n  
 [ m a i n   a 5 7 f 2 b c ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 7 : 1 7  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       f 6 5 c 5 9 5 . . a 5 7 f 2 b c     m a i n   - >   m a i n  
 [ m a i n   e d d c 6 1 4 ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 7 : 2 0  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       a 5 7 f 2 b c . . e d d c 6 1 4     m a i n   - >   m a i n  
 [ m a i n   3 6 9 d a 3 9 ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 7 : 2 3  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       e d d c 6 1 4 . . 3 6 9 d a 3 9     m a i n   - >   m a i n  
 [ m a i n   5 a c 2 b f 9 ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 7 : 2 6  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       3 6 9 d a 3 9 . . 5 a c 2 b f 9     m a i n   - >   m a i n  
 [ m a i n   4 a 4 0 7 7 4 ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 7 : 2 8  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       5 a c 2 b f 9 . . 4 a 4 0 7 7 4     m a i n   - >   m a i n  
 [ m a i n   b 7 2 2 a 2 4 ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 7 : 3 1  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       4 a 4 0 7 7 4 . . b 7 2 2 a 2 4     m a i n   - >   m a i n  
 [ m a i n   c 5 1 0 6 7 b ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 7 : 3 4  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       b 7 2 2 a 2 4 . . c 5 1 0 6 7 b     m a i n   - >   m a i n  
 [ m a i n   1 7 e 0 f d a ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 7 : 3 6  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       c 5 1 0 6 7 b . . 1 7 e 0 f d a     m a i n   - >   m a i n  
 [ m a i n   b f 3 c 7 4 5 ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 7 : 3 9  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       1 7 e 0 f d a . . b f 3 c 7 4 5     m a i n   - >   m a i n  
 [ m a i n   3 d 0 2 8 6 c ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 7 : 4 2  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 g i t   :   T o   h t t p s : / / g i t h u b . c o m / M i r a k z a h i / h o z o r v a g h e y a b . g i t  
 A t   l i n e : 8   c h a r : 9  
 +                   g i t   p u s h   o r i g i n   m a i n   2 > & 1   |   T e e - O b j e c t   - A p p e n d   - F i l e P a t h   $ l o g   . . .  
 +                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  
         +   C a t e g o r y I n f o                     :   N o t S p e c i f i e d :   ( T o   h t t p s : / / g i t h . . . z o r v a g h e y a b . g i t : S t r i n g )   [ ] ,   R e m o t e E x c e p t i o n  
         +   F u l l y Q u a l i f i e d E r r o r I d   :   N a t i v e C o m m a n d E r r o r  
    
       b f 3 c 7 4 5 . . 3 d 0 2 8 6 c     m a i n   - >   m a i n  
 [ m a i n   a 5 e 1 1 e 6 ]   A u t o   c o m m i t   -   2 0 2 5 - 1 0 - 1 8   1 2 : 2 7 : 4 4  
   1   f i l e   c h a n g e d ,   0   i n s e r t i o n s ( + ) ,   0   d e l e t i o n s ( - )  
 