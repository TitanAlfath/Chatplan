import 'package:flutter/material.dart';
  import 'package:google_fonts/google_fonts.dart';
  import '../core/constants/app_colors.dart';

  class CustomTextField extends StatefulWidget {
    final TextEditingController controller;
    final String hintText;
    final String labelText;
    final IconData prefixIcon;
    final bool isPassword;
    final TextInputType keyboardType;
    final String? Function(String?)? validator;
    final ValueChanged<String>? onChanged;
    final String? errorText;

    const CustomTextField({
      super.key,
      required this.controller,
      required this.hintText,
      required this.labelText,
      required this.prefixIcon,
      this.isPassword = false,
      this.keyboardType = TextInputType.text,
      this.validator,
      this.onChanged,
      this.errorText,
    });

    @override
    State<CustomTextField> createState() => _CustomTextFieldState();
  }

  class _CustomTextFieldState extends State<CustomTextField> {
    bool _obscureText = true;

    @override
    Widget build(BuildContext context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              widget.labelText,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFFE8E8FA) : AppColors.textDark,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.isPassword ? _obscureText : false,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              onChanged: widget.onChanged,
              style: GoogleFonts.outfit(
                fontSize: 15,
                color: isDark ? Colors.white : AppColors.textDark,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: GoogleFonts.outfit(
                  fontSize: 14,
                  color: isDark ? const Color(0xFF5E5E7A) : AppColors.textLightGray,
                ),
                prefixIcon: Icon(
                  widget.prefixIcon,
                  color: AppColors.primary,
                  size: 20,
                ),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textLightGray,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: isDark ? const Color(0xFF2D2D44) : const Color(0xFFECEBFA),
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: isDark ? const Color(0xFF2D2D44) : const Color(0xFFECEBFA),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.error,
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.error,
                    width: 2.0,
                  ),
                ),
                errorText: widget.errorText,
                errorStyle: GoogleFonts.outfit(
                  color: AppColors.error,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
  
