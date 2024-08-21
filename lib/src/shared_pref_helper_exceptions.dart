class SharedPrefHelperExceptions implements Exception {
  final String message;
  SharedPrefHelperExceptions(this.message);
  @override
  String toString() {
    return 'SharedPrefHelperExceptions: $message';
  }
}
