import 'package:shared_pref_helper/src/base_shared_pref_storage.dart';
import 'package:shared_pref_helper/src/shared_pref_helper_exceptions.dart';

import 'shared_pref_helper.dart';

abstract class AbstractSharedPrefStorage<T> extends BaseSharedPrefStorage<T> {
  void store(T data) {
    if (key.isEmpty) {
      throw SharedPrefHelperExceptions('Key is empty for localStorage');
    }
    String dataString = convertDataToString(data);
    SharedPrefHelper.instance.setString(key, dataString);
  }

  void clear() {
    if (key.isEmpty) {
      throw SharedPrefHelperExceptions('Key is empty for localStorage');
    }
    SharedPrefHelper.instance.remove(key);
  }

  T? fetch() {
    if (key.isEmpty) {
      throw SharedPrefHelperExceptions('Key is empty for localStorage');
    }
    String? dataString = SharedPrefHelper.instance.getString(key);

    if (dataString != null && dataString.isNotEmpty) {
      return convertStringToData(dataString);
    } else {
      return null;
    }
  }
}
