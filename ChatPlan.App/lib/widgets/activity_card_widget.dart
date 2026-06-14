import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/activity_model.dart';
import '../core/constants/app_colors.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback onTap;
  final ValueChanged<bool?>? onCheckboxChanged;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onTap,
    this.onCheckboxChanged,
  });

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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color statusColor;
    Color statusBgColor;
    String statusLabel = activity.status;

    if (activity.status == 'Selesai') {
      statusColor = AppColors.success;
      statusBgColor = isDark ? AppColors.success.withValues(alpha: 0.15) : AppColors.successBg;
    } else if (activity.status == 'Sedang Berjalan') {
      statusColor = AppColors.primary;
      statusBgColor = isDark ? AppColors.primary.withValues(alpha: 0.15) : AppColors.lavenderBg;
    } else {
      statusColor = AppColors.pending;
      statusBgColor = isDark ? AppColors.pending.withValues(alpha: 0.15) : AppColors.pendingBg;
      statusLabel = 'Tertunda';
    }

    // Determine leading icon based on title keywords or category
    IconData leadingIcon = Icons.work_rounded;
    Color iconColor = AppColors.primary;
    
    final lowerTitle = activity.title.toLowerCase();
    final lowerCategory = activity.category.toLowerCase();

    if (lowerTitle.contains('makan') || lowerCategory.contains('makan') || lowerCategory == 'umum') {
      leadingIcon = Icons.restaurant_rounded;
      iconColor = const Color(0xFFFF9E9E);
    } else if (lowerTitle.contains('olahraga') || lowerTitle.contains('lari') || lowerCategory.contains('sehat') || lowerCategory.contains('kesehatan')) {
      leadingIcon = Icons.directions_run_rounded;
      iconColor = const Color(0xFFFFDD72);
    } else if (lowerTitle.contains('kuliah') || lowerTitle.contains('rapat') || lowerCategory.contains('didik') || lowerCategory.contains('pendidikan')) {
      leadingIcon = Icons.school_rounded;
      iconColor = const Color(0xFF8DE88D);
    } else if (lowerTitle.contains('belajar') || lowerTitle.contains('coding') || lowerCategory.contains('kerja') || lowerCategory.contains('pekerjaan')) {
      leadingIcon = Icons.code_rounded;
      iconColor = const Color(0xFFFFC085);
    } else if (lowerTitle.contains('buku') || lowerTitle.contains('baca') || lowerCategory.contains('kembang') || lowerCategory.contains('pengembangan')) {
      leadingIcon = Icons.menu_book_rounded;
      iconColor = const Color(0xFF86A8E7);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                leadingIcon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            // Title & DateTime Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    activity.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textDark,
                      decoration: activity.status == 'Selesai'
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.primary.withValues(alpha: 0.15) : AppColors.lavenderBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            activity.category,
                            style: GoogleFonts.outfit(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${activity.date} • ${activity.time}",
                          style: GoogleFonts.outfit(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textLightGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Priority Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: _getPriorityBgColor(context, activity.priority),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                activity.priority,
                style: GoogleFonts.outfit(
                  fontSize: 7.5,
                  fontWeight: FontWeight.bold,
                  color: _getPriorityColor(activity.priority),
                ),
              ),
            ),
            const SizedBox(width: 6),
            // Status Chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                statusLabel,
                style: GoogleFonts.outfit(
                  fontSize: 8.5,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
            if (onCheckboxChanged != null) ...[
              const SizedBox(width: 6),
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: activity.status == 'Selesai',
                  activeColor: AppColors.primary,
                  onChanged: onCheckboxChanged,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
