import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../core/constants/app_colors.dart';
import 'dashboard/dashboard_screen.dart';

class LoginLoadingScreen extends StatefulWidget {
  const LoginLoadingScreen({super.key});

  @override
  State<LoginLoadingScreen> createState() => _LoginLoadingScreenState();
}

class _LoginLoadingScreenState extends State<LoginLoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  int _currentStep = 0;
  final List<String> _loadingSteps = [
    "Menghubungkan asisten AI...",
    "Sinkronisasi jadwal harian...",
    "Memuat skor produktivitas...",
    "Mempersiapkan dashboard...",
  ];
  
  Timer? _stepTimer;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Cycle through loading steps
    _stepTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (_currentStep < _loadingSteps.length - 1) {
        setState(() {
          _currentStep++;
        });
      }
    });
    
    // Navigate to dashboard after 2.4 seconds
    _navigationTimer = Timer(const Duration(milliseconds: 2400), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _stepTimer?.cancel();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pulsating brand logo wrapper
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 60,
                      height: 60,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.auto_awesome,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Brand text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Chat ",
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  Text(
                    "Plan",
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "Personal Productivity System",
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: isDark ? const Color(0xFF9E9EB3) : AppColors.textGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 48),
              // Progress indicator
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    minHeight: 6,
                    backgroundColor: AppColors.lavenderBg,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Step text switcher
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _loadingSteps[_currentStep],
                  key: ValueKey<int>(_currentStep),
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: isDark ? const Color(0xFF9E9EB3) : AppColors.textGray,
                    fontWeight: FontWeight.bold,
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
