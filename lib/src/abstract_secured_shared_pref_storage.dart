import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_pref_helper/shared_pref_helper.dart';

abstract class AbstractSecuredSharedPrefStorage<T>
    extends BaseSharedPrefStorage<T> {
  AndroidOptions get androidOptions => const AndroidOptions(
        resetOnError: true,
      );

  FlutterSecureStorage get storage =>
      FlutterSecureStorage(aOptions: androidOptions);

  Future<void> store(T data) async {
    if (key.isEmpty) {
      throw SharedPrefHelperExceptions('Key is empty for localStorage');
    }
    String dataString = convertDataToString(data);
    await storage.write(key: key, value: dataString);
  }

  Future<void> clear() async {
    if (key.isEmpty) {
      throw SharedPrefHelperExceptions('Key is empty for localStorage');
    }
    try {
      await storage.delete(key: key);
    } catch (e) {
      print('AbstractSecuredSharedPrefStorage failed to delete key: $key');
    }
  }

  Future<T?> fetch() async {
    if (key.isEmpty) {
      throw SharedPrefHelperExceptions('Key is empty for localStorage');
    }
    String? dataString = await storage.read(key: key);

    if (dataString != null && dataString.isNotEmpty) {
      return convertStringToData(dataString);
    } else {
      return null;
    }
  }
}
