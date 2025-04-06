import 'package:flutter/widgets.dart';

class ScopeNester extends StatelessWidget {
  const ScopeNester({required this.scopes, required this.child, super.key});

  final List<InheritedWidget Function(Widget)> scopes;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      scopes.fold<Widget>(child, (previous, InheritedWidget Function(Widget) inherited) => inherited(previous));
}
