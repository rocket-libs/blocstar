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
    await runAsync(
        function: () async => await _incrementAsync(duration),
        timeoutSeconds: 7);
  }

  _incrementAsync(int duration) async {
    final newCount = await Future.delayed(new Duration(seconds: duration), () {
      return currentModel.count + 1;
    });

    //Timed out calls or calls in error, return null
    if (newCount != null) {
      currentModel = currentModel.merge(newCount: currentModel.count + 1);
      sinkDefault();
    }
  }

  simulateExceptionAsync() async {
    await runAsync(
        function: () async {
          await Future.delayed(
              new Duration(seconds: 3), () => throw new Exception("Bad Luck"));
        },
        timeoutSeconds: 7);
  }
}
