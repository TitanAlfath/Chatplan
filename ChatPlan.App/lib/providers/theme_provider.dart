import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends Notifier<bool> {
  @override
  bool build() => false; // Default is light mode

  void toggleTheme() {
    state = !state;
  }

  void setTheme(bool isDark) {
    state = isDark;
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, bool>(() {
  return ThemeNotifier();
});

class LanguageNotifier extends Notifier<bool> {
  @override
  bool build() => false; // Default is Indonesian

  void toggleLanguage() {
    state = !state;
  }

  void setLanguage(bool isEnglish) {
    state = isEnglish;
  }
}

final languageProvider = NotifierProvider<LanguageNotifier, bool>(() {
  return LanguageNotifier();
});
