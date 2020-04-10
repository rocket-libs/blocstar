import 'package:blocstar/ActionState.dart';
import 'package:blocstar/BlocModelBase.dart';

class BlocModel extends BlocModelBase<BlocModel> {
  BlocModel(Function(ActionState) onAppStateChanged) : super(onAppStateChanged);

  @override
  BlocModel merge() {}
}
