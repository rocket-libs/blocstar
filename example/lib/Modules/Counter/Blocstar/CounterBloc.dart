import 'package:blocstar/BlocBase.dart';
import 'package:blocstar/BlocRunner.dart';
import 'package:blocstar_example/Modules/Counter/Blocstar/CounterBlocModel.dart';

class CounterBloc extends BlocBase<CounterBlocModel> {
  @override
  Future initializeAsync() async {
    currentModel = new CounterBlocModel(
        count: 0,
        description: "Button Press Count",
        onAppStateChanged: onAppStateChangedCallback);
    sinkDefault();
  }

  buttonPressedAsync(
    int duration,
  ) async {
    await BlocRunner.runAsync(
        function: () async {
          await Future.delayed(new Duration(seconds: duration), () {
            if(currentModel.actionState.lastActionTimedOut){
              return;
            }else{
              _incrementCount();
            }
          }); 
        },
        actionState: currentModel.actionState,
        timeoutSeconds: 7);
  }

  simulateExceptionAsync() async {
    await runAsync(
        function: () async {
          await Future.delayed(
              new Duration(seconds: 3), () => throw new Exception("Bad Luck"));
        },
        timeoutSeconds: 7);
  }

  _incrementCount() {
    currentModel = currentModel.merge(newCount: currentModel.count + 1);
    sinkDefault();
  }
}
