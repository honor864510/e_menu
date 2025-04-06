import 'package:e_menu/src/common/widget/app.dart';
import 'package:e_menu/src/common/widget/app_error.dart';
import 'package:e_menu/src/feature/initialization/initialize_app.dart';
import 'package:flutter/widgets.dart';

void main([List<String>? args]) => $initializeApp(
  onSuccess: (dependencies) => runApp(dependencies.inject(child: const App())),
  onError: (error, stackTrace) => runApp(AppError(error: error)),
);
