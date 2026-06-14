import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/google_button.dart';
import '../../services/auth_service.dart';
import '../login_loading_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void initState() {
    super.initState();
    // Default demo credentials
    _emailController.text = "demo@chatplan.com";
    _passwordController.text = "password123";
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _authService.login(
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
            content: Text("Login gagal: ${e.toString()}"),
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

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      final success = await _authService.signInWithGoogle();

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
            content: Text("Google Sign-In gagal: ${e.toString()}"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
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
                        "Welcome Back",
                        style: GoogleFonts.outfit(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ).animate().fadeIn(duration: 600.ms, delay: 100.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 8),
                      Text(
                        "Continue your productivity journey with AI",
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
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: _passwordController,
                            labelText: "Password",
                            hintText: "Enter your password",
                            prefixIcon: Icons.lock_outline_rounded,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password tidak boleh kosong";
                              }
                              return null;
                            },
                          ),
                        ],
                      ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 14),

                      // --- FORGOT PASSWORD ---
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Fitur reset password disimulasikan.",
                                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                                ),
                                backgroundColor: AppColors.primary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "Forgot Password?",
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ).animate().fadeIn(duration: 600.ms, delay: 350.ms),
                      const SizedBox(height: 24),

                      // --- LOGIN BUTTON ---
                      AuthButton(
                        text: "Login",
                        isLoading: _isLoading,
                        onPressed: _isGoogleLoading ? null : _handleLogin,
                      ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 24),

                      // --- DIVIDER ---
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: isDark ? const Color(0xFF2D2D44) : const Color(0xFFE8E8FA),
                              thickness: 1.5,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "OR",
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? const Color(0xFF5E5E7A) : AppColors.textLightGray,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: isDark ? const Color(0xFF2D2D44) : const Color(0xFFE8E8FA),
                              thickness: 1.5,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 600.ms, delay: 450.ms),
                      const SizedBox(height: 24),

                      // --- GOOGLE BUTTON ---
                      GoogleButton(
                        onPressed: _isLoading ? () {} : _handleGoogleSignIn,
                        isLoading: _isGoogleLoading,
                      ).animate().fadeIn(duration: 600.ms, delay: 500.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 32),

                      // --- FOOTER ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
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
                                MaterialPageRoute(builder: (context) => const RegisterScreen()),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 600.ms, delay: 550.ms),
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
}
