import 'package:blocstar/ActionState.dart';
import 'package:blocstar/BlocContextBase.dart';
import 'package:blocstar/Mergeable.dart';

class CounterBlocContext extends BlocContextBase<CounterBlocContext> {
  final int count;
  final String description;

  CounterBlocContext(
      {this.count, this.description, Function(ActionState) onActionStateChanged})
      : super(onActionStateChanged);

  @override
  CounterBlocContext merge({int newCount, String newDescription}) {
    final newModel = new CounterBlocContext(
        count: resolveValue(count, newCount),
        description: resolveValue(description, newDescription));
    return mergeAppState(newModel);
  }
}
