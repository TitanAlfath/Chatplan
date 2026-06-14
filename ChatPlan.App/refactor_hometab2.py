import re

with open('lib/screens/dashboard/home_tab.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Remove bottom brackets
content = re.sub(
    r"\s*\}\s*,\s*\)\s*;\s*\}\s*,\s*\)\s*;\s*\}\s*void _showAddOptions",
    r"\n              },\n            ),\n          ),\n          floatingActionButton: FloatingActionButton(\n            onPressed: () => _showAddOptions(context, isEnglish),\n            backgroundColor: AppColors.primary,\n            shape: const CircleBorder(),\n            child: const Icon(Icons.add, color: Colors.white, size: 28),\n          ),\n        );\n  }\n\n  void _showAddOptions",
    content
)

# For MoodTrackerWidget
content = content.replace("class MoodTrackerWidget extends StatelessWidget", "class MoodTrackerWidget extends ConsumerWidget")
content = re.sub(r"final ActivityService _activityService = ActivityService\(\);\s*", "", content)
content = content.replace("Widget build(BuildContext context) {", "Widget build(BuildContext context, WidgetRef ref) {\n    final isEnglish = ref.watch(languageProvider);\n    final gamification = ref.watch(gamificationProvider);")
content = re.sub(r"return ValueListenableBuilder<String>\([\s\S]*?builder: \(context, mood, child\) \{\s*return (Container\([\s\S]*?\));\s*\},?\s*\);", r"return \1;", content)
content = content.replace("mood ==", "gamification.mood ==")
content = content.replace("e['name'] == mood", "e['name'] == gamification.mood")

# For PomodoroTimerCard
content = content.replace("class PomodoroTimerCard extends StatefulWidget {", "class PomodoroTimerCard extends ConsumerStatefulWidget {")
content = content.replace("State<PomodoroTimerCard> createState() => _PomodoroTimerCardState();", "ConsumerState<PomodoroTimerCard> createState() => _PomodoroTimerCardState();")
content = content.replace("class _PomodoroTimerCardState extends State<PomodoroTimerCard> {", "class _PomodoroTimerCardState extends ConsumerState<PomodoroTimerCard> {")
content = re.sub(r"final ActivityService _activityService = ActivityService\(\);\s*", "", content)
content = content.replace("_activityService.addXp(100);", "ref.read(gamificationProvider.notifier).addXp(100);")

with open('lib/screens/dashboard/home_tab.dart', 'w', encoding='utf-8') as f:
    f.write(content)
