import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../providers/theme_provider.dart';
import '../landing_page.dart';
import 'notification_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

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

  void _showEditProfileDialog(bool isEnglish) {
    final userProfile = ref.read(userProfileProvider);
    final nameController = TextEditingController(text: userProfile.name);
    final emailController = TextEditingController(text: userProfile.email);
    String tempAvatar = userProfile.avatar;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              title: Text(
                isEnglish ? "Edit Profile" : "Sunting Profil",
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isEnglish ? "Select Avatar" : "Pilih Avatar",
                      style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textGray),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: ['suit', 'woman', 'robot', 'gamer'].map((avatarOpt) {
                        final isSelected = tempAvatar == avatarOpt;
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              tempAvatar = avatarOpt;
                            });
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              _buildAvatarWidget(avatarOpt, 24, isSelected ? 2.0 : 0.0),
                              if (isSelected)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: AppColors.success,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check, color: Colors.white, size: 10),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      style: GoogleFonts.outfit(fontSize: 14),
                      decoration: InputDecoration(
                        labelText: isEnglish ? "Full Name" : "Nama Lengkap",
                        labelStyle: GoogleFonts.outfit(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      style: GoogleFonts.outfit(fontSize: 14),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: GoogleFonts.outfit(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    isEnglish ? "Cancel" : "Batal",
                    style: GoogleFonts.outfit(color: AppColors.textGray),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(userProfileProvider.notifier).updateName(nameController.text.trim());
                    ref.read(userProfileProvider.notifier).updateEmail(emailController.text.trim());
                    ref.read(userProfileProvider.notifier).updateAvatar(tempAvatar);
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEnglish ? "Profile updated successfully!" : "Profil berhasil diperbarui!",
                          style: GoogleFonts.outfit(),
                        ),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    isEnglish ? "Save" : "Simpan",
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showThemeDialog(bool isEnglish) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            isEnglish ? "Choose Theme" : "Pilih Tema",
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(isEnglish ? "Light Mode" : "Mode Terang", style: GoogleFonts.outfit()),
                leading: const Icon(Icons.wb_sunny_rounded, color: Colors.orange),
                onTap: () {
                  ref.read(themeProvider.notifier).setTheme(false);
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isEnglish ? "Light theme applied" : "Tema Terang diterapkan",
                        style: GoogleFonts.outfit(),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(isEnglish ? "Dark Mode" : "Mode Gelap", style: GoogleFonts.outfit()),
                leading: const Icon(Icons.nightlight_round, color: AppColors.primary),
                onTap: () {
                  ref.read(themeProvider.notifier).setTheme(true);
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isEnglish ? "Dark theme applied" : "Mode Gelap diterapkan",
                        style: GoogleFonts.outfit(),
                      ),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageDialog(bool isEnglish) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            isEnglish ? "Choose Language" : "Pilih Bahasa",
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Bahasa Indonesia", style: GoogleFonts.outfit()),
                trailing: !isEnglish ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  ref.read(languageProvider.notifier).setLanguage(false);
                  Navigator.pop(dialogContext);
                },
              ),
              ListTile(
                title: Text("English", style: GoogleFonts.outfit()),
                trailing: isEnglish ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  ref.read(languageProvider.notifier).setLanguage(true);
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog(bool isEnglish) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            isEnglish ? "About ChatPlan" : "Tentang ChatPlan",
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 60,
                height: 60,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.auto_awesome,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "ChatPlan v1.2.0",
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                isEnglish
                    ? "ChatPlan is an AI-Based Personal Productivity & Lifestyle Optimization System designed to easily manage your daily schedule through natural conversations."
                    : "ChatPlan adalah AI-Based Personal Productivity & Lifestyle Optimization System yang dirancang untuk mengelola aktivitas harian Anda dengan mudah melalui percakapan alami.",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textGray, height: 1.35),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                isEnglish ? "Close" : "Tutup",
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEnglish = ref.watch(languageProvider);
    final userProfile = ref.watch(userProfileProvider);
    final gamification = ref.watch(gamificationProvider);
    
    return Builder(
      builder: (context) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              isEnglish ? "My Profile" : "Profil Saya",
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            elevation: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Profile Card Details
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
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
                    children: [
                      _buildAvatarWidget(userProfile.avatar, 48, 3.0),
                      const SizedBox(height: 16),
                      Text(
                        userProfile.name,
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userProfile.email,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: AppColors.textGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.lavenderBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isEnglish ? "Premium Member" : "Premium Member",
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Gamification Card
                Builder(
                  builder: (context) {
                    final progress = gamification.xp / 1000;
                    return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.25),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isEnglish ? "Productivity Level" : "Level Produktivitas",
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          color: Colors.white.withValues(alpha: 0.8),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "LV ${gamification.level} • Productivity Master",
                                        style: GoogleFonts.outfit(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Icon(
                                    Icons.emoji_events_rounded,
                                    color: Colors.amber,
                                    size: 32,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 8,
                                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${gamification.xp} / 1000 XP",
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    isEnglish
                                        ? "Complete tasks to level up!"
                                        : "Selesaikan aktivitas untuk naik level!",
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                  },
                ),
                const SizedBox(height: 20),

                // Settings options card
                Container(
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
                    children: [
                      _buildProfileTile(
                        icon: Icons.person_rounded,
                        title: isEnglish ? "Edit Profile" : "Edit Profil",
                        onTap: () => _showEditProfileDialog(isEnglish),
                      ),
                      const Divider(color: AppColors.divider, height: 1),
                      _buildProfileTile(
                        icon: Icons.notifications_rounded,
                        title: isEnglish ? "Notifications" : "Notifikasi",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NotificationScreen()),
                          );
                        },
                      ),
                      const Divider(color: AppColors.divider, height: 1),
                      _buildProfileTile(
                        icon: Icons.dark_mode_rounded,
                        title: isEnglish ? "Theme" : "Tema",
                        onTap: () => _showThemeDialog(isEnglish),
                      ),
                      const Divider(color: AppColors.divider, height: 1),
                      _buildProfileTile(
                        icon: Icons.language_rounded,
                        title: isEnglish ? "Language" : "Bahasa",
                        onTap: () => _showLanguageDialog(isEnglish),
                      ),
                      const Divider(color: AppColors.divider, height: 1),
                      _buildProfileTile(
                        icon: Icons.info_rounded,
                        title: isEnglish ? "About Application" : "Tentang Aplikasi",
                        onTap: () => _showAboutDialog(isEnglish),
                      ),
                      const Divider(color: AppColors.divider, height: 1),
                      _buildProfileTile(
                        icon: Icons.logout_rounded,
                        title: isEnglish ? "Sign Out" : "Logout",
                        textColor: AppColors.error,
                        iconBgColor: AppColors.errorBg,
                        iconColor: AppColors.error,
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LandingPage()),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    Color textColor = AppColors.textDark,
    Color iconBgColor = AppColors.lavenderBg,
    Color iconColor = AppColors.primary,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final finalTextColor = textColor == AppColors.textDark 
        ? (isDark ? Colors.white : AppColors.textDark) 
        : textColor;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: finalTextColor,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textLightGray),
      onTap: onTap,
    );
  }
}
