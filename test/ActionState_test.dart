import 'package:blocstar/ActionState.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  
  test("busy state triggers ActionState",(){
    var busy = false;
    final actionState = new ActionState(false, false, null, (actionState) {
      busy = actionState.busy;
    });
    actionState.busy = true;
    expect(busy, true);
  });

  test("last action timeout triggers ActionState",(){
    var lastActionTimeOut = false;
    final actionState = new ActionState(false, false, null, (actionState) {
      lastActionTimeOut = actionState.lastActionTimedOut;
    });
    actionState.lastActionTimedOut = true;
    expect(lastActionTimeOut, true);
  });

  test("last action exception triggers ActionState",(){
    final exceptionMessage = "blah";
    Exception lastException;
    final actionState = new ActionState(false, false, null, (actionState) {
      lastException = actionState.lastActionException;
    });
    actionState.lastActionException = new Exception(exceptionMessage);
    expect(lastException != null, true);
  });
}