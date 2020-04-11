import 'package:blocstar/ActionState.dart';
import 'package:blocstar/BlocModelBase.dart';
import 'package:blocstar/Mergeable.dart';

class CounterBlocModel extends BlocContextBase<CounterBlocModel> {
  final int count;
  final String description;

  CounterBlocModel(
      {this.count, this.description, Function(ActionState) onAppStateChanged})
      : super(onAppStateChanged);

  @override
  CounterBlocModel merge({int newCount, String newDescription}) {
    final newModel = new CounterBlocModel(
        count: resolveValue(count, newCount),
        description: resolveValue(description, newDescription));
    return mergeAppState(newModel);
  }
}
