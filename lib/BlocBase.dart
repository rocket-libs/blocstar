import 'dart:async';

import 'package:blocstar/ActionState.dart';
import 'package:blocstar/BlocRunner.dart';
import 'package:flutter/widgets.dart';

import 'BlocContextBase.dart';

abstract class BlocBase<TBlocContext extends BlocContextBase> {
  final _controller = StreamController<TBlocContext>();
  TBlocContext context;

  Stream<TBlocContext> get stream => _controller.stream;

  Future initializeAsync();

  onActionStateChangedCallback(ActionState actionState) {
    sinkDefault();
  }

  sinkDefault() {
    sink(context);
  }

  sink(TBlocContext context) {
    if (isClosed == false) {
      context = context;
      _controller.sink.add(context);
    } else {
      throw new Exception("Cannot sink into a closed controller");
    }
  }

  bool get initialized {
    return context != null;
  }

  /// This method will return null should an exception be thrown or should it timeout.
  ///  Non-null return values are only returned on success
  Future runAsync<TResult>(
      {@required Future<TResult> Function() function,
      @required int timeoutSeconds}) async {
    return await BlocRunner.runAsync(
        function: function,
        actionState: context.actionState,
        timeoutSeconds: timeoutSeconds);
  }

  void dispose() {
    _controller.close();
  }

  bool get isClosed => _controller.isClosed;
}
