class BlocstarException implements Exception {
  final dynamic value;

  BlocstarException(this.value);

  @override
  String toString() {
    if (value != null) {
      return value.toString();
    } else {
      return "Blocstar caught an unspecified error.\n\n${super.toString()}";
    }
  }
}
