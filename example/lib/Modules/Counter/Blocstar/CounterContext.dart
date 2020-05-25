import 'package:blocstar/BlocstarContextBase.dart';
import 'package:blocstar/BlocstarLogicBase.dart';
import 'package:blocstar/DataManagement/Mergeable.dart';

class CounterContext extends BlocstarContextBase<CounterContext> {
  final int count;
  final String description;

  CounterContext(
      BlocstarLogicBase<BlocstarContextBase<CounterContext>> logic,
      {this.count,
      this.description})
      : super(logic);

  @override
  merge({int newCount, String newDescription}) {
    new CounterContext(logic,
        count: resolveValue(count, newCount),
        description: resolveValue(description, newDescription));
  }
}
