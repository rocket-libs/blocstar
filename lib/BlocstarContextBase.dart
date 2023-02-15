import 'package:blocstar/DataManagement/Mergeable.dart';
import 'package:flutter/widgets.dart';

import 'ActionState.dart';
import 'BlocstarLogicBase.dart';

abstract class BlocstarContextBase<TBlocStarContext>
    implements Mergeable<TBlocStarContext> {
  ActionState? actionState;
  final BlocstarLogicBase<BlocstarContextBase<TBlocStarContext>> _logic;

  BlocstarContextBase(this._logic) {
    actionState = this._logic.context?.actionState ??
        new ActionState(false, false, null, this._logic,null);
    _logic.onContextChangedCallback(this);
  }

  @protected
  BlocstarLogicBase<BlocstarContextBase<TBlocStarContext>> get logic => _logic;
}
