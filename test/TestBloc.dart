import 'package:blocstar/BlocBase.dart';

import 'TestContext.dart';

class TestBloc extends BlocBase<TestContext> {
  @override
  Future initializeAsync() async {
    context = new TestContext(onContextChangedCallback, count: 0);
  }

  Future increment() async {
    final incrementedValue =
        await runAsync(function: () => _delayedIncrement(), timeoutSeconds: 1);
    if (incrementedValue != null) {
      context.merge(newCount: incrementedValue);
    }
  }

  Future _delayedIncrement() async {
    final result = context.count + 1;
    return await Future.delayed(Duration(milliseconds: 1), () => result);
  }
}
