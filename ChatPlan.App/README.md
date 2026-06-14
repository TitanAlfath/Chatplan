# ChatPlan Mobile App

ChatPlan adalah aplikasi asisten pintar berbasis mobile yang membantu merancang dan menjadwalkan aktivitas keseharian Anda menggunakan kecerdasan buatan (AI). Aplikasi ini dibangun menggunakan framework **Flutter** dan dirancang dengan antarmuka yang sangat modern, ramah pengguna, serta interaktif.

## 🚀 Status Proyek (Progress Saat Ini)

Saat ini proyek **ChatPlan** telah mencapai tahap penyelesaian dasar untuk antarmuka pengguna (UI Front-End) utama:

*   ✅ **Inisialisasi Proyek**: Pengaturan dasar Flutter dan integrasi dependensi desain seperti `google_fonts`.
*   ✅ **Halaman Landing Page (Onboarding)**: Antarmuka perkenalan yang memukau dengan maskot robot 3D interaktif, jadwal melayang (*glassmorphism*), serta penyorotan fitur utama aplikasi.
*   ✅ **Halaman Dashboard**: Halaman beranda kompleks yang merangkum produktivitas. Meliputi:
    *   Sapaan pengguna & *smart notification* dari AI.
    *   Ringkasan status tugas (Total, Selesai, Tertunda, Produktivitas).
    *   Daftar jadwal interaktif (*Timeline layout*).
    *   Kartu analitik wawasan (*Insight*) dan pencapaian mingguan (*Streak*).
    *   Sistem Navigasi Bawah (*Bottom Navigation Bar*).
*   ✅ **Sistem Navigasi**: Alur transisi dari Landing Page langsung menuju Dashboard telah terhubung sepenuhnya.

**Langkah Selanjutnya yang Direncanakan (Mendatang):**
*   [ ] Implementasi logika *state management* (mis. Provider, Riverpod, atau BLoC).
*   [ ] Implementasi halaman Chatbot AI interaktif.
*   [ ] Halaman Aktivitas dan Manajemen Tugas.
*   [ ] Halaman Analitik/Insight lebih lanjut dan Profil Pengguna.
*   [ ] Integrasi Backend API.

## 🛠️ Teknologi yang Digunakan
*   **Flutter** SDK
*   **Dart**
*   **Google Fonts** (Font Utama: Outfit)
*   Komponen Custom UI (*Gradients*, *Glassmorphism*, *BoxShadows*)

## 💻 Cara Menjalankan Proyek

1.  Pastikan Anda telah menginstal [Flutter](https://flutter.dev/docs/get-started/install).
2.  Lakukan instalasi dependensi:
    ```bash
    flutter pub get
    ```
3.  Jalankan aplikasi (misalnya di Chrome atau Emulator Android):
    ```bash
    flutter run -d chrome
    ```

---
*Proyek ini dikembangkan menggunakan dukungan asisten AI.*
