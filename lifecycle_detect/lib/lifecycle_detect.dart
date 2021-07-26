
import 'package:flutter/services.dart';

class LifecycleDetect {

  LifecycleDetect._();

  factory LifecycleDetect.getInstance() => _instance;

  static final LifecycleDetect _instance = LifecycleDetect._();

  static const MethodChannel _channel = MethodChannel('lifecycle_detect');

  List<LifecycleObserver> observers = [];

  void init() {
    _channel.setMethodCallHandler(flutterMethod);
  }

  Future<dynamic> flutterMethod(MethodCall call) async{
    if (call.method == 'onActivityResumed') {
      onActivityResumed(call.arguments['activityName']);
    } else if (call.method == 'onActivityPaused') {
      onActivityPaused(call.arguments['activityName']);
    }
  }

  void onActivityResumed(String activityName) {
    print('onActivityResumed:::$activityName');
  }

  void onActivityPaused(String activityName) {
    print('onActivityPaused:::$activityName');
  }

  void onResume(String pageName, bool isFromNative) {
    for (LifecycleObserver observer in observers) {
      observer.onResume(pageName, isFromNative);
    }
  }

  void onPause(String pageName, bool isFromNative) {
    for (LifecycleObserver observer in observers) {
      observer.onPause(pageName, isFromNative);
    }
  }

  void addLifecycleObserver(LifecycleObserver lifecycleObserver) {
    observers.add(lifecycleObserver);
  }

  void removeLifecycleObserver(LifecycleObserver lifecycleObserver) {
    observers.remove(lifecycleObserver);
  }
}

typedef OnResume = void Function(String pageName, bool isFromNative);
typedef OnPause = void Function(String pageName, bool isFromNative);

class LifecycleObserver {
  OnResume onResume;
  OnPause onPause;

  LifecycleObserver({this.onResume, this.onPause});
}
