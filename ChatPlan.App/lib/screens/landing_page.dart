import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  late AnimationController _robotAnimController;
  late Animation<double> _robotFloatingAnimation;

  @override
  void initState() {
    super.initState();
    _robotAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _robotFloatingAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _robotAnimController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _robotAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF4F6FC), 
              Color(0xFFFFFFFF), 
              AppColors.background, 
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- TOP BAR: Language Selector ---
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFFE8E8FA),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.language_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Bahasa",
                            style: GoogleFonts.outfit(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- LOGO & BRANDING ---
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Chat ",
                        style: GoogleFonts.outfit(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        "Plan",
                        style: GoogleFonts.outfit(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Atur harimu, capai tujuanmu.\nHanya dengan percakapan.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textGray,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- SIMULATED CHAT BUBBLES ---
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(right: screenSize.width * 0.15),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: const Color(0xFFECEBFA),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          "Besok jam 8 pagi saya ada matakuliah algoritma dan jam 7 malam saya ada pekerjaan malam hari",
                          style: GoogleFonts.outfit(
                            fontSize: 13.5,
                            color: const Color(0xFF53526E),
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.15),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Text(
                          "Baik! ,Aku sudah menambahkan 2 Aktifitas untukmu",
                          style: GoogleFonts.outfit(
                            fontSize: 13.5,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- SCHEDULE & MASCOT AREA (STACK) ---
                  SizedBox(
                    height: 210,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // White Activities Card (Right Side)
                        Positioned(
                          right: 0,
                          top: 10,
                          child: Container(
                            width: screenSize.width * 0.72,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.02),
                                  blurRadius: 30,
                                  offset: const Offset(0, 20),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildActivityItem(
                                  iconData: Icons.person_rounded,
                                  iconBgColor: AppColors.lavenderBg,
                                  iconColor: AppColors.primary,
                                  title: "Bekerja jam 7 malam",
                                  dateTime: "19 Mei 2026 • 19.00 WIB",
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Divider(
                                    color: AppColors.divider,
                                    thickness: 1.5,
                                  ),
                                ),
                                _buildActivityItem(
                                  iconData: Icons.book_rounded,
                                  iconBgColor: AppColors.errorBg,
                                  iconColor: AppColors.error,
                                  title: "Matakuliah",
                                  dateTime: "19 Mei 2026 • 08.00 WIB",
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Animated Robot Mascot (Left Side)
                        Positioned(
                          left: -15,
                          top: 0,
                          bottom: 0,
                          child: AnimatedBuilder(
                            animation: _robotFloatingAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _robotFloatingAnimation.value),
                                child: child,
                              );
                            },
                            child: Container(
                              width: 140,
                              height: 200,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/robot_mascot.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- FEATURE HIGHLIGHTS CARD ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFeatureColumn(
                          icon: Icons.chat_bubble_rounded,
                          text: "Buat rencana\nlewat Chat",
                        ),
                        _buildVerticalDivider(),
                        _buildFeatureColumn(
                          icon: Icons.calendar_today_rounded,
                          text: "Jadwal otomatis\ntanpa bentrok",
                        ),
                        _buildVerticalDivider(),
                        _buildFeatureColumn(
                          icon: Icons.bar_chart_rounded,
                          text: "Insight untuk\nproduktivitasmu",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // --- ACTION BUTTONS ---
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Mulai Sekarang",
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: Text(
                        "Masuk",
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData iconData,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String dateTime,
  }) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            iconData,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dateTime,
                style: GoogleFonts.outfit(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLightGray,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.lavenderBg,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            "Terjadwal",
            style: GoogleFonts.outfit(
              fontSize: 7.5,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8A7BF7),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureColumn({required IconData icon, required String text}) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3FF),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFE6E5FC),
                width: 1.0,
              ),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5E5E7A),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 36,
      width: 1.2,
      color: const Color(0xFFECECFA),
      margin: const EdgeInsets.only(top: 8.0),
    );
  }
}
