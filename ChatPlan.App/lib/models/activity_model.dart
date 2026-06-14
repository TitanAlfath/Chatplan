class Activity {
  final String id;
  final String title;
  final String description;
  final String time;
  final String date;
  final String status; // 'Sedang Berjalan', 'Selesai', 'Tertunda'
  final String priority; // 'Tinggi', 'Sedang', 'Rendah'
  final String category; // 'Pendidikan', 'Kesehatan', 'Pengembangan Diri', 'Pekerjaan', 'Umum'

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.date,
    required this.status,
    this.priority = 'Sedang',
    this.category = 'Umum',
  });

  Activity copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    String? date,
    String? status,
    String? priority,
    String? category,
  }) {
    return Activity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      date: date ?? this.date,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      category: category ?? this.category,
    );
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      time: json['time'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? 'Sedang Berjalan',
      priority: json['priority'] ?? 'Sedang',
      category: json['category'] ?? 'Umum',
    );
  }
}
