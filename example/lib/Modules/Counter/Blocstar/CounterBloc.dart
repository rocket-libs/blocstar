import 'package:blocstar/BlocBase.dart';

import 'CounterContext.dart';

class CounterBloc extends BlocBase<CounterContext> {
  @override
  Future initializeAsync() async {
    context =
        new CounterContext(this, count: 0, description: "Button Press Count");
  }

  buttonPressedAsync(
    int duration,
  ) async {
    final incrementedCount = await runAsync(
        function: () async => await _incrementAsync(duration),
        timeoutSeconds: 3);

    //Timed out calls or calls in error, return null
    if (incrementedCount != null) {
      context.merge(newCount: incrementedCount);
    }
  }

  /// This method emulates an a async operation by instituting an delay of a user specified
  /// number of seconds before it does the increment.
  /// It allows us to see how Blocstar handles async calls.
  Future<int> _incrementAsync(int duration) async {
    final incrementedCount =
        await Future.delayed(new Duration(seconds: duration), () {
      return context.count + 1;
    });
    return incrementedCount;
  }

  simulateExceptionAsync() async {
    await runAsync(
        function: () async {
          await Future.delayed(
              new Duration(seconds: 2), () => throw new Exception("Bad Luck"));
        },
        timeoutSeconds: 3);
  }
}
