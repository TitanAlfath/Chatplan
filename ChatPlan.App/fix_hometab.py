import re

with open('lib/screens/dashboard/home_tab.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Fix 1: _activityService.toggleComplete
content = content.replace("_activityService.toggleComplete", "ref.read(activityProvider.notifier).toggleComplete")
content = content.replace("_activityService.deleteActivity", "ref.read(activityProvider.notifier).deleteActivity")
content = content.replace("_activityService.addActivity", "ref.read(activityProvider.notifier).addActivity")

# Fix 2: PomodoroTimerCardState.build signature
content = content.replace("class _PomodoroTimerCardState extends ConsumerState<PomodoroTimerCard> {", "class _PomodoroTimerCardState extends ConsumerState<PomodoroTimerCard> {")
# It's currently `Widget build(BuildContext context, WidgetRef ref) {` in PomodoroTimerCardState due to refactor_hometab2.py.
# Wait, refactor_hometab2.py did:
# content = content.replace("Widget build(BuildContext context) {", "Widget build(BuildContext context, WidgetRef ref) {\n    final isEnglish = ref.watch(languageProvider);\n    final gamification = ref.watch(gamificationProvider);")
# This replaced ALL "Widget build(BuildContext context) {" in the file! That means for MoodTrackerWidget AND PomodoroTimerCard.
# MoodTrackerWidget is ConsumerWidget, so it needs WidgetRef ref. That is correct.
# PomodoroTimerCard is ConsumerStatefulWidget, so its state class needs `Widget build(BuildContext context) {` and `ref` is a property.
# We will fix just the PomodoroTimerCard one.
content = re.sub(
    r"Widget build\(BuildContext context, WidgetRef ref\) \{\n\s*final isEnglish = ref\.watch\(languageProvider\);\n\s*final gamification = ref\.watch\(gamificationProvider\);\n\s*final formatTime",
    r"Widget build(BuildContext context) {\n    final isEnglish = ref.watch(languageProvider);\n    final gamification = ref.watch(gamificationProvider);\n    final formatTime",
    content
)

# Unused variable mood
content = content.replace("final mood = gamification.mood;", "")

with open('lib/screens/dashboard/home_tab.dart', 'w', encoding='utf-8') as f:
    f.write(content)
