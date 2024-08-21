import 'package:shared_preferences/shared_preferences.dart';

import 'shared_pref_helper_exceptions.dart';

class SharedPrefHelper {
  static final _helperInstance = SharedPrefHelper._internal();
  factory SharedPrefHelper() => _helperInstance;
  SharedPrefHelper._internal();

  SharedPreferences? _instance;
  static SharedPreferences get instance {
    if (_helperInstance._instance == null) {
      throw SharedPrefHelperExceptions('SharedPrefHelper not initialized');
    }
    return _helperInstance._instance!;
  }

  Future<void> init() async {
    if (_instance != null) return;
    _instance = await SharedPreferences.getInstance();
  }
}
