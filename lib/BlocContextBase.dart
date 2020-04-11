import 'package:blocstar/Mergeable.dart';
import 'package:flutter/material.dart';

import 'ActionState.dart';

abstract class BlocContextBase<TBlocContext> implements Mergeable<TBlocContext> {
  ActionState actionState;

  BlocContextBase(Function(ActionState) onActionStateChanged) {
    actionState = new ActionState(false, false, null, onActionStateChanged);
  }

  @protected
  BlocContextBase<TBlocContext> mergeAppState(BlocContextBase<TBlocContext> newModel) {
    newModel.actionState =
        new ActionState(false, false, null, actionState.onActionStateChanged);
    return newModel;
  }
}
