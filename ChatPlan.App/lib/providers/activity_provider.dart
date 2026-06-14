import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity_model.dart';
import '../services/api_service.dart';
import 'user_provider.dart';

class ActivityNotifier extends AsyncNotifier<List<Activity>> {
  @override
  Future<List<Activity>> build() async {
    return await _fetchActivities();
  }

  Future<List<Activity>> _fetchActivities() async {
    try {
      final data = await apiService.getActivities();
      return data.map((e) => Activity.fromJson(e)).toList();
    } catch (e) {
      print("Error loading activities: $e");
      return [];
    }
  }

  Future<void> reloadActivities() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchActivities());
  }

  Future<Map<String, dynamic>?> sendMessageToAI(String message) async {
    try {
      final res = await apiService.sendChatMessage(message);
      if (res['success'] == true) {
        // Refresh activities from API after modification
        await reloadActivities();
      }
      return res;
    } catch (e) {
      print("Error sending message: $e");
      return null;
    }
  }

  void addActivity(Activity activity) {
    if (state.hasValue) {
      state = AsyncValue.data([...state.value!, activity]);
    }
  }

  void updateActivity(Activity updatedActivity) {
    if (state.hasValue) {
      state = AsyncValue.data(
        state.value!.map((activity) => activity.id == updatedActivity.id ? updatedActivity : activity).toList(),
      );
    }
  }

  void deleteActivity(String id) {
    if (state.hasValue) {
      state = AsyncValue.data(state.value!.where((activity) => activity.id != id).toList());
    }
  }

  void toggleComplete(String id) {
    if (state.hasValue) {
      state = AsyncValue.data(
        state.value!.map((activity) {
          if (activity.id == id) {
            final newStatus = activity.status == 'Selesai' ? 'Tertunda' : 'Selesai';
            
            if (newStatus == 'Selesai') {
              ref.read(gamificationProvider.notifier).addXp(50);
            } else {
              ref.read(gamificationProvider.notifier).removeXp(50);
            }
            
            return activity.copyWith(status: newStatus);
          }
          return activity;
        }).toList(),
      );
    }
  }
}

final activityProvider = AsyncNotifierProvider<ActivityNotifier, List<Activity>>(() {
  return ActivityNotifier();
});
