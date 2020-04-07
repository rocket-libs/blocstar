import 'package:blocstar/Mergeable.dart';
import 'package:flutter/material.dart';

import 'ActionState.dart';

abstract class BlocModelBase<TBlocModel> implements Mergeable<TBlocModel>{
  ActionState actionState;
  

  BlocModelBase({Function(ActionState) onAppStateChanged}){
    actionState = new ActionState(false, false,null, onAppStateChanged);
  }

  @protected
  BlocModelBase<TBlocModel> mergeAppState(BlocModelBase<TBlocModel> newModel){
    newModel.actionState = new ActionState(false, false, null, actionState.onActionStateChanged);
    return newModel;
  }

  
}