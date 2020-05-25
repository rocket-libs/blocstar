import 'package:blocstar/BlocstarContextBase.dart';
import 'package:blocstar/BlocstarLogicBase.dart';

class ActionState<TBlocContext extends BlocstarContextBase> {
  bool _busy = false;
  bool _lastActionTimedOut = false;
  Exception _lastActionException;
  final BlocstarLogicBase<TBlocContext> _logic;

  ActionState(this._busy, this._lastActionTimedOut, this._lastActionException,
      this._logic);

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

  set lastActionException(Exception exception) {
    _lastActionException = exception;
    _logic.onContextChangedCallback(_logic.context);
  }

  Exception get lastActionException => _lastActionException;
}
