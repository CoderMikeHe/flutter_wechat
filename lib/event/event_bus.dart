import 'package:event_bus/event_bus.dart';

/// The global [EventBus] object.
EventBus eventBus = EventBus();

/// 切换根View的事件.
class SwitchRootViewEvent {
  String text;

  SwitchRootViewEvent(this.text);
}

/// Event B.
class MyEventB {
  String text;

  MyEventB(this.text);
}
