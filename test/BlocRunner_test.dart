import 'package:flutter_test/flutter_test.dart';

import 'DummyLogic.dart';

void main() {
  test("Timeout fires on long delay", () async {
    final dummyLogic = new DummyLogic()..initializeAsync();
    final dummyContext = dummyLogic.context;

    await dummyLogic.asyncSimulator(
        executionDelayMilliseconds: 1100, timeoutSeconds: 1);

    expect(dummyContext.actionState.lastActionTimedOut, true);
  });

  group("Timeout vs Completion return values", () {
    final successResult = 6;

    test("Timeout returns null", () async {
      final dummyLogic = new DummyLogic()..initializeAsync();

      final actualResult = await dummyLogic.asyncSimulator(
          executionDelayMilliseconds: 1100, timeoutSeconds: 1);

      expect(actualResult, null);
    });

    test("Completion returns actual value", () async {
      final dummyLogic = new DummyLogic()..initializeAsync();
      final dummyContext = dummyLogic.context;

      final actualResult = await dummyLogic.asyncSimulator(
          executionDelayMilliseconds: 500,
          timeoutSeconds: 1,
          result: successResult);
      dummyContext.merge(newRawValue: actualResult);
      expect(dummyLogic.context.rawValue, successResult);
    });
  });

  test("Timeout does not fire too early", () async {
    final dummyLogic = new DummyLogic()..initializeAsync();
    final dummyContext = dummyLogic.context;

    await dummyLogic.asyncSimulator(
        executionDelayMilliseconds: 900, timeoutSeconds: 1);

    expect(dummyContext.actionState.lastActionTimedOut, false);
  });
}
