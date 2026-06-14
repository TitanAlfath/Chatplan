import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/activity_provider.dart';
import '../../models/activity_model.dart';
import 'edit_activity_screen.dart';

class ActivityDetailScreen extends ConsumerWidget {
  final Activity activity;

  const ActivityDetailScreen({super.key, required this.activity});

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Tinggi':
        return AppColors.error;
      case 'Sedang':
        return AppColors.pending;
      case 'Rendah':
        return AppColors.success;
      default:
        return AppColors.textGray;
    }
  }

  Color _getPriorityBgColor(BuildContext context, String priority) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (priority) {
      case 'Tinggi':
        return isDark ? AppColors.error.withValues(alpha: 0.15) : AppColors.errorBg;
      case 'Sedang':
        return isDark ? AppColors.pending.withValues(alpha: 0.15) : AppColors.pendingBg;
      case 'Rendah':
        return isDark ? AppColors.success.withValues(alpha: 0.15) : AppColors.successBg;
      default:
        return isDark ? AppColors.primary.withValues(alpha: 0.15) : AppColors.lavenderBg;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Detail Aktivitas",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: isDark ? Colors.white : AppColors.textDark,
        elevation: 0,
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          final activitiesAsync = ref.watch(activityProvider);
          final activities = activitiesAsync.value ?? [];
          // Safe lookup for live updates
          final Activity currentActivity;
          try {
            currentActivity = activities.firstWhere((a) => a.id == activity.id);
          } catch (e) {
            // If deleted, return empty scaffold body as we pop out
            return const SizedBox.shrink();
          }

          Color statusColor;
          Color statusBgColor;
          if (currentActivity.status == 'Selesai') {
            statusColor = AppColors.success;
            statusBgColor = isDark ? AppColors.success.withValues(alpha: 0.15) : AppColors.successBg;
          } else if (currentActivity.status == 'Sedang Berjalan') {
            statusColor = AppColors.primary;
            statusBgColor = isDark ? AppColors.primary.withValues(alpha: 0.15) : AppColors.lavenderBg;
          } else {
            statusColor = AppColors.pending;
            statusBgColor = isDark ? AppColors.pending.withValues(alpha: 0.15) : AppColors.pendingBg;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Activity Main Card Info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              currentActivity.status,
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                          // Date info
                          Text(
                            currentActivity.date,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textLightGray,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        currentActivity.title,
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Category & Priority Row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.primary.withValues(alpha: 0.15) : AppColors.lavenderBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.folder_open_rounded, color: AppColors.primary, size: 12),
                                const SizedBox(width: 4),
                                Text(
                                  currentActivity.category,
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getPriorityBgColor(context, currentActivity.priority),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.flag_rounded, color: _getPriorityColor(currentActivity.priority), size: 12),
                                const SizedBox(width: 4),
                                Text(
                                  "Prioritas: ${currentActivity.priority}",
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _getPriorityColor(currentActivity.priority),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 12),
                      Text(
                        "Deskripsi",
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFF9E9EB3) : AppColors.textGray,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        currentActivity.description.isNotEmpty
                            ? currentActivity.description
                            : "Tidak ada deskripsi untuk aktivitas ini.",
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : AppColors.textGray,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.access_time_filled_rounded, color: AppColors.primary, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            currentActivity.time,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Button: Tandai Selesai
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(activityProvider.notifier).toggleComplete(currentActivity.id);
                      if (currentActivity.status != 'Selesai') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("+50 XP didapatkan! Leveling up...", style: GoogleFonts.outfit()),
                            backgroundColor: AppColors.success,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentActivity.status == 'Selesai'
                          ? AppColors.textLightGray
                          : AppColors.success,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      currentActivity.status == 'Selesai'
                          ? "Tandai Belum Selesai"
                          : "Tandai Selesai",
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Row of Edit & Delete Buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditActivityScreen(activity: currentActivity),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.edit_rounded, color: AppColors.primary, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                "Edit",
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => _confirmDelete(context, ref, currentActivity.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.errorBg,
                            foregroundColor: AppColors.error,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.delete_rounded, color: AppColors.error, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                "Hapus",
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            "Konfirmasi Hapus",
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Apakah Anda yakin ingin menghapus aktivitas ini?",
            style: GoogleFonts.outfit(color: AppColors.textGray),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "Batal",
                style: GoogleFonts.outfit(color: AppColors.textGray, fontWeight: FontWeight.bold),
              ),
            ),
              ElevatedButton(
              onPressed: () {
                ref.read(activityProvider.notifier).deleteActivity(id);
                Navigator.pop(dialogContext); // Close dialog
                Navigator.pop(context); // Go back to List screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: Text(
                "Hapus",
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
