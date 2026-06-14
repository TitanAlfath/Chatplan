import re

with open('lib/screens/dashboard/home_tab.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. build signature
content = content.replace("Widget build(BuildContext context) {", "Widget build(BuildContext context, WidgetRef ref) {\\n    final isEnglish = ref.watch(languageProvider);\\n    final activitiesAsync = ref.watch(activityProvider);\\n    final activities = activitiesAsync.value ?? [];\\n    final gamification = ref.watch(gamificationProvider);\\n    final userProfile = ref.watch(userProfileProvider);")

# 2. Top-level ValueListenableBuilders
content = re.sub(
    r"return ValueListenableBuilder<bool>\([\s\S]*?builder: \(context, isEnglish, child\) \{\s*return (Scaffold\()",
    r"return \1",
    content
)
content = re.sub(
    r"child: ValueListenableBuilder<List<Activity>>\([\s\S]*?builder: \(context, activities, child\) \{\s*(// Stats Calculations)",
    r"child: Builder(builder: (context) {\n              \1",
    content
)

# 3. levelNotifier
content = re.sub(
    r"ValueListenableBuilder<int>\([\s\S]*?valueListenable: _activityService\.levelNotifier,\s*builder: \(context, level, child\) \{\s*return (Container\([\s\S]*?\"LV \$level\"[\s\S]*?\));\s*\},?\s*\)",
    r"\1",
    content
)
# Fix the "level" usage inside that block
content = content.replace('"LV $level"', '"LV ${gamification.level}"')

# 4. userAvatarNotifier
content = re.sub(
    r"ValueListenableBuilder<String>\([\s\S]*?valueListenable: _activityService\.userAvatarNotifier,\s*builder: \(context, avatarName, child\) \{\s*return (_buildAvatarWidget\(avatarName, 24, 2\.0\));\s*\},?\s*\)",
    r"_buildAvatarWidget(userProfile.avatar, 24, 2.0)",
    content
)

# 5. moodNotifier & userNameNotifier
# This one is tricky because it has variables and nested builders
mood_builder_regex = r"ValueListenableBuilder<String>\(\s*valueListenable: _activityService\.moodNotifier,\s*builder: \(context, mood, child\) \{\s*(String greetingExtra =[\s\S]*?ValueListenableBuilder<String>\([\s\S]*?builder: \(context, name, child\) \{\s*return (Column\([\s\S]*?\));\s*\},\s*\);\s*\}\s*,\s*\)"
def repl_mood(match):
    code = match.group(1)
    # replace name and mood inside the code
    code = code.replace("mood ==", "gamification.mood ==")
    code = code.replace("name", "userProfile.name")
    # extract the return Column
    col = match.group(2)
    col = col.replace("name", "userProfile.name")
    
    # recreate the block
    return "Builder(builder: (context) {\\n" + code.split("return ValueListenableBuilder")[0] + "return " + col + ";\\n})"

content = re.sub(mood_builder_regex, repl_mood, content)

# 6. Remove the trailing brackets from the top-level ValueListenableBuilders
# We had `return Scaffold(...)` and `child: Builder(...)`. 
# We need to fix the brackets at the very end of the file.
# The original file had `      },\n    );\n  }\n\n  void _showAddOptions`
content = re.sub(r"\}\s*,\s*\)\s*;\s*\}\s*,\s*\)\s*;\s*\}\s*void _showAddOptions", r"  }\n  void _showAddOptions", content)

# Write back
with open('lib/screens/dashboard/home_tab.dart', 'w', encoding='utf-8') as f:
    f.write(content)
