import 'package:blocstar/BlocBase.dart';
import 'CounterBlocContext.dart';

class CounterBloc extends BlocBase<CounterBlocContext> {
  @override
  Future initializeAsync() async {
    context = new CounterBlocContext(
        count: 0,
        description: "Button Press Count",
        onActionStateChanged: onActionStateChangedCallback);
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
      return context.count + 1;
    });

    //Timed out calls or calls in error, return null
    if (newCount != null) {
      context = context.merge(newCount: context.count + 1);
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
