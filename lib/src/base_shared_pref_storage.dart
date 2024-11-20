abstract class BaseSharedPrefStorage<T> {
  String get key;

  String convertDataToString(T data);
  T convertStringToData(String data);
}
