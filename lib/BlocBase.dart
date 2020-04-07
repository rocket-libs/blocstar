import 'dart:async';

import 'package:blocstar/ActionState.dart';

abstract class BlocBase<TBlocModel> {
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

  void dispose() {
    _controller.close();
  }

  bool get isClosed => _controller.isClosed;
}
