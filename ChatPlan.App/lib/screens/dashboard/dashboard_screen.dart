import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import 'home_tab.dart';
import '../activity/activity_screen.dart';
import '../chat/chat_screen.dart';
import '../insight/insight_screen.dart';
import '../profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Let's create a list of screens that correspond to our tabs
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeTab(onTabChange: (index) {
        setState(() {
          _selectedIndex = index;
        });
      }),
      const ActivityScreen(),
      const ChatScreen(),
      const InsightScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      extendBody: true,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Theme.of(context).cardColor,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textLightGray,
          selectedLabelStyle: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w600),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted_rounded), label: 'Aktivitas'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Insight'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
