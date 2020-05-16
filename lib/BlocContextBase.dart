import 'package:blocstar/DataManagement/Mergeable.dart';
import 'package:flutter/material.dart';

import 'ActionState.dart';

abstract class BlocContextBase<TBlocContext>
    implements Mergeable<TBlocContext> {
  ActionState actionState;
  final Function(TBlocContext) onContextChanged;

  BlocContextBase(this.onContextChanged) {
    actionState = new ActionState(false, false, null, this);
    onContextChanged(this as TBlocContext);
  }

  @Deprecated("We probably don't need this anymore")
  @protected
  BlocContextBase<TBlocContext> mergeAppState(
      BlocContextBase<TBlocContext> newModel) {
    newModel.actionState = new ActionState(false, false, null, this);
    return newModel;
  }
}
