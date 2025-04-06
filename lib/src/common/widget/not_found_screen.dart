import 'package:flutter/material.dart';

/// {@template not_found}
/// NotFoundScreen widget.
/// {@endtemplate}
class NotFoundScreen extends StatelessWidget {
  /// {@macro not_found}
  const NotFoundScreen({this.title, this.message, super.key});

  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title ?? 'Not found', maxLines: 1, overflow: TextOverflow.ellipsis),
      bottom: const PreferredSize(preferredSize: Size.fromHeight(48), child: SizedBox(height: 48)),
    ),
    body: SafeArea(child: Center(child: Text(message ?? 'Content not found'))),
  );
}
