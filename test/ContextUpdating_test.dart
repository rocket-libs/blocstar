import 'package:flutter_test/flutter_test.dart';

import 'DummyLogic.dart';

void main() {
  test("Context Is Updated Correctly", () async {
    final dummyLogic = new DummyLogic();
    await dummyLogic.initializeAsync();
    await dummyLogic.increment();
    expect(dummyLogic.context.count, 1);
    expect(dummyLogic.initialized, true);
  });
}
