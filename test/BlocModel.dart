import 'package:blocstar/ActionState.dart';
import 'package:blocstar/BlocContextBase.dart';

class BlocModel extends BlocContextBase<BlocModel> {
  BlocModel(Function(ActionState) onAppStateChanged) : super(onAppStateChanged);

  @override
  BlocModel merge() {
    return null;
  }
}
