import 'package:blocstar/DataManagement/Mergeable.dart';
import 'package:flutter/widgets.dart';

import 'ActionState.dart';
import 'BlocstarLogicBase.dart';

abstract class BlocstarContextBase<TBlocStarContext>
    implements Mergeable<TBlocStarContext> {
  ActionState? actionState;
  final BlocstarLogicBase<BlocstarContextBase<TBlocStarContext>> _logic;

  BlocstarContextBase(this._logic) {
    getNewActionState() {
      return new ActionState(false, false, null, this._logic, null);
    }

    if (_logic.initialized) {
      actionState = this._logic.context.actionState ?? getNewActionState();
    } else {
      actionState = getNewActionState();
    }
    _logic.onContextChangedCallback(this);
  }

  @protected
  BlocstarLogicBase<BlocstarContextBase<TBlocStarContext>> get logic => _logic;
}
