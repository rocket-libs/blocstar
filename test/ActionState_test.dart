import 'package:flutter_test/flutter_test.dart';

import 'TestContext.dart';

void main() {
  test("busy state triggers ActionState", () {
    var busy = false;
    final context = new TestContext((ctx) {
      busy = ctx.actionState.busy;
    });

    context.actionState.busy = true;
    expect(busy, true);
  });

  test("last action timeout triggers ActionState", () {
    var lastActionTimeOut = false;
    final context = new TestContext((ctx) {
      lastActionTimeOut = ctx.actionState.lastActionTimedOut;
    });

    context.actionState.lastActionTimedOut = true;
    expect(lastActionTimeOut, true);
  });

  test("last action exception triggers ActionState", () {
    final exceptionMessage = "blah";
    Exception lastException;
    final context = new TestContext((ctx) {
      lastException = ctx.actionState.lastActionException;
    });

    context.actionState.lastActionException = new Exception(exceptionMessage);
    expect(lastException != null, true);
  });
}
