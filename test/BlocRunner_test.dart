import 'package:blocstar/ActionState.dart';
import 'package:blocstar/BlocRunner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'TestContext.dart';

void main() {
  test("Timeout fires on long delay", () async {
    ActionState newActionState;
    final context = new TestContext((ctx) {
      newActionState = ctx.actionState;
    });

    await BlocRunner.runAsync(
        function: () async =>
            Future.delayed(new Duration(milliseconds: 1100), () => {}),
        actionState: context.actionState,
        timeoutSeconds: 1);

    expect(newActionState.lastActionTimedOut, true);
  });

  group("Timeout vs Completion return values", () {
    final successResult = 6;

    test("Timeout returns null", () async {
      final testContext = new TestContext((_) {});

      final actualResult = await BlocRunner.runAsync(
          function: () async => await Future.delayed(
              new Duration(milliseconds: 1100), () => successResult),
          actionState: testContext.actionState,
          timeoutSeconds: 1);

      expect(actualResult, null);
    });

    test("Completion returns actual value", () async {
      TestContext resultContext;
      final workingContext = new TestContext((ctx) {
        resultContext = ctx;
      });

      final actualResult = await BlocRunner.runAsync(
          function: () async => Future.delayed(
              new Duration(milliseconds: 500), () => successResult),
          actionState: workingContext.actionState,
          timeoutSeconds: 1);
      workingContext.merge(newCount: actualResult);
      expect(resultContext.count, successResult);
    });
  });

  test("Timeout does not fire too early", () async {
    final textContext = new TestContext((ctx) {});

    await BlocRunner.runAsync(
        function: () async =>
            Future.delayed(new Duration(milliseconds: 900), () => {}),
        actionState: textContext.actionState,
        timeoutSeconds: 1);

    expect(textContext.actionState.lastActionTimedOut, false);
  });
}
