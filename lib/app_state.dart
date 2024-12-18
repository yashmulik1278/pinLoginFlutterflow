import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _userid = prefs.getString('ff_userid') ?? _userid;
    });
    _safeInit(() {
      _Pin = prefs.getInt('ff_Pin') ?? _Pin;
    });
    _safeInit(() {
      _LoggedIn = prefs.getInt('ff_LoggedIn') ?? _LoggedIn;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _userid = '0';
  String get userid => _userid;
  set userid(String value) {
    _userid = value;
    prefs.setString('ff_userid', value);
  }

  int _Pin = 0;
  int get Pin => _Pin;
  set Pin(int value) {
    _Pin = value;
    prefs.setInt('ff_Pin', value);
  }

  int _LoggedIn = 0;
  int get LoggedIn => _LoggedIn;
  set LoggedIn(int value) {
    _LoggedIn = value;
    prefs.setInt('ff_LoggedIn', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
