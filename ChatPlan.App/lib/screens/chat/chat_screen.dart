import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/chat_bubble_widget.dart';
import '../../providers/activity_provider.dart';
import '../../models/activity_model.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'Halo Titan! Aku adalah asisten AI ChatPlan. Tulis saja rencana aktivitas harianmu di sini, dan aku akan merancangnya secara otomatis.',
    },
  ];

  bool _isTyping = false;
  String _selectedPromptCategory = 'Semua';
  
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;

  final Map<String, List<String>> _promptCategories = {
    'Semua': [
      'Besok jam 8 ada rapat HIMTI',
      'Makan siang jam 12.00',
      'Olahraga sore nanti jam 5',
    ],
    'Pendidikan': [
      'Ada kelas kalkulus besok jam 10 pagi',
      'Kelompok belajar jam 3 sore',
      'Kerjakan tugas pemrograman jam 7 malam',
    ],
    'Kesehatan': [
      'Olahraga pagi lari jam 6',
      'Minum vitamin jam 8 malam',
      'Gym sore jam 5',
    ],
    'Pekerjaan': [
      'Meeting klien jam 9 pagi',
      'Review program jam 2 siang',
      'Evaluasi bulanan jam 4 sore',
    ],
  };

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (val) => print('Speech Error: $val'),
      onStatus: (val) => print('Speech Status: $val'),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _speechToText.stop();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    _inputController.clear();
    setState(() {
      _messages.add({'isUser': true, 'text': text});
      _isTyping = true;
    });
    _scrollToBottom();

    // Call the real API instead of mocking
    final response = await ref.read(activityProvider.notifier).sendMessageToAI(text);
    
    if (!mounted) return;
    setState(() {
      _isTyping = false;

      if (response == null || response['success'] != true) {
        String errorMsg = response != null && response['error'] != null ? response['error'] : 'Maaf, terjadi kesalahan komunikasi dengan AI.';
        _messages.add({'isUser': false, 'text': errorMsg});
      } else {
        String aiResponse = "";
        final intent = response['intent'];
        final data = response['data']?['operation_result'];
        
        if (intent == 'create_activity' && data != null) {
          aiResponse = "Baik, saya telah menjadwalkan '${data['title']}' pada ${data['date']} pukul ${data['time']}.";
        } else if (intent == 'update_activity' && data != null) {
          aiResponse = "Jadwal '${data['title']}' telah berhasil diubah.";
        } else if (intent == 'delete_activity') {
          aiResponse = "Aktivitas berhasil dihapus dari jadwal Anda.";
        } else if (intent == 'complete_activity' && data != null) {
          aiResponse = "Selamat! Aktivitas '${data['title']}' telah diselesaikan.";
        } else if (intent == 'show_activities') {
          aiResponse = "Ini adalah jadwal Anda saat ini. Silakan lihat daftar aktivitas.";
        } else {
          aiResponse = "Maaf, saya tidak memahami perintah tersebut terkait jadwal Anda.";
        }

        _messages.add({'isUser': false, 'text': aiResponse});
      }
      _scrollToBottom();
    });
  }

  void _startListening() async {
    if (!_speechEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fitur mikrofon tidak tersedia atau belum diizinkan.')),
      );
      return;
    }
    await _speechToText.listen(
      onResult: (result) {
        setState(() {
          _inputController.text = result.recognizedWords;
        });
      },
      localeId: 'id_ID', // Indonesian language
    );
    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
    // Send the message after a short delay if there is text
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_inputController.text.isNotEmpty) {
        _sendMessage();
      }
    });
  }

  void _showParsingBottomSheet(String title, String date, String time) {
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
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Aktivitas Ditemukan",
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Card Details
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.lavenderBg, width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 18),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$date • $time",
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: AppColors.textGray,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final id = DateTime.now().millisecondsSinceEpoch.toString();
                    
                    // Smart priority & category lookup
                    String smartCat = 'Umum';
                    String smartPri = 'Sedang';
                    final titleLower = title.toLowerCase();
                    if (titleLower.contains('kuliah') || titleLower.contains('belajar') || titleLower.contains('rapat') || titleLower.contains('kalkulus') || titleLower.contains('tugas')) {
                      smartCat = 'Pendidikan';
                      smartPri = 'Tinggi';
                    } else if (titleLower.contains('makan')) {
                      smartCat = 'Umum';
                      smartPri = 'Rendah';
                    } else if (titleLower.contains('olahraga') || titleLower.contains('gym') || titleLower.contains('lari') || titleLower.contains('vitamin')) {
                      smartCat = 'Kesehatan';
                      smartPri = 'Sedang';
                    } else if (titleLower.contains('kerja') || titleLower.contains('meeting') || titleLower.contains('proyek') || titleLower.contains('klien')) {
                      smartCat = 'Pekerjaan';
                      smartPri = 'Tinggi';
                    }

                    ref.read(activityProvider.notifier).addActivity(
                      Activity(
                        id: id,
                        title: title,
                        description: 'Aktivitas otomatis ditambahkan lewat asisten AI.',
                        time: time,
                        date: date,
                        status: 'Sedang Berjalan',
                        priority: smartPri,
                        category: smartCat,
                      ),
                    );
                    Navigator.pop(context); // Close bottom sheet
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Aktivitas '$title' berhasil disimpan!", style: GoogleFonts.outfit()),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Simpan Aktivitas",
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "AI Chat Assistant",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Chat messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingBubble();
                }
                final message = _messages[index];
                return ChatBubble(
                  isUser: message['isUser'],
                  text: message['text'],
                );
              },
            ),
          ),
          // Kategori Prompt Tab Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: _promptCategories.keys.map((cat) {
                final isSel = _selectedPromptCategory == cat;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPromptCategory = cat;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.primary : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.lavenderBg, width: 1),
                    ),
                    child: Text(
                      cat,
                      style: GoogleFonts.outfit(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: isSel ? Colors.white : AppColors.textGray,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 4),
          // Suggestions row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: (_promptCategories[_selectedPromptCategory] ?? []).map((prompt) {
                return _buildPromptChip(prompt);
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Input row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 15,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Mic button
                  GestureDetector(
                    onTap: _speechToText.isNotListening ? _startListening : _stopListening,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: _isListening ? AppColors.primary.withValues(alpha: 0.2) : AppColors.lavenderBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isListening ? Icons.mic_rounded : Icons.mic_none_rounded, 
                        color: AppColors.primary, 
                        size: 20
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      style: GoogleFonts.outfit(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Ketik aktivitasmu...",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppColors.textLightGray,
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (text) => _sendMessage(),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 80), // Padding space for bottom navigation
        ],
      ),
    );
  }

  Widget _buildTypingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8.0),
              decoration: const BoxDecoration(
                color: AppColors.lavenderBg,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/robot_mascot.png',
                fit: BoxFit.contain,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.textLightGray.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                  ).animate(onPlay: (controller) => controller.repeat())
                    .scaleXY(begin: 0.6, end: 1.2, duration: 400.ms, curve: Curves.easeInOut)
                    .then()
                    .scaleXY(begin: 1.2, end: 0.6, duration: 400.ms, curve: Curves.easeInOut),
                  const SizedBox(width: 4),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.textLightGray.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                  ).animate(onPlay: (controller) => controller.repeat(), delay: 200.ms)
                    .scaleXY(begin: 0.6, end: 1.2, duration: 400.ms, curve: Curves.easeInOut)
                    .then()
                    .scaleXY(begin: 1.2, end: 0.6, duration: 400.ms, curve: Curves.easeInOut),
                  const SizedBox(width: 4),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.textLightGray.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                  ).animate(onPlay: (controller) => controller.repeat(), delay: 400.ms)
                    .scaleXY(begin: 0.6, end: 1.2, duration: 400.ms, curve: Curves.easeInOut)
                    .then()
                    .scaleXY(begin: 1.2, end: 0.6, duration: 400.ms, curve: Curves.easeInOut),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptChip(String prompt) {
    return GestureDetector(
      onTap: () {
        _inputController.text = prompt;
        _sendMessage();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lavenderBg, width: 1),
        ),
        child: Text(
          prompt,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
