import 'package:blocstar/BlocBase.dart';
import 'package:blocstar/BlocContextBase.dart';
import 'package:blocstar/DataManagement/Mergeable.dart';

class CounterContext extends BlocContextBase<CounterContext> {
  final int count;
  final String description;

  CounterContext(BlocBase<BlocContextBase<CounterContext>> blocBase,
      {this.count, this.description})
      : super(blocBase);

  @override
  merge({int newCount, String newDescription}) {
    new CounterContext(blocBase,
        count: resolveValue(count, newCount),
        description: resolveValue(description, newDescription));
  }
}
