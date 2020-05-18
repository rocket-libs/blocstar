import 'package:blocstar/BlocBase.dart';
import 'package:blocstar/DataManagement/Mergeable.dart';

import 'ActionState.dart';

abstract class BlocContextBase<TBlocContext>
    implements Mergeable<TBlocContext> {
  ActionState actionState;
  final BlocBase<BlocContextBase<TBlocContext>> blocBase;

  BlocContextBase(this.blocBase) {
    actionState = this.blocBase.context?.actionState ??
        new ActionState(false, false, null, this.blocBase);
    blocBase.onContextChangedCallback(this);
  }
}
