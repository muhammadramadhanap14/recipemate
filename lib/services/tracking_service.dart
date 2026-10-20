import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:intl/intl.dart';
import '../models/model/user_tracking.dart';
import '../repository/tracking_repository.dart';
import '../utils/constant_var.dart';
import '../utils/location_util.dart';

abstract class TrackingEngine {
  Future<void> start({
    required String nik,
    required int idTracking,
    required double startLat,
    required double startLng,
  });
  Future<void> stop();
  Future<bool> isRunning();
}

class FlutterForegroundTaskEngine implements TrackingEngine {
  @override
  Future<void> start({
    required String nik,
    required int idTracking,
    required double startLat,
    required double startLng,
  }) async {
    await FlutterForegroundTask.saveData(key: 'nik', value: nik);
    await FlutterForegroundTask.saveData(key: 'idTracking', value: idTracking);

    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.restartService();
      return;
    }

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'recipemate_tracking_channel',
        channelName: 'Location Tracking',
        channelDescription: 'Foreground service for continuous location tracking',
        channelImportance: NotificationChannelImportance.DEFAULT,
        priority: NotificationPriority.DEFAULT,
        showWhen: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(10000),
        autoRunOnBoot: false,
        allowWakeLock: true,
      ),
    );

    await FlutterForegroundTask.startService(
      serviceTypes: [ForegroundServiceTypes.location],
      notificationTitle: 'Location Tracking',
      notificationText: 'Aplikasi Pelacakan dimulai',
      callback: startCallback,
    );
  }

  @override
  Future<void> stop() async {
    await FlutterForegroundTask.stopService();
  }

  @override
  Future<bool> isRunning() async {
    return await FlutterForegroundTask.isRunningService;
  }
}

class TrackingEngineFactory {
  static TrackingEngine create() {
    return FlutterForegroundTaskEngine();
  }
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(LocationTrackTaskHandler());
}

@pragma('vm:entry-point')
class LocationTrackTaskHandler extends TaskHandler {
  StreamSubscription<dynamic>? _positionSubscription;
  final TrackingRepository _repository = TrackingRepository();
  int? _idTracking;
  String? _nik;
  DateTime? _lastLoggedTime;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    debugPrint("[LocationTrackTaskHandler] onStart called");
    _nik = await FlutterForegroundTask.getData(key: 'nik') as String?;
    final idTrcDynamic = await FlutterForegroundTask.getData(key: 'idTracking');
    if (idTrcDynamic is int) {
      _idTracking = idTrcDynamic;
    } else if (idTrcDynamic is String) {
      _idTracking = int.tryParse(idTrcDynamic);
    }

    debugPrint("[LocationTrackTaskHandler] Loaded NIK: $_nik, idTracking: $_idTracking");

    _positionSubscription = LocationUtil.getPositionStream().listen(
      (position) async {
        if (_idTracking == null) return;
        final now = DateTime.now();
        if (_lastLoggedTime != null) {
          final diff = now.difference(_lastLoggedTime!).inSeconds;
          if (diff < 10) {
            return; // Throttle to 10 seconds
          }
        }
        _lastLoggedTime = now;

        final lat = position.latitude;
        final lng = position.longitude;

        if (lat == 0.0 && lng == 0.0) return;

        final dateStr = DateFormat(ConstantVar.stYearDateTimeLineFormat).format(now);
        final detail = DetailTracking(
          positionLat: lat,
          positionLng: lng,
          trackingDate: dateStr,
        );

        try {
          await _repository.insertDetailTracking(_idTracking!, detail);
          debugPrint("[LocationTrackTaskHandler] Logged position: $lat, $lng at $dateStr");
        } catch (e) {
          debugPrint("[LocationTrackTaskHandler] Error logging position: $e");
        }
      },
      onError: (error) {
        debugPrint("[LocationTrackTaskHandler] Position stream error: $error");
      },
    );
  }

  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    debugPrint("[LocationTrackTaskHandler] onEvent tick at $timestamp");
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    debugPrint("[LocationTrackTaskHandler] onRepeatEvent at $timestamp");
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isServiceKilled) async {
    debugPrint("[LocationTrackTaskHandler] onDestroy called, isServiceKilled: $isServiceKilled");
    await _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp("/");
  }
}
