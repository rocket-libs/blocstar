import 'dart:async';

import 'package:blocstar/ActionState.dart';
import 'package:blocstar/BlocModelBase.dart';
import 'package:blocstar/BlocRunner.dart';
import 'package:flutter/widgets.dart';

abstract class BlocBase<TBlocModel extends BlocModelBase> {
  final _controller = StreamController<TBlocModel>();
  TBlocModel currentModel;

  Stream<TBlocModel> get stream => _controller.stream;

  Future initializeAsync();

  onAppStateChangedCallback(ActionState actionState) {
    sinkDefault();
  }

  sinkDefault() {
    sink(currentModel);
  }

  sink(TBlocModel model) {
    if (isClosed == false) {
      currentModel = model;
      _controller.sink.add(model);
    } else {
      throw new Exception("Cannot sink into a closed controller");
    }
  }

  bool get modelInitialized {
    return currentModel != null;
  }

  Future runAsync<TResult>(
      {@required Future<TResult> Function() function,
      @required int timeoutSeconds}) async {
    return await BlocRunner.runAsync(
        function: function,
        actionState: currentModel.actionState,
        timeoutSeconds: timeoutSeconds);
  }

  void dispose() {
    _controller.close();
  }

  bool get isClosed => _controller.isClosed;
}
