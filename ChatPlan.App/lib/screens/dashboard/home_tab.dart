import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../core/constants/app_colors.dart';
import '../../providers/activity_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/theme_provider.dart';
import '../../models/activity_model.dart';
import '../activity/activity_detail_screen.dart';
import '../activity/edit_activity_screen.dart';

class HomeTab extends ConsumerWidget {
  final ValueChanged<int> onTabChange;

  const HomeTab({super.key, required this.onTabChange});

  Widget _buildAvatarWidget(String avatarName, double radius, double borderStyleWidth) {
    IconData avatarIcon = Icons.business_center_rounded;
    Color bgAvatarColor = AppColors.lavenderBg;
    Color iconAvatarColor = AppColors.primary;
    ImageProvider? imageProvider;

    if (avatarName == 'suit') {
      imageProvider = const AssetImage('assets/images/user_avatar.png');
    } else if (avatarName == 'woman') {
      avatarIcon = Icons.face_3_rounded;
      bgAvatarColor = const Color(0xFFFFECE9);
      iconAvatarColor = AppColors.error;
    } else if (avatarName == 'robot') {
      imageProvider = const AssetImage('assets/images/robot_mascot.png');
    } else if (avatarName == 'gamer') {
      avatarIcon = Icons.sports_esports_rounded;
      bgAvatarColor = const Color(0xFFFFF0E1);
      iconAvatarColor = AppColors.pending;
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary,
          width: borderStyleWidth,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
        backgroundColor: imageProvider != null ? Colors.transparent : bgAvatarColor,
        child: imageProvider != null 
            ? null 
            : Icon(avatarIcon, color: iconAvatarColor, size: radius * 0.9),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnglish = ref.watch(languageProvider);
    final activitiesAsync = ref.watch(activityProvider);
    final activities = activitiesAsync.value ?? [];
    final gamification = ref.watch(gamificationProvider);
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            // Stats Calculations
                final total = activities.length;
                final completed = activities.where((a) => a.status == 'Selesai').length;
                final pending = activities.where((a) => a.status == 'Tertunda' || a.status == 'Sedang Berjalan').length;
                final productivity = total > 0 ? ((completed / total) * 100).round() : 0;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- HEADER ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.menu_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.lavenderBg,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.primary, width: 1),
                                  ),
                                  child: Text(
                                    "LV ${gamification.level}",
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                _buildAvatarWidget(userProfile.avatar, 24, 2.0),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // --- GREETING ---
                        Builder(
                          builder: (context) {
                            
                            final name = userProfile.name;
                            String greetingExtra = isEnglish
                                ? "Have an active and productive day!"
                                : "Semangat meraih hari yang produktif!";
                            if (gamification.mood == 'Lelah') {
                              greetingExtra = isEnglish
                                  ? "Don't forget to take a short break."
                                  : "Jangan lupa istirahat sejenak ya.";
                            } else if (gamification.mood == 'Fokus') {
                              greetingExtra = isEnglish
                                  ? "Time to complete today's targets!"
                                  : "Waktunya menyelesaikan target hari ini!";
                            } else if (gamification.mood == 'Stres') {
                              greetingExtra = isEnglish
                                  ? "Relax, take a deep breath, and do it slowly."
                                  : "Santai, atur nafas dan kerjakan perlahan.";
                            }
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isEnglish ? "Hi, $name" : "Hai, $name",
                                  style: GoogleFonts.outfit(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  greetingExtra,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    color: AppColors.textGray,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        // Target Hari Ini Card
                        Container(
                          width: double.infinity,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isEnglish ? "Today's Core Focus" : "Fokus Utama Hari Ini",
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textGray,
                                    ),
                                  ),
                                  Text(
                                    isEnglish ? "$productivity% Done" : "$productivity% Selesai",
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: productivity / 100,
                                  minHeight: 8,
                                  backgroundColor: AppColors.lavenderBg,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                productivity >= 100 
                                    ? (isEnglish ? "Awesome! All tasks for today are completed!" : "Hebat! Semua aktivitas hari ini telah selesai!") 
                                    : (isEnglish ? "Complete your activities to reach full productivity." : "Selesaikan aktivitas Anda untuk mencapai produktivitas penuh."),
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  color: AppColors.textLightGray,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Mood Tracker Widget
                        MoodTrackerWidget(isEnglish: isEnglish),
                        const SizedBox(height: 20),

                        // Quick Add Categories Row
                        Text(
                          isEnglish ? "Quick Add Activity" : "Tambah Cepat Aktivitas",
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildQuickAddChip(ref, 
                                context: context,
                                icon: Icons.school_rounded,
                                label: isEnglish ? "Class" : "Kuliah",
                                color: const Color(0xFF8DE88D),
                                category: "Pendidikan",
                                isEnglish: isEnglish,
                              ),
                              _buildQuickAddChip(ref, 
                                context: context,
                                icon: Icons.code_rounded,
                                label: isEnglish ? "Learn Coding" : "Belajar Coding",
                                color: const Color(0xFFFFC085),
                                category: "Pekerjaan",
                                isEnglish: isEnglish,
                              ),
                              _buildQuickAddChip(ref, 
                                context: context,
                                icon: Icons.directions_run_rounded,
                                label: isEnglish ? "Workout" : "Olahraga",
                                color: const Color(0xFFFFDD72),
                                category: "Kesehatan",
                                isEnglish: isEnglish,
                              ),
                              _buildQuickAddChip(ref, 
                                context: context,
                                icon: Icons.restaurant_rounded,
                                label: isEnglish ? "Lunch" : "Makan Siang",
                                color: const Color(0xFFFF9E9E),
                                category: "Umum",
                                isEnglish: isEnglish,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Date Chip & Mascot
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_rounded,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isEnglish ? "Monday, May 19, 2026" : "Senin 19 Mei 2026",
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Speech Bubble Mascot
                            Expanded(
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.centerLeft,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.04),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      isEnglish ? "Ready to help\nyour day!" : "Siap bantu\nkeseharianmu",
                                      style: GoogleFonts.outfit(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: -15,
                                    bottom: -35,
                                    child: Image.asset(
                                      'assets/images/robot_mascot.png',
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // --- RINGKASAN HARI INI ---
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEnglish ? "Today's Summary" : "Ringkasan Hari ini",
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStatCard(
                                    context: context,
                                    icon: Icons.calendar_today_rounded,
                                    iconColor: const Color(0xFFDB94FE),
                                    iconBg: const Color(0xFFF7E6FF),
                                    value: "$total",
                                    label: isEnglish ? "Total Tasks" : "Total Aktifitas",
                                  ),
                                  _buildStatCard(
                                    context: context,
                                    icon: Icons.check_circle_rounded,
                                    iconColor: AppColors.success,
                                    iconBg: AppColors.successBg,
                                    value: "$completed",
                                    label: isEnglish ? "Completed" : "Selesai",
                                  ),
                                  _buildStatCard(
                                    context: context,
                                    icon: Icons.access_time_filled_rounded,
                                    iconColor: AppColors.pending,
                                    iconBg: AppColors.pendingBg,
                                    value: "$pending",
                                    label: isEnglish ? "Pending" : "Tertunda",
                                  ),
                                  _buildStatCard(
                                    context: context,
                                    icon: Icons.track_changes_rounded,
                                    iconColor: AppColors.primary,
                                    iconBg: AppColors.lavenderBg,
                                    value: "$productivity%",
                                    label: isEnglish ? "Productivity" : "Produktifitas",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // --- JADWAL & INSIGHT ---
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left: Timeline Jadwal
                            Expanded(
                              flex: 5,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.03),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isEnglish ? "Today's Schedule" : "Jadwal Hari Ini",
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ...activities.take(6).toList().asMap().entries.map((entry) {
                                      final idx = entry.key;
                                      final activity = entry.value;
                                      return _buildTimelineItem(ref, 
                                        context: context,
                                        activity: activity,
                                        isFirst: idx == 0,
                                        isLast: idx == activities.take(6).length - 1,
                                        isEnglish: isEnglish,
                                      );
                                    }),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () => onTabChange(1), // Go to Aktivitas
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: AppColors.lavenderBg, width: 1.5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              isEnglish ? "View more" : "Lihat lainnya",
                                              style: GoogleFonts.outfit(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 16,
                                              color: AppColors.primary,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Right: Insight, Streak, Pomodoro
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  // Insight
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [AppColors.secondary, AppColors.primary],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(alpha: 0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Insight",
                                              style: GoogleFonts.outfit(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const Spacer(),
                                            const Icon(
                                              Icons.auto_awesome_rounded,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          isEnglish ? "Morning habits boost focus" : "Produktivitas meningkat pagi hari",
                                          style: GoogleFonts.outfit(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            height: 1.25,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () => onTabChange(3), // Go to Insight
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: AppColors.primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              elevation: 0,
                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                            ),
                                            child: Text(
                                              isEnglish ? "Detail" : "Detail",
                                              style: GoogleFonts.outfit(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Streak
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.03),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Streak",
                                          style: GoogleFonts.outfit(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 24),
                                            const SizedBox(width: 4),
                                            Text(
                                              "7",
                                              style: GoogleFonts.outfit(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                isEnglish ? "Days" : "Hari",
                                                style: GoogleFonts.outfit(
                                                  fontSize: 9.5,
                                                  color: AppColors.textGray,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: List.generate(7, (index) {
                                            final isCompleted = index < 6;
                                            return Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isCompleted ? AppColors.primary : Colors.transparent,
                                                border: isCompleted 
                                                    ? null 
                                                    : Border.all(color: const Color(0xFFD4D4E2), width: 1.5),
                                              ),
                                              child: isCompleted 
                                                  ? const Icon(Icons.check, size: 8, color: Colors.white)
                                                  : null,
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Pomodoro Timer Card
                                  PomodoroTimerCard(isEnglish: isEnglish),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // --- BOTTOM BANNER ---
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBE9FE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isEnglish ? "Plan activities?" : "Rancang aktivitas?",
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isEnglish ? "Chat with AI assistant" : "Obrolkan dengan asisten AI",
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        color: AppColors.textGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => onTabChange(2), // Go to Chat
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  elevation: 0,
                                ),
                                child: Text(
                                  isEnglish ? "Start Chat" : "Mulai Chat",
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 90),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddOptions(context, isEnglish),
            backgroundColor: AppColors.primary,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        );
  }

  void _showAddOptions(BuildContext context, bool isEnglish) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textLightGray.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isEnglish ? "Add New Plan" : "Tambah Rencana Baru",
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.lavenderBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_task_rounded, color: AppColors.primary),
                ),
                title: Text(
                  isEnglish ? "Add Activity Manually" : "Tambah Aktivitas Manual",
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  isEnglish ? "Enter schedule details manually" : "Masukkan jadwal secara manual",
                  style: GoogleFonts.outfit(color: AppColors.textGray, fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditActivityScreen()),
                  );
                },
              ),
              const Divider(color: AppColors.divider, height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.successBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, color: AppColors.success),
                ),
                title: Text(
                  isEnglish ? "Create with AI Chat" : "Buat dengan AI Chat",
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  isEnglish ? "Schedule automatically via chat" : "Jadwalkan otomatis lewat percakapan",
                  style: GoogleFonts.outfit(color: AppColors.textGray, fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onTabChange(2); // Switch to Chat tab
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String value,
    required String label,
  }) {
    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 8.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textLightGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(WidgetRef ref, {
    required BuildContext context,
    required Activity activity,
    bool isFirst = false,
    bool isLast = false,
    required bool isEnglish,
  }) {
    Color itemColor = AppColors.primary;
    if (activity.status == 'Selesai') {
      itemColor = AppColors.success;
    } else if (activity.status == 'Tertunda') {
      itemColor = AppColors.pending;
    }

    String displayStatus = activity.status;
    if (isEnglish) {
      if (activity.status == 'Selesai') {
        displayStatus = 'Completed';
      } else if (activity.status == 'Sedang Berjalan') {
        displayStatus = 'In Progress';
      } else {
        displayStatus = 'Pending';
      }
    }

    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              activity.time.replaceAll(' WIB', ''),
              style: GoogleFonts.outfit(
                fontSize: 10,
                color: AppColors.textLightGray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Expanded(
                child: Container(
                  width: 1.5,
                  color: isFirst ? Colors.transparent : const Color(0xFFECECFA),
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: itemColor,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Container(
                  width: 1.5,
                  color: isLast ? Colors.transparent : const Color(0xFFECECFA),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityDetailScreen(activity: activity),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFF3F3FA), width: 1.5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        activity.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          decoration: activity.status == 'Selesai'
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: activity.status == 'Selesai' ? AppColors.successBg : AppColors.lavenderBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        displayStatus,
                        style: GoogleFonts.outfit(
                          fontSize: 7.5,
                          fontWeight: FontWeight.bold,
                          color: activity.status == 'Selesai' ? AppColors.success : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAddChip(WidgetRef ref, {
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required String category,
    required bool isEnglish,
  }) {
    return GestureDetector(
      onTap: () {
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        ref.read(activityProvider.notifier).addActivity(
          Activity(
            id: id,
            title: label,
            description: isEnglish
                ? "Activity quickly added from Dashboard."
                : "Aktivitas cepat ditambahkan dari Dashboard.",
            time: "10:00 WIB",
            date: "19 Mei 2026",
            status: "Sedang Berjalan",
            priority: "Sedang",
            category: category,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEnglish ? "Activity '$label' added successfully!" : "Aktivitas '$label' berhasil ditambahkan!",
              style: GoogleFonts.outfit(),
            ),
            backgroundColor: AppColors.success,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lavenderBg, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Mood Tracker Card Widget
class MoodTrackerWidget extends ConsumerWidget {
  final bool isEnglish;

  MoodTrackerWidget({super.key, required this.isEnglish});

  final List<Map<String, String>> moods = [
    {
      'emoji': '😊', 
      'name': 'Bahagia', 
      'nameEn': 'Happy',
      'desc': 'Keren! Pertahankan aura positifmu hari ini!',
      'descEn': 'Great! Keep up your positive vibes today!'
    },
    {
      'emoji': '😴', 
      'name': 'Lelah', 
      'nameEn': 'Tired',
      'desc': 'Jangan terlalu dipaksakan, luangkan waktu istirahat.',
      'descEn': "Don't push too hard, take some time to rest."
    },
    {
      'emoji': '🎯', 
      'name': 'Fokus', 
      'nameEn': 'Focused',
      'desc': 'Kondisi terbaik untuk menyelesaikan tugas berat!',
      'descEn': 'Best condition to solve difficult tasks!'
    },
    {
      'emoji': '🤯', 
      'name': 'Stres', 
      'nameEn': 'Stressed',
      'desc': 'Tarik nafas dalam-dalam, mari selesaikan satu-satu.',
      'descEn': 'Take a deep breath, let\'s solve them one by one.'
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnglish = ref.watch(languageProvider);
    final gamification = ref.watch(gamificationProvider);
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEnglish ? "Daily Mood" : "Mood Hari Ini",
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Builder(
            builder: (context) {
              final activeMood = gamification.mood;
              final activeItem = moods.firstWhere(
                (m) => m['name'] == activeMood || m['nameEn'] == activeMood,
                orElse: () => moods[0],
              );
              
              final activeMoodDesc = isEnglish ? activeItem['descEn']! : activeItem['desc']!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: moods.map((m) {
                      final isSelected = m['name'] == activeMood || m['nameEn'] == activeMood;
                      return GestureDetector(
                        onTap: () {
                          ref.read(gamificationProvider.notifier).updateMood(isEnglish ? m['nameEn']! : m['name']!);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.lavenderBg : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            m['emoji']!,
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "\"$activeMoodDesc\"",
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// Pomodoro Focus Timer Card Widget
class PomodoroTimerCard extends ConsumerStatefulWidget {
  final bool isEnglish;
  const PomodoroTimerCard({super.key, required this.isEnglish});

  @override
  ConsumerState<PomodoroTimerCard> createState() => _PomodoroTimerCardState();
}

class _PomodoroTimerCardState extends ConsumerState<PomodoroTimerCard> {
  int _secondsRemaining = 25 * 60;
  Timer? _timer;
  bool _isActive = false;
  bool _isWorkMode = true;

  void _toggleTimer() {
    if (_isActive) {
      _timer?.cancel();
      setState(() {
        _isActive = false;
      });
    } else {
      setState(() {
        _isActive = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() {
            _secondsRemaining--;
          });
        } else {
          _timer?.cancel();
          setState(() {
            _isActive = false;
            _isWorkMode = !_isWorkMode;
            _secondsRemaining = (_isWorkMode ? 25 : 5) * 60;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isWorkMode 
                    ? (widget.isEnglish ? "Time to focus again!" : "Waktunya fokus kembali!") 
                    : (widget.isEnglish ? "Time for a short break!" : "Waktunya istirahat sejenak!"),
                style: GoogleFonts.outfit(),
              ),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isActive = false;
      _secondsRemaining = (_isWorkMode ? 25 : 5) * 60;
    });
  }

  void _switchMode(bool workMode) {
    _timer?.cancel();
    setState(() {
      _isActive = false;
      _isWorkMode = workMode;
      _secondsRemaining = (_isWorkMode ? 25 : 5) * 60;
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEnglish = ref.watch(languageProvider);
    final gamification = ref.watch(gamificationProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFFF3F3FA), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isEnglish ? "Focus Pomodoro" : "Fokus Pomodoro",
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.timer_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Timer Display
          Center(
            child: Column(
              children: [
                Text(
                  _formatTime(_secondsRemaining),
                  style: GoogleFonts.outfit(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: _isWorkMode ? AppColors.primary : AppColors.success,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isWorkMode 
                      ? (widget.isEnglish ? "FOCUS MODE" : "MODE FOKUS") 
                      : (widget.isEnglish ? "BREAK MODE" : "MODE ISTIRAHAT"),
                  style: GoogleFonts.outfit(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  _isActive ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
                onPressed: _toggleTimer,
              ),
              IconButton(
                icon: const Icon(
                  Icons.replay_rounded,
                  color: AppColors.textLightGray,
                  size: 20,
                ),
                onPressed: _resetTimer,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Mode Selectors
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => _switchMode(true),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isWorkMode ? AppColors.lavenderBg : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.isEnglish ? "Focus (25m)" : "Fokus (25m)",
                    style: GoogleFonts.outfit(
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                      color: _isWorkMode ? AppColors.primary : AppColors.textGray,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _switchMode(false),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: !_isWorkMode ? AppColors.successBg : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.isEnglish ? "Break (5m)" : "Istirahat (5m)",
                    style: GoogleFonts.outfit(
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                      color: !_isWorkMode ? AppColors.success : AppColors.textGray,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
