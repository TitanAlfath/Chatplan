import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../core/constants/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final bool isUser;
  final String text;

  const ChatBubble({
    super.key,
    required this.isUser,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isUser) ...[
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
            ],
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isUser ? AppColors.primary : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isUser ? 20 : 0),
                    bottomRight: Radius.circular(isUser ? 0 : 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isUser ? 0.08 : 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: isUser 
                  ? Text(
                      text,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppColors.white,
                        height: 1.35,
                      ),
                    )
                  : MarkdownBody(
                      data: text,
                      styleSheet: MarkdownStyleSheet(
                        p: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark,
                          height: 1.35,
                        ),
                        strong: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark,
                        ),
                        listBullet: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark,
                        ),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
