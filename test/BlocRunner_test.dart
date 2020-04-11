import 'package:blocstar/ActionState.dart';
import 'package:blocstar/BlocRunner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Timeout fires on long delay", () async {
    ActionState newActionState;
    final actionState = new ActionState(false, false, null, (aS) {
      newActionState = aS;
    });

    await BlocRunner.runAsync(
        function: () async =>
            Future.delayed(new Duration(milliseconds: 1100), () => {}),
        actionState: actionState,
        timeoutSeconds: 1);

    expect(newActionState.lastActionTimedOut, true);
  });

  group("Timeout vs Completion return values", () {
    final successResult = 6;

    test("Timeout returns null", () async {
      ActionState newActionState;
      final actionState = new ActionState(false, false, null, (aS) {
        newActionState = aS;
        newActionState = newActionState; // to silence warning
      });

      final actualResult = await BlocRunner.runAsync(
          function: () async => await Future.delayed(
              new Duration(milliseconds: 1100), () => successResult),
          actionState: actionState,
          timeoutSeconds: 1);

      expect(actualResult, null);
    });

    test("Completion returns actual value", () async {
      ActionState newActionState;
      final actionState = new ActionState(false, false, null, (aS) {
        newActionState = aS;
        newActionState = newActionState; // to silence warning
      });

      final actualResult = await BlocRunner.runAsync(
          function: () async => Future.delayed(
              new Duration(milliseconds: 500), () => successResult),
          actionState: actionState,
          timeoutSeconds: 1);

      expect(actualResult, successResult);
    });
  });

  test("Timeout does not fire too early", () async {
    ActionState newActionState;
    final actionState = new ActionState(false, false, null, (aS) {
      newActionState = aS;
    });

    await BlocRunner.runAsync(
        function: () async =>
            Future.delayed(new Duration(milliseconds: 900), () => {}),
        actionState: actionState,
        timeoutSeconds: 1);

    expect(newActionState.lastActionTimedOut, false);
  });
}
