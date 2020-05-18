import 'package:blocstar/DataManagement/Mergeable.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("New value is picked over old", () {
    final newValue = 7;
    final oldValue = 5;
    final finalValue = resolveValue(oldValue, newValue);
    expect(finalValue, newValue);
  });

  test("Old Value is maintained, if New Value is null", () {
    final newValue = null;
    final oldValue = 5;
    final finalValue = resolveValue(oldValue, newValue);
    expect(finalValue, oldValue);
  });
}
