import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/activity_provider.dart';
import '../../models/activity_model.dart';

class EditActivityScreen extends ConsumerStatefulWidget {
  final Activity? activity;

  const EditActivityScreen({super.key, this.activity});

  @override
  ConsumerState<EditActivityScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends ConsumerState<EditActivityScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late String _selectedStatus;
  late String _selectedPriority;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.activity?.title ?? '');
    _descController = TextEditingController(text: widget.activity?.description ?? '');
    _dateController = TextEditingController(text: widget.activity?.date ?? '19 Mei 2026');
    _timeController = TextEditingController(text: widget.activity?.time ?? '08:00 WIB');
    _selectedStatus = widget.activity?.status ?? 'Sedang Berjalan';
    _selectedPriority = widget.activity?.priority ?? 'Sedang';
    _selectedCategory = widget.activity?.category ?? 'Umum';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2026, 5, 19),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      final months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];
      final monthName = months[picked.month - 1];
      setState(() {
        _dateController.text = "${picked.day} $monthName ${picked.year}";
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      final hourStr = picked.hour.toString().padLeft(2, '0');
      final minuteStr = picked.minute.toString().padLeft(2, '0');
      setState(() {
        _timeController.text = "$hourStr:$minuteStr WIB";
      });
    }
  }

  void _saveActivity() {
    if (!_formKey.currentState!.validate()) return;

    final id = widget.activity?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final newActivity = Activity(
      id: id,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      time: _timeController.text.trim(),
      date: _dateController.text.trim(),
      status: _selectedStatus,
      priority: _selectedPriority,
      category: _selectedCategory,
    );

    if (widget.activity == null) {
      ref.read(activityProvider.notifier).addActivity(newActivity);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Aktivitas berhasil ditambahkan!", style: GoogleFonts.outfit()),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ref.read(activityProvider.notifier).updateActivity(newActivity);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Aktivitas berhasil diperbarui!", style: GoogleFonts.outfit()),
          backgroundColor: AppColors.primary,
        ),
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.activity != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          isEditing ? "Sunting Aktivitas" : "Tambah Aktivitas",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: isDark ? Colors.white : AppColors.textDark,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form Card
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
                    // Title field
                    Text(
                      "Nama Aktivitas",
                      style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textGray),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      style: GoogleFonts.outfit(fontSize: 14, color: isDark ? Colors.white : AppColors.textDark),
                      decoration: InputDecoration(
                        hintText: "Contoh: Rapat HIMTI",
                        hintStyle: GoogleFonts.outfit(color: AppColors.textLightGray, fontSize: 14),
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Nama aktivitas wajib diisi";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Description field
                    Text(
                      "Deskripsi",
                      style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textGray),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descController,
                      maxLines: 4,
                      style: GoogleFonts.outfit(fontSize: 14, color: isDark ? Colors.white : AppColors.textDark),
                      decoration: InputDecoration(
                        hintText: "Tulis rincian aktivitas...",
                        hintStyle: GoogleFonts.outfit(color: AppColors.textLightGray, fontSize: 14),
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Date & Time Picker Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tanggal",
                                style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textGray),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _selectDate,
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _dateController,
                                    style: GoogleFonts.outfit(fontSize: 14, color: isDark ? Colors.white : AppColors.textDark),
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 18),
                                      filled: true,
                                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Waktu",
                                style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textGray),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _selectTime,
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _timeController,
                                    style: GoogleFonts.outfit(fontSize: 14, color: isDark ? Colors.white : AppColors.textDark),
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.access_time_rounded, color: AppColors.primary, size: 18),
                                      filled: true,
                                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Kategori & Prioritas Dropdown Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kategori",
                                style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textGray),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                initialValue: _selectedCategory,
                                style: GoogleFonts.outfit(fontSize: 13, color: isDark ? Colors.white : AppColors.textDark),
                                dropdownColor: Theme.of(context).cardColor,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                                items: ['Pendidikan', 'Kesehatan', 'Pengembangan Diri', 'Pekerjaan', 'Umum'].map((cat) {
                                  return DropdownMenuItem<String>(
                                    value: cat,
                                    child: Text(cat, style: GoogleFonts.outfit(fontSize: 12, color: isDark ? Colors.white : AppColors.textDark)),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedCategory = val;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Prioritas",
                                style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textGray),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                initialValue: _selectedPriority,
                                style: GoogleFonts.outfit(fontSize: 13, color: isDark ? Colors.white : AppColors.textDark),
                                dropdownColor: Theme.of(context).cardColor,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                                items: ['Tinggi', 'Sedang', 'Rendah'].map((pri) {
                                  return DropdownMenuItem<String>(
                                    value: pri,
                                    child: Text(pri, style: GoogleFonts.outfit(fontSize: 12, color: isDark ? Colors.white : AppColors.textDark)),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedPriority = val;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Status field
                    Text(
                      "Status",
                      style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textGray),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedStatus,
                      style: GoogleFonts.outfit(fontSize: 14, color: isDark ? Colors.white : AppColors.textDark),
                      dropdownColor: Theme.of(context).cardColor,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      items: ['Sedang Berjalan', 'Selesai', 'Tertunda'].map((status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status, style: GoogleFonts.outfit(color: isDark ? Colors.white : AppColors.textDark)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedStatus = val;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Button: Save
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveActivity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isEditing ? "Simpan Perubahan" : "Simpan Aktivitas",
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
