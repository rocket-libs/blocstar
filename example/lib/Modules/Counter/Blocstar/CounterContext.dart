import 'package:blocstar/BlocBase.dart';
import 'package:blocstar/DataManagement/Mergeable.dart';

class CounterContext extends BlocstarLogicBaseContextBase<CounterContext> {
  final int count;
  final String description;

  CounterContext(
      BlocBase<BlocstarLogicBaseContextBase<CounterContext>> blocBase,
      {this.count,
      this.description})
      : super(blocBase);

  @override
  merge({int newCount, String newDescription}) {
    new CounterContext(_logic,
        count: resolveValue(count, newCount),
        description: resolveValue(description, newDescription));
  }
}
