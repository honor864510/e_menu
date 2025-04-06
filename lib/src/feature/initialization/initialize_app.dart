import 'dart:async';
import 'dart:ui';

import 'package:e_menu/src/common/model/dependencies.dart';
import 'package:e_menu/src/common/util/logger.dart';
import 'package:e_menu/src/feature/initialization/initialize_dependencies.dart';
import 'package:flutter/material.dart';

/// Ephemerally initializes the app and prepares it for use.
Future<Dependencies>? _$initializeApp;

/// Initializes the app and prepares it for use.
Future<Dependencies> $initializeApp({
  void Function(int progress, String message)? onProgress,
  FutureOr<void> Function(Dependencies dependencies)? onSuccess,
  void Function(Object error, StackTrace stackTrace)? onError,
}) =>
    _$initializeApp ??= Future<Dependencies>(() async {
      late final WidgetsBinding binding;
      final stopwatch = Stopwatch()..start();
      try {
        binding = WidgetsFlutterBinding.ensureInitialized()..deferFirstFrame();
        /* await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]); */
        await _catchExceptions();
        final dependencies = await $initializeDependencies(onProgress: onProgress).timeout(const Duration(minutes: 7));
        await onSuccess?.call(dependencies);
        return dependencies;
      } on Object catch (error, stackTrace) {
        onError?.call(error, stackTrace);
        logger.error('Failed to initialize app', error, stackTrace);
        rethrow;
      } finally {
        stopwatch.stop();
        binding.addPostFrameCallback((_) {
          // Closes splash screen, and show the app layout.
          binding.allowFirstFrame();
          //final context = binding.renderViewElement;
        });
        _$initializeApp = null;
      }
    });

/// Resets the app's state to its initial state.
@visibleForTesting
Future<void> $resetApp(Dependencies dependencies) async {}

/// Disposes the app and releases all resources.
@visibleForTesting
Future<void> $disposeApp(Dependencies dependencies) async {}

Future<void> _catchExceptions() async {
  try {
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      logger.error('ROOT ERROR\r\n${Error.safeToString(error)}', error, stackTrace);

      return true;
    };

    final sourceFlutterError = FlutterError.onError;
    FlutterError.onError = (final details) {
      logger.error('FLUTTER ERROR\r\n$details', details.exception, details.stack ?? StackTrace.current);
      // FlutterError.presentError(details);
      sourceFlutterError?.call(details);
    };
  } on Object catch (error, stackTrace) {
    logger.error('Failed to initialize the App', error, stackTrace);
  }
}
