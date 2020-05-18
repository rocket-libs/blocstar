import 'package:flutter_test/flutter_test.dart';

import 'TestBloc.dart';

void main() {
  test("busy state triggers ActionState", () {
    final testBloc = new TestBloc()..initializeAsync();
    final testContext = testBloc.context;
    testContext.actionState.busy = true;
    expect(testContext.actionState.busy, true);
    expect(testBloc.context.lastUpdated > 0, true);
  });

  test("last action timeout triggers ActionState", () {
    final testBloc = new TestBloc()..initializeAsync();
    final testContext = testBloc.context;
    testContext.actionState.lastActionTimedOut = true;
    expect(testContext.actionState.lastActionTimedOut, true);
    expect(testBloc.context.lastUpdated > 0, true);
  });

  test("last action exception triggers ActionState", () {
    final testBloc = new TestBloc()..initializeAsync();
    final testContext = testBloc.context;
    final theException = new Exception("Bad Stuff");
    testContext.actionState.lastActionException = theException;
    expect(testContext.actionState.lastActionException != null, true);
    expect(testBloc.context.lastUpdated > 0, true);
  });
}
