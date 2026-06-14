# Chat Plan - AI Powered Activity Planner

## Deskripsi Proyek
ChatPlan adalah aplikasi asisten pintar berbasis mobile yang membantu merancang dan menjadwalkan aktivitas keseharian Anda menggunakan kecerdasan buatan (AI). Aplikasi ini dibangun dengan UI modern berbasis Flutter dan backend tangguh menggunakan FastAPI dan PostgreSQL.

## Latar Belakang
Di era modern, manajemen waktu menjadi tantangan besar. Chat Plan hadir sebagai solusi cerdas untuk mempermudah pengguna menjadwalkan kegiatan dengan bantuan AI.

## Fitur Utama
*   **AI Chat Assistant**: Merencanakan kegiatan harian dengan mengobrol bersama AI.
*   **Activity Timeline**: Visualisasi jadwal kegiatan.
*   **Smart Notifications**: Pengingat cerdas dari AI.
*   **Analytics & Insight**: Laporan produktivitas mingguan.

## Arsitektur Sistem
Aplikasi ini menggunakan arsitektur Client-Server:
- **Client**: Aplikasi Mobile (Flutter)
- **Server**: REST API (FastAPI - Python)
- **Database**: Relational Database (PostgreSQL)
- **AI Integration**: Google Gemini API

## Teknologi yang Digunakan
*   **Frontend**: Flutter, Dart, Riverpod
*   **Backend**: Python, FastAPI, SQLAlchemy
*   **Database**: PostgreSQL
*   **AI**: Google Gemini Pro

## Struktur Folder
```text
ChatPlan/
├── .gitignore               # Aturan ignore file git (root)
├── README.md                # Dokumentasi utama proyek
├── database/                # Skema dan dump database
│   └── schema.sql           # DDL Struktur Tabel
├── ChatPlan.Backend/        # FastAPI Source Code
│   ├── app/                 # Logic Utama (Routes, Models, dsb)
│   ├── .env.example         # Contoh variabel environment
│   └── requirements.txt     # Library Python
└── ChatPlan.App/            # Flutter Source Code
    ├── lib/                 # Logic Utama (Screens, Providers)
    └── pubspec.yaml         # Library Flutter
```

## Cara Instalasi & Menjalankan Aplikasi

### Setup Database (PostgreSQL)
1. Install PostgreSQL di komputer Anda.
2. Buat database baru bernama `chatplan_db`.
3. Jalankan file `database/schema.sql` di database tersebut untuk membuat tabel.

### Setup Backend (FastAPI)
1. Buka terminal di folder `ChatPlan.Backend`.
2. Buat Virtual Environment: `python -m venv venv`
3. Aktifkan Virtual Environment:
   - Windows: `venv\Scripts\activate`
   - Mac/Linux: `source venv/bin/activate`
4. Install dependencies: `pip install -r requirements.txt`
5. Copy `.env.example` menjadi `.env` dan isi kredensial Anda (API Key Gemini & Password Database).
6. Jalankan server: `uvicorn app.main:app --reload`
7. Backend akan berjalan di `http://127.0.0.1:8000`

### Setup Frontend (Flutter)
1. Buka terminal di folder `ChatPlan.App`.
2. Install dependencies: `flutter pub get`
3. Jalankan aplikasi: `flutter run`

## Dokumentasi Endpoint API
API terdokumentasi secara otomatis melalui Swagger UI.
Setelah backend berjalan, buka browser dan akses URL berikut untuk melihat spesifikasi dan mencoba API langsung:
**http://127.0.0.1:8000/docs**

## Screenshot
*(Ganti placeholder ini dengan link screenshot aplikasi Anda nantinya)*
![Screenshot 1](#) ![Screenshot 2](#)

## Anggota Tim
1. [Nama Anda] - [NIM/Peran]
2. [Anggota 2] - [NIM/Peran]
