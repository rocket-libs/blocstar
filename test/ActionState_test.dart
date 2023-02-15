import 'package:flutter_test/flutter_test.dart';

import 'DummyLogic.dart';

void main() {
  test("busy state triggers ActionState", () {
    final dummyLogic = new DummyLogic()..initializeAsync();
    final dummyContext = dummyLogic.context;
    dummyContext.actionState.busy = true;
    expect(dummyContext.actionState.busy, true);
    expect(dummyLogic.context.lastUpdated > 0, true);
  });

  test("last action timeout triggers ActionState", () {
    final dummyLogic = new DummyLogic()..initializeAsync();
    final dummyContext = dummyLogic.context;
    dummyContext.actionState.lastActionTimedOut = true;
    expect(dummyContext.actionState.lastActionTimedOut, true);
    expect(dummyLogic.context.lastUpdated > 0, true);
  });

  test("last action exception triggers ActionState", () {
    final dummyLogic = new DummyLogic()..initializeAsync();
    final dummyContext = dummyLogic.context;
    final theException = new Exception("Bad Stuff");
    dummyContext.actionState.onError(theException, null);
    expect(dummyContext.actionState.lastActionException != null, true);
    expect(dummyLogic.context.lastUpdated > 0, true);
  });

  test("stacktrace is passed when exception is thrown", () async {
    final dummyLogic = new DummyLogic();
    await dummyLogic.initializeAsync();
    await dummyLogic.throwExceptionAsync();
    expect(dummyLogic.context.actionState.lastStackTrace != null, true);
  });
}
