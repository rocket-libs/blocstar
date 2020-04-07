class ActionState{
  bool _busy;
  bool _lastActionTimedOut;
  Exception _lastActionException;
  final Function(ActionState) onActionStateChanged;

  ActionState(this._busy, this._lastActionTimedOut, this._lastActionException, this.onActionStateChanged);

  set busy(bool value){
    _busy = value;
    onActionStateChanged(this);
  }

  bool get busy => _busy;

  set lastActionTimedOut(bool value){
    _lastActionTimedOut = value;
    onActionStateChanged(this);
  }

  bool get lastActionTimedOut => _lastActionTimedOut;

  bool get errorOccuredOnLastAction => lastActionException != null;

  set lastActionException(Exception exception){
    _lastActionException = exception;
    onActionStateChanged(this);
  }

  Exception get lastActionException => _lastActionException;

  

}