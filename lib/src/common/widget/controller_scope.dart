import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ControllerScope<T extends ChangeNotifier> extends InheritedWidget {
  const ControllerScope({required this.controller, required super.child, super.key});

  final T controller;

  static T of<T extends ChangeNotifier>(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ControllerScope<T>>();
    assert(scope != null, 'No ControllerScope<$T> found in context');
    return scope!.controller;
  }

  @override
  bool updateShouldNotify(ControllerScope<T> oldWidget) => controller != oldWidget.controller;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('controller', controller));
  }
}
