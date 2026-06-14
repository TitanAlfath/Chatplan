import re

with open('lib/screens/dashboard/home_tab.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Fix 1: Add WidgetRef ref to _buildQuickAddChip and _buildTimelineItem
content = content.replace("Widget _buildQuickAddChip({", "Widget _buildQuickAddChip(WidgetRef ref, {")
content = content.replace("_buildQuickAddChip(", "_buildQuickAddChip(ref, ")
# Wait, maybe _buildTimelineItem also needs ref?
content = content.replace("Widget _buildTimelineItem(", "Widget _buildTimelineItem(WidgetRef ref, ")
content = content.replace("_buildTimelineItem(a, ", "_buildTimelineItem(ref, a, ")

# Fix 2: MoodTrackerWidget ValueListenableBuilder 
# We missed removing the ValueListenableBuilder inside MoodTrackerWidget.
mood_tracker_target = r"return ValueListenableBuilder<String>\(\s*valueListenable: _activityService\.moodNotifier,\s*builder: \(context, mood, child\) \{\s*return (Container\([\s\S]*?\}),\s*\);"
# The closing for ValueListenableBuilder in MoodTrackerWidget is `    );\n  }`
content = re.sub(
    r"return ValueListenableBuilder<String>\([\s\S]*?valueListenable: _activityService\.moodNotifier,[\s\S]*?builder: \(context, mood, child\) \{\s*return (Container\([\s\S]*?\));\s*\},?\s*\);",
    r"return \1;",
    content
)

# Fix 3: _activityService.moodNotifier.value = ...
content = content.replace("_activityService.moodNotifier.value = isEnglish ? m['nameEn']! : m['name']!;", "ref.read(gamificationProvider.notifier).updateMood(isEnglish ? m['nameEn']! : m['name']!);")

# Fix 4: PomodoroTimerCardState build method
content = re.sub(
    r"Widget build\(BuildContext context, WidgetRef ref\) \{\n\s*final isEnglish = ref\.watch\(languageProvider\);\n\s*final gamification = ref\.watch\(gamificationProvider\);\n",
    r"Widget build(BuildContext context) {\n    final isEnglish = ref.watch(languageProvider);\n    final gamification = ref.watch(gamificationProvider);\n",
    content
)

with open('lib/screens/dashboard/home_tab.dart', 'w', encoding='utf-8') as f:
    f.write(content)
