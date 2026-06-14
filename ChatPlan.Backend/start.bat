@echo off
echo =========================================
echo       Menjalankan Chat Plan Backend
echo =========================================

REM Cek apakah folder venv ada
if exist venv\Scripts\activate (
    echo Mengaktifkan virtual environment...
    call venv\Scripts\activate
) else (
    echo [Peringatan] Virtual environment 'venv' tidak ditemukan. 
    echo Menjalankan dengan environment global python...
)

echo.
echo Server berjalan di jaringan lokal. 
echo - Jika menggunakan browser di PC ini: http://localhost:8000
echo - Jika menggunakan Emulator Android: http://10.0.2.2:8000
echo - Jika menggunakan HP fisik: Akses menggunakan IP komputer Anda (contoh: http://192.168.1.x:8000)
echo.

uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
pause
