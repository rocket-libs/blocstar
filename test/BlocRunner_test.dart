import 'package:flutter_test/flutter_test.dart';
import 'TestBloc.dart';

void main() {
  test("Timeout fires on long delay", () async {
    final testBloc = new TestBloc()..initializeAsync();
    final testContext = testBloc.context;

    await testBloc.asyncSimulator(
      executionDelayMilliseconds: 1100,
      timeoutSeconds: 1
    );

    expect(testContext.actionState.lastActionTimedOut, true);
  });

  group("Timeout vs Completion return values", () {
    final successResult = 6;

    test("Timeout returns null", () async {
      final testBloc = new TestBloc()..initializeAsync();
      

      final actualResult = await testBloc.asyncSimulator(
        executionDelayMilliseconds: 1100,
        timeoutSeconds: 1
      );

      expect(actualResult, null);
    });

    test("Completion returns actual value", () async {
      final testBloc = new TestBloc()..initializeAsync();
      final testContext = testBloc.context;

      final actualResult = await testBloc.asyncSimulator(
        executionDelayMilliseconds: 500,
        timeoutSeconds: 1,
        result: successResult
      );
      testContext.merge(newRawValue: actualResult);
      expect(testBloc.context.rawValue, successResult);
    });
  });

  test("Timeout does not fire too early", () async {
    final testBloc = new TestBloc()..initializeAsync();
    final testContext = testBloc.context;

    await testBloc.asyncSimulator(
      executionDelayMilliseconds: 900,
      timeoutSeconds: 1
    );
    
    expect(testContext.actionState.lastActionTimedOut, false);
  });
}
