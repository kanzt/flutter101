import 'package:flutter_mqtt_plugin_example/src/util/notification/notification_service.dart';
import 'package:get/get.dart';

class ApplicationLifecycleController extends FullLifeCycleController with FullLifeCycleMixin {
  // Mandatory
  @override
  void onDetached() {
    print('ApplicationLifecycleController - onDetached called');
  }

  // Mandatory
  @override
  void onInactive() {
    print('ApplicationLifecycleController - onInative called');
  }

  // Mandatory
  @override
  void onPaused() {
    print('ApplicationLifecycleController - onPaused called');
  }

  // Mandatory
  @override
  void onResumed() {
    print('ApplicationLifecycleController - onResumed called');
    NotificationService.checkPendingNotification();
  }
}