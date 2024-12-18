// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  BuildContext? context;
  DateTime? _backgroundTime;
  bool _isInBackground = false;
  static const String _backgroundTimeKey = 'background_time';
  bool _isNavigatingToPinPage = false;
  static const String _currentRouteKey = 'current_route';

  static final AppLifecycleObserver instance = AppLifecycleObserver._internal();
  AppLifecycleObserver._internal();

  Future<void> _saveBackgroundTime() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setString(_backgroundTimeKey, now.toIso8601String());
  }

  Future<bool> _shouldNavigateToPinPage() async {
    if (_isNavigatingToPinPage) return false;
    final prefs = await SharedPreferences.getInstance();
    final currentRoute = prefs.getString(_currentRouteKey);
    return currentRoute != 'PinPage';
  }

  Future<void> _setCurrentRoute(String route) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentRouteKey, route);
  }

  Future<void> _checkStoredBackgroundTime() async {
    if (_isNavigatingToPinPage) return;

    final prefs = await SharedPreferences.getInstance();
    final storedTime = prefs.getString(_backgroundTimeKey);
    if (storedTime != null) {
      final storedBackgroundTime = DateTime.parse(storedTime);
      final timeInBackground = DateTime.now().difference(storedBackgroundTime);

      if (timeInBackground > const Duration(seconds: 2)) {
        if (context != null && await _shouldNavigateToPinPage()) {
          try {
            _isNavigatingToPinPage = true;
            await _setCurrentRoute('PinPage');
            context!.pushNamed(
              'PinPage',
              extra: <String, dynamic>{
                'forceRefresh': true,
                'showBiometric': true,
              },
            );
          } catch (e) {
            _isNavigatingToPinPage = false;
          }
        }
      }
      await prefs.remove(_backgroundTimeKey);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_isInBackground && _backgroundTime != null) {
          final timeInBackground = DateTime.now().difference(_backgroundTime!);

          if (timeInBackground > const Duration(seconds: 2)) {
            if (context != null && await _shouldNavigateToPinPage()) {
              try {
                _isNavigatingToPinPage = true;
                await _setCurrentRoute('PinPage');
                if (context != null && context!.mounted) {
                  context!.pushNamed(
                    'PinPage',
                    extra: <String, dynamic>{
                      'forceRefresh': true,
                      'showBiometric': true,
                    },
                  );
                }
              } catch (e) {
                _isNavigatingToPinPage = false;
              }
            }
          }
        }
        _isInBackground = false;
        _backgroundTime = null;
        break;

      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        if (!_isInBackground) {
          _backgroundTime = DateTime.now();
          _isInBackground = true;
          await _saveBackgroundTime();
        }
        break;
    }
  }

  Future<void> resetNavigationState() async {
    _isNavigatingToPinPage = false;
    _backgroundTime = null;
    _isInBackground = false;
    await _setCurrentRoute('HomePage');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_backgroundTimeKey);
  }
}

Future<void> onAppBackground(BuildContext context) async {
  try {
    WidgetsBinding.instance.removeObserver(AppLifecycleObserver.instance);
  } catch (e) {
    // Ignore error
  }

  AppLifecycleObserver.instance.context = context;
  WidgetsBinding.instance.addObserver(AppLifecycleObserver.instance);

  await AppLifecycleObserver.instance._checkStoredBackgroundTime();
  await AppLifecycleObserver.instance.resetNavigationState();
}
