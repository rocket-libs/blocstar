import 'package:blocstar/BlocstarLogicBase.dart';

import 'DummyContext.dart';

class DummyLogic extends BlocstarLogicBase<DummyContext> {
  @override
  Future initializeAsync() async {
    new DummyContext(this, count: 0);
  }

  Future increment() async {
    final incrementedValue =
        await runAsync(function: () => _delayedIncrement(), timeoutSeconds: 1);
    if (incrementedValue != null) {
      context.merge(newCount: incrementedValue);
    }
  }

  Future asyncSimulator<TResult>(
      {required int executionDelayMilliseconds,
      required int timeoutSeconds,
      TResult? result}) async {
    return await runAsync(
        function: () async => Future.delayed(
            new Duration(milliseconds: executionDelayMilliseconds),
            () => result),
        timeoutSeconds: timeoutSeconds);
  }

  Future _delayedIncrement() async {
    final result = context.count! + 1;
    return await Future.delayed(Duration(milliseconds: 1), () => result);
  }

  @override
  onContextChangedCallback(DummyContext updatedContext) {
    if (updatedContext.lastUpdated == null) {
      updatedContext.merge();
      return;
    }
    return super.onContextChangedCallback(updatedContext);
  }

  Future throwExceptionAsync() async {
    await runAsync(function: (() => throw Exception()), timeoutSeconds: 10);
  }
}
