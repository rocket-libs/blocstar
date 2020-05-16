import 'package:blocstar/BlocContextBase.dart';
import 'package:blocstar/DataManagement/Mergeable.dart';

class CounterContext extends BlocContextBase<CounterContext> {
  final int count;
  final String description;

  CounterContext(Function(CounterContext) onContextChanged,
      {this.count, this.description})
      : super(onContextChanged);

  @override
  merge({int newCount, String newDescription}) {
    new CounterContext(
        onContextChanged,
        count: resolveValue(count, newCount),
        description: resolveValue(description, newDescription));
  }
}
