import 'package:blocstar/DataManagement/Mergeable.dart';
import 'package:flutter/widgets.dart';

import 'ActionState.dart';
import 'BlocstarLogicBase.dart';

abstract class BlocstarLogicBaseContextBase<TBlocStarContext>
    implements Mergeable<TBlocStarContext> {
  ActionState actionState;
  final BlocstarLogicBase<BlocstarLogicBaseContextBase<TBlocStarContext>> _logic;

  BlocstarLogicBaseContextBase(this._logic) {
    actionState = this._logic.context?.actionState ??
        new ActionState(false, false, null, this._logic);
    _logic.onContextChangedCallback(this);
  }

  @protected
  BlocstarLogicBase<BlocstarLogicBaseContextBase<TBlocStarContext>> get logic => _logic;
}
