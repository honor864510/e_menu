import 'package:e_menu/src/common/util/scope_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ControllerScope<T extends ChangeNotifier> extends InheritedWidget with ScopeMixin {
  const ControllerScope({required this.controller, required super.child, super.key});

  final T controller;

  @override
  bool updateShouldNotify(ControllerScope<T> oldWidget) => controller != oldWidget.controller;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('controller', controller));
  }
}
