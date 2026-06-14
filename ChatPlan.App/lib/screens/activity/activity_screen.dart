import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/activity_provider.dart';
import '../../models/activity_model.dart';
import '../../widgets/activity_card_widget.dart';
import 'activity_detail_screen.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  String _searchQuery = '';
  String _activeFilter = 'Semua';
  bool _sortByPriority = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Daftar Aktivitas",
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Kelola seluruh jadwal harian Anda",
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: isDark ? const Color(0xFF9E9EB3) : AppColors.textGray,
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar & Sort Toggle Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
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
                          const Icon(Icons.search_rounded, color: AppColors.textLightGray),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (val) {
                                setState(() {
                                  _searchQuery = val.toLowerCase();
                                });
                              },
                              style: GoogleFonts.outfit(fontSize: 14, color: isDark ? Colors.white : AppColors.textDark),
                              decoration: InputDecoration(
                                hintText: "Cari aktivitas...",
                                hintStyle: GoogleFonts.outfit(
                                  fontSize: 14,
                                  color: AppColors.textLightGray,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                              child: const Icon(Icons.close_rounded, color: AppColors.textLightGray, size: 18),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Sort Icon Toggle Button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _sortByPriority = !_sortByPriority;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _sortByPriority ? "Diurutkan berdasarkan Prioritas Utama" : "Diurutkan berdasarkan Waktu",
                            style: GoogleFonts.outfit(),
                          ),
                          duration: const Duration(milliseconds: 800),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _sortByPriority ? AppColors.primary : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: _sortByPriority ? Colors.transparent : AppColors.lavenderBg,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.sort_rounded,
                        color: _sortByPriority ? Colors.white : AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Filter Choice Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Semua', 'Hari Ini', 'Besok', 'Selesai', 'Tertunda'].map((filter) {
                    final isSelected = _activeFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _activeFilter = filter;
                            });
                          }
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: Theme.of(context).cardColor,
                        labelStyle: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.textGray,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? Colors.transparent : AppColors.lavenderBg,
                            width: 1.5,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Dynamic List View
              Expanded(
                child: Builder(
                  builder: (context) {
                    final activitiesAsync = ref.watch(activityProvider);
                    final activities = activitiesAsync.value ?? [];
                    // Filter logic
                    var filtered = activities;

                    // 1. Filter by category tab
                    if (_activeFilter == 'Hari Ini') {
                      filtered = filtered.where((a) => a.date.contains('19 Mei')).toList();
                    } else if (_activeFilter == 'Besok') {
                      filtered = filtered.where((a) => a.date.contains('20 Mei')).toList();
                    } else if (_activeFilter == 'Selesai') {
                      filtered = filtered.where((a) => a.status == 'Selesai').toList();
                    } else if (_activeFilter == 'Tertunda') {
                      filtered = filtered.where((a) => a.status == 'Tertunda' || a.status == 'Sedang Berjalan').toList();
                    }

                    // 2. Filter by search query
                    if (_searchQuery.isNotEmpty) {
                      filtered = filtered.where((a) {
                        return a.title.toLowerCase().contains(_searchQuery) ||
                            a.description.toLowerCase().contains(_searchQuery);
                      }).toList();
                    }

                    // 3. Sort by priority
                    if (_sortByPriority) {
                      final priorityWeight = {'Tinggi': 3, 'Sedang': 2, 'Rendah': 1};
                      filtered = List.from(filtered);
                      filtered.sort((a, b) {
                        final weightA = priorityWeight[a.priority] ?? 0;
                        final weightB = priorityWeight[b.priority] ?? 0;
                        return weightB.compareTo(weightA); // High first
                      });
                    }

                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          "Tidak ada aktivitas ditemukan",
                          style: GoogleFonts.outfit(
                            color: AppColors.textLightGray,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filtered.length,
                      padding: const EdgeInsets.only(bottom: 100),
                      itemBuilder: (context, index) {
                        final activity = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Dismissible(
                            key: Key(activity.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.delete_forever_rounded, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              ref.read(activityProvider.notifier).deleteActivity(activity.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Aktivitas '${activity.title}' berhasil dihapus", style: GoogleFonts.outfit()),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                            },
                            child: ActivityCard(
                              activity: activity,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ActivityDetailScreen(activity: activity),
                                  ),
                                );
                              },
                              onCheckboxChanged: (val) {
                                ref.read(activityProvider.notifier).toggleComplete(activity.id);
                                if (activity.status != 'Selesai') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("+50 XP didapatkan! Leveling up...", style: GoogleFonts.outfit()),
                                      backgroundColor: AppColors.success,
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
