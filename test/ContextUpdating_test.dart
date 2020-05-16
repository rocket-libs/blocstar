import 'package:flutter_test/flutter_test.dart';

import 'TestBloc.dart';

void main() {
  test("Context Is Updated Correctly", () async {
    final testBloc = new TestBloc();
    await testBloc.initializeAsync();
    await testBloc.increment();
    expect(testBloc.context.count, 1);
    expect(testBloc.initialized, true);
  });
}
