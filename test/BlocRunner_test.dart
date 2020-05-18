import 'package:blocstar/BlocRunner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'TestBloc.dart';

void main() {
  test("Timeout fires on long delay", () async {
    final testBloc = new TestBloc()..initializeAsync();
    final testContext = testBloc.context;

    await BlocRunner.runAsync(
        function: () async =>
            Future.delayed(new Duration(milliseconds: 1100), () => {}),
        actionState: testContext.actionState,
        timeoutSeconds: 1);

    expect(testContext.actionState.lastActionTimedOut, true);
  });

  group("Timeout vs Completion return values", () {
    final successResult = 6;

    test("Timeout returns null", () async {
      final testBloc = new TestBloc()..initializeAsync();
      final testContext = testBloc.context;

      final actualResult = await BlocRunner.runAsync(
          function: () async => await Future.delayed(
              new Duration(milliseconds: 1100), () => successResult),
          actionState: testContext.actionState,
          timeoutSeconds: 1);

      expect(actualResult, null);
    });

    test("Completion returns actual value", () async {
      final testBloc = new TestBloc()..initializeAsync();
      final testContext = testBloc.context;

      final actualResult = await BlocRunner.runAsync(
          function: () async => Future.delayed(
              new Duration(milliseconds: 500), () => successResult),
          actionState: testContext.actionState,
          timeoutSeconds: 1);
      testContext.merge(newRawValue: actualResult);
      expect(testBloc.context.rawValue, successResult);
    });
  });

  test("Timeout does not fire too early", () async {
    final testBloc = new TestBloc()..initializeAsync();
    final testContext = testBloc.context;

    await BlocRunner.runAsync(
        function: () async =>
            Future.delayed(new Duration(milliseconds: 900), () => {}),
        actionState: testContext.actionState,
        timeoutSeconds: 1);

    expect(testContext.actionState.lastActionTimedOut, false);
  });
}
