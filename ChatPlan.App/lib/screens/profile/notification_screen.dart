import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {
        'title': 'Kuliah dimulai 30 menit lagi',
        'time': '10 menit yang lalu',
        'type': 'warning',
      },
      {
        'title': 'Deadline Capstone besok',
        'time': '1 jam yang lalu',
        'type': 'alert',
      },
      {
        'title': 'Aktivitas Belajar Flutter diperbarui',
        'time': '2 jam yang lalu',
        'type': 'info',
      },
      {
        'title': 'AI Assistant menjadwalkan Rapat HIMTI',
        'time': 'Kemarin',
        'type': 'success',
      },
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Notifikasi",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: isDark ? Colors.white : AppColors.textDark,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          
          IconData icon = Icons.notifications_rounded;
          Color color = AppColors.primary;
          Color bgColor = isDark ? AppColors.primary.withValues(alpha: 0.15) : AppColors.lavenderBg;

          if (notif['type'] == 'warning') {
            icon = Icons.warning_amber_rounded;
            color = AppColors.pending;
            bgColor = isDark ? AppColors.pending.withValues(alpha: 0.15) : AppColors.pendingBg;
          } else if (notif['type'] == 'alert') {
            icon = Icons.error_outline_rounded;
            color = AppColors.error;
            bgColor = isDark ? AppColors.error.withValues(alpha: 0.15) : AppColors.errorBg;
          } else if (notif['type'] == 'success') {
            icon = Icons.check_circle_outline_rounded;
            color = AppColors.success;
            bgColor = isDark ? AppColors.success.withValues(alpha: 0.15) : AppColors.successBg;
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.01),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notif['title']!,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif['time']!,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          color: AppColors.textLightGray,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
