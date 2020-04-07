import 'package:blocstar/ActionState.dart';
import 'package:blocstar/BlocRunner.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test("Timeout fires on long delay",() async {
    ActionState newActionState;
    final actionState = new ActionState(false, false, null, (aS){
      newActionState = aS;
    });

    await BlocRunner.runAsync(
      function: () async => Future.delayed(new Duration(milliseconds: 1100),() => { }), 
      actionState: actionState, 
      timeoutSeconds: 1
    );

    expect(newActionState.lastActionTimedOut, true);
  });


  test("Timeout does not fire too early",() async {
    ActionState newActionState;
    final actionState = new ActionState(false, false, null, (aS){
      newActionState = aS;
    });

    await BlocRunner.runAsync(
      function: () async => Future.delayed(new Duration(milliseconds: 900),() => { }), 
      actionState: actionState, 
      timeoutSeconds: 1
    );

    expect(newActionState.lastActionTimedOut, false);
  });
}