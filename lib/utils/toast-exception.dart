class ToastException implements Exception {
  String message;

  ToastException(this.message);
  @override
  String toString() {
    return message;
  }
}
