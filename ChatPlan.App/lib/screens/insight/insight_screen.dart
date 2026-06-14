import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../core/constants/app_colors.dart';
import '../../providers/activity_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/activity_model.dart';

class InsightScreen extends ConsumerStatefulWidget {
  const InsightScreen({super.key});

  @override
  ConsumerState<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends ConsumerState<InsightScreen> {
  int _currentAdviceIndex = 0;
  bool _isRegenerating = false;

  final List<Map<String, String>> _aiAdvices = [
    {
      'title': 'Analisis Kebiasaan Pagi',
      'desc': 'Kamu paling produktif pada jam 08.00 - 10.00. Manfaatkan waktu ini untuk menyelesaikan aktivitas prioritas tinggi Anda.'
    },
    {
      'title': 'Optimasi Istirahat',
      'desc': 'Rasio penyelesaian tugas kamu tinggi setelah olahraga. Cobalah menjadwalkan tugas sulit tepat setelah jeda fisik.'
    },
    {
      'title': 'Saran Manajemen Waktu',
      'desc': 'Kamu menyelesaikan tugas Pendidikan hari ini dengan sangat baik! Namun tugas Pekerjaan masih tertunda. Alokasikan waktu sedikit lebih awal besok.'
    },
    {
      'title': 'Rekomendasi Fokus',
      'desc': 'Gunakan teknik Pomodoro 25/5 untuk tugas berkategori Pengembangan Diri agar konsentrasi tetap terjaga secara optimal.'
    }
  ];

  void _regenerateAdvice() {
    setState(() {
      _isRegenerating = true;
    });
    Timer(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _isRegenerating = false;
        _currentAdviceIndex = (_currentAdviceIndex + 1) % _aiAdvices.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Insight Mingguan",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          final activitiesAsync = ref.watch(activityProvider);
          final activities = activitiesAsync.value ?? [];
          final total = activities.length;
          final completed = activities.where((a) => a.status == 'Selesai').length;
          final pending = activities.where((a) => a.status == 'Tertunda' || a.status == 'Sedang Berjalan').length;
          final productivityScore = total > 0 ? ((completed / total) * 100).round() : 71;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Productivity score card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.secondary, AppColors.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Skor Produktivitas",
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "$productivityScore%",
                              style: GoogleFonts.outfit(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Minggu Ini",
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Circular indicator inside card
                      SizedBox(
                        width: 72,
                        height: 72,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 64,
                              height: 64,
                              child: CircularProgressIndicator(
                                value: productivityScore / 100,
                                strokeWidth: 7,
                                backgroundColor: Colors.white.withValues(alpha: 0.2),
                                color: Colors.white,
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Text(
                              "$productivityScore%",
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Statistics row
                Row(
                  children: [
                    _buildStatDetailCard(context, "Selesai", "$completed", AppColors.success),
                    const SizedBox(width: 12),
                    _buildStatDetailCard(context, "Tertunda", "$pending", AppColors.pending),
                    const SizedBox(width: 12),
                    _buildStatDetailCard(context, "Total", "$total", AppColors.primary),
                  ],
                ),
                const SizedBox(height: 24),

                // Chart Container using fl_chart
                Container(
                  padding: const EdgeInsets.all(20),
                  height: 260,
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
                      Text(
                        "Produktivitas 7 Hari Terakhir",
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 100,
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (double value, TitleMeta meta) {
                                    const style = TextStyle(
                                      color: AppColors.textGray,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    );
                                    Widget text;
                                    switch (value.toInt()) {
                                      case 0:
                                        text = const Text('Sen', style: style);
                                        break;
                                      case 1:
                                        text = const Text('Sel', style: style);
                                        break;
                                      case 2:
                                        text = const Text('Rab', style: style);
                                        break;
                                      case 3:
                                        text = const Text('Kam', style: style);
                                        break;
                                      case 4:
                                        text = const Text('Jum', style: style);
                                        break;
                                      case 5:
                                        text = const Text('Sab', style: style);
                                        break;
                                      case 6:
                                        text = const Text('Min', style: style);
                                        break;
                                      default:
                                        text = const Text('', style: style);
                                        break;
                                    }
                                    return SideTitleWidget(
                                      meta: meta,
                                      space: 4.0,
                                      child: text,
                                    );
                                  },
                                ),
                              ),
                              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: const FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            barGroups: [
                              BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 60, color: AppColors.primary, width: 12, borderRadius: BorderRadius.circular(4))]),
                              BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 85, color: AppColors.primary, width: 12, borderRadius: BorderRadius.circular(4))]),
                              BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 70, color: AppColors.primary, width: 12, borderRadius: BorderRadius.circular(4))]),
                              BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 90, color: AppColors.primary, width: 12, borderRadius: BorderRadius.circular(4))]),
                              BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 50, color: AppColors.primary, width: 12, borderRadius: BorderRadius.circular(4))]),
                              BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 30, color: AppColors.primary, width: 12, borderRadius: BorderRadius.circular(4))]),
                              BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 40, color: AppColors.primary, width: 12, borderRadius: BorderRadius.circular(4))]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Goal Target Setter Slider
                Container(
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
                      Text(
                        "Target Produktivitas Harian",
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Builder(
                        builder: (context) {
                          final targetVal = ref.watch(gamificationProvider).targetPercentage;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Target Minimal:",
                                    style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textGray),
                                  ),
                                  Text(
                                    "${targetVal.round()}%",
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              Slider(
                                value: targetVal,
                                min: 50,
                                max: 100,
                                divisions: 10,
                                activeColor: AppColors.primary,
                                inactiveColor: AppColors.lavenderBg,
                                onChanged: (newVal) {
                                  ref.read(gamificationProvider.notifier).updateTargetPercentage(newVal);
                                },
                              ),
                              Text(
                                productivityScore >= targetVal
                                    ? "Luar biasa! Pencapaian Anda saat ini ($productivityScore%) telah melampaui target."
                                    : "Ayo semangat! Kamu kurang ${(targetVal - productivityScore).round()}% lagi untuk mencapai target.",
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: productivityScore >= targetVal ? AppColors.success : AppColors.pending,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // AI Insight Card
                Container(
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
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                "Rekomendasi Pintar AI",
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.refresh_rounded, 
                              color: _isRegenerating ? AppColors.textLightGray : AppColors.primary,
                              size: 20,
                            ),
                            onPressed: _isRegenerating ? null : _regenerateAdvice,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_isRegenerating)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary),
                            ),
                          ),
                        )
                      else ...[
                        Text(
                          _aiAdvices[_currentAdviceIndex]['title']!,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _aiAdvices[_currentAdviceIndex]['desc']!,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppColors.textGray,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Kategori Breakdown Card
                Container(
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
                      Text(
                        "Produktivitas Kategori",
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildCategoryProgress("Pendidikan", activities),
                      const SizedBox(height: 12),
                      _buildCategoryProgress("Kesehatan", activities),
                      const SizedBox(height: 12),
                      _buildCategoryProgress("Pengembangan Diri", activities),
                      const SizedBox(height: 12),
                      _buildCategoryProgress("Pekerjaan", activities),
                      const SizedBox(height: 12),
                      _buildCategoryProgress("Umum", activities),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatDetailCard(BuildContext context, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.textGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryProgress(String category, List<Activity> activities) {
    final catActivities = activities.where((a) => a.category == category).toList();
    final catTotal = catActivities.length;
    final catCompleted = catActivities.where((a) => a.status == 'Selesai').length;
    
    double progress = 0.0;
    if (catTotal > 0) {
      progress = catCompleted / catTotal;
    } else {
      if (category == 'Pendidikan') {
        progress = 0.8;
      } else if (category == 'Kesehatan') {
        progress = 0.6;
      } else if (category == 'Pengembangan Diri') {
        progress = 0.4;
      } else if (category == 'Pekerjaan') {
        progress = 0.5;
      } else {
        progress = 0.3;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textGray,
              ),
            ),
            Text(
              "${(progress * 100).round()}%",
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.lavenderBg,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
