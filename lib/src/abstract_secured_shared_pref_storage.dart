import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_pref_helper/shared_pref_helper.dart';
import 'package:shared_pref_helper/src/base_shared_pref_storage.dart';

abstract class AbstractSecuredSharedPrefStorage<T>
    extends BaseSharedPrefStorage<T> {
  Future<void> store(T data) async {
    if (key.isEmpty) {
      throw SharedPrefHelperExceptions('Key is empty for localStorage');
    }
    const storage = FlutterSecureStorage();
    String dataString = convertDataToString(data);
    await storage.write(key: key, value: dataString);
  }

  Future<void> clear() async {
    if (key.isEmpty) {
      throw SharedPrefHelperExceptions('Key is empty for localStorage');
    }
    const storage = FlutterSecureStorage();
    await storage.delete(key: key);
  }

  Future<T?> fetch() async {
    if (key.isEmpty) {
      throw SharedPrefHelperExceptions('Key is empty for localStorage');
    }
    const storage = FlutterSecureStorage();
    String? dataString = await storage.read(key: key);

    if (dataString != null && dataString.isNotEmpty) {
      return convertStringToData(dataString);
    } else {
      return null;
    }
  }
}
