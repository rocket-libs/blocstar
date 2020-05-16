import 'BlocContextBase.dart';

class ActionState<TBlocContext extends BlocContextBase> {
  bool _busy;
  bool _lastActionTimedOut;
  Exception _lastActionException;
  final TBlocContext context;

  ActionState(this._busy, this._lastActionTimedOut, this._lastActionException,
      this.context);

  set busy(bool value) {
    _busy = value;
    this.context.onContextChanged(this.context);
  }

  bool get busy => _busy;

  set lastActionTimedOut(bool value) {
    _lastActionTimedOut = value;
    this.context.onContextChanged(this.context);
  }

  bool get lastActionTimedOut => _lastActionTimedOut;

  bool get errorOccuredOnLastAction => lastActionException != null;

  set lastActionException(Exception exception) {
    _lastActionException = exception;
    this.context.onContextChanged(this.context);
  }

  Exception get lastActionException => _lastActionException;
}
