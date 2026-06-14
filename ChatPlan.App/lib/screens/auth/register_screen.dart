import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/auth_button.dart';
import '../../services/auth_service.dart';
import '../login_loading_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;

  // Realtime password validation states
  bool _hasMinLength = false;
  bool _hasNumber = false;
  bool _hasUppercase = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword(String value) {
    setState(() {
      _hasMinLength = value.length >= 8;
      _hasNumber = value.contains(RegExp(r'[0-9]'));
      _hasUppercase = value.contains(RegExp(r'[A-Z]'));
    });
  }

  bool get _isPasswordValid => _hasMinLength && _hasNumber && _hasUppercase;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isPasswordValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Password belum memenuhi semua syarat validasi.",
            style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _authService.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted && success) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginLoadingScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registrasi gagal: ${e.toString()}"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF181824),
                    const Color(0xFF13131A),
                    const Color(0xFF0F0F15),
                  ]
                : [
                    const Color(0xFFF4F6FC),
                    const Color(0xFFFFFFFF),
                    AppColors.background,
                  ],
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // --- HEADER ---
                      Hero(
                        tag: 'logo',
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8)),
                      const SizedBox(height: 16),
                      Text(
                        "Create Account",
                        style: GoogleFonts.outfit(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ).animate().fadeIn(duration: 600.ms, delay: 100.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 8),
                      Text(
                        "Start organizing your life with AI",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isDark ? const Color(0xFF9E9EB3) : AppColors.textGray,
                        ),
                      ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 32),

                      // --- FORM ---
                      Column(
                        children: [
                          CustomTextField(
                            controller: _nameController,
                            labelText: "Full Name",
                            hintText: "Enter your full name",
                            prefixIcon: Icons.person_outline_rounded,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Nama tidak boleh kosong";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          CustomTextField(
                            controller: _emailController,
                            labelText: "Email",
                            hintText: "Enter your email address",
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email tidak boleh kosong";
                              }
                              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegex.hasMatch(value)) {
                                return "Format email tidak valid";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          CustomTextField(
                            controller: _passwordController,
                            labelText: "Password",
                            hintText: "Create a password",
                            prefixIcon: Icons.lock_outline_rounded,
                            isPassword: true,
                            onChanged: _validatePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password tidak boleh kosong";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // --- PASSWORD VALIDATION UI (REALTIME) ---
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark ? const Color(0xFF2D2D44) : const Color(0xFFECEBFA),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Syarat Keamanan Password:",
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? const Color(0xFF9E9EB3) : AppColors.textGray,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _buildValidationItem(
                                  isValid: _hasMinLength,
                                  text: "Password minimum 8 karakter",
                                  isDark: isDark,
                                ),
                                const SizedBox(height: 6),
                                _buildValidationItem(
                                  isValid: _hasNumber,
                                  text: "Password mengandung angka",
                                  isDark: isDark,
                                ),
                                const SizedBox(height: 6),
                                _buildValidationItem(
                                  isValid: _hasUppercase,
                                  text: "Password mengandung huruf besar",
                                  isDark: isDark,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          CustomTextField(
                            controller: _confirmPasswordController,
                            labelText: "Confirm Password",
                            hintText: "Retype your password",
                            prefixIcon: Icons.lock_reset_rounded,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Konfirmasi password tidak boleh kosong";
                              }
                              if (value != _passwordController.text) {
                                return "Password tidak cocok";
                              }
                              return null;
                            },
                          ),
                        ],
                      ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 30),

                      // --- CREATE ACCOUNT BUTTON ---
                      AuthButton(
                        text: "Create Account",
                        isLoading: _isLoading,
                        onPressed: _handleRegister,
                      ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 32),

                      // --- FOOTER ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark ? const Color(0xFF9E9EB3) : AppColors.textGray,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            child: Text(
                              "Sign In",
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 600.ms, delay: 450.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValidationItem({
    required bool isValid,
    required String text,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          size: 16,
          color: isValid ? AppColors.success : (isDark ? const Color(0xFF5E5E7A) : AppColors.textLightGray),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: isValid ? FontWeight.bold : FontWeight.w500,
              color: isValid
                  ? AppColors.success
                  : (isDark ? const Color(0xFF9E9EB3) : AppColors.textGray),
            ),
          ),
        ),
      ],
    );
  }
}
