import 'package:blocstar/BlocBase.dart';

import 'BlocContextBase.dart';

class ActionState<TBlocContext extends BlocContextBase> {
  bool _busy = false;
  bool _lastActionTimedOut = false;
  Exception _lastActionException;
  final BlocBase<TBlocContext> blocBase;

  ActionState(this._busy, this._lastActionTimedOut, this._lastActionException,
      this.blocBase);

  set busy(bool value) {
    _busy = value;
    blocBase.onContextChangedCallback(blocBase.context);
  }

  bool get busy => _busy;

  set lastActionTimedOut(bool value) {
    _lastActionTimedOut = value;
    blocBase.onContextChangedCallback(blocBase.context);
  }

  bool get lastActionTimedOut => _lastActionTimedOut;

  bool get errorOccuredOnLastAction => lastActionException != null;

  set lastActionException(Exception exception) {
    _lastActionException = exception;
    blocBase.onContextChangedCallback(blocBase.context);
  }

  Exception get lastActionException => _lastActionException;
}
