import 'package:blocstar/BlocstarContextBase.dart';
import 'package:blocstar/BlocstarLogicBase.dart';

class ActionState<TBlocContext extends BlocstarContextBase> {
  bool _busy = false;
  bool _lastActionTimedOut = false;
  Exception? lastActionException;
  StackTrace? lastStackTrace;
  final BlocstarLogicBase<TBlocContext?> _logic;

  ActionState(this._busy, this._lastActionTimedOut, this.lastActionException,
      this._logic, this.lastStackTrace);

  set busy(bool value) {
    _busy = value;
    _logic.onContextChangedCallback(_logic.context);
  }

  bool get busy => _busy;

  set lastActionTimedOut(bool value) {
    _lastActionTimedOut = value;
    _logic.onContextChangedCallback(_logic.context);
  }

  bool get lastActionTimedOut => _lastActionTimedOut;

  bool get errorOccuredOnLastAction => lastActionException != null;

  

  onError(Exception? exception, StackTrace? stackTrace) {
    lastActionException = exception;
    lastStackTrace = stackTrace;
    _logic.onContextChangedCallback(_logic.context);
  }

  clearErrors() {
    onError(null, null);
  }


}
