import 'package:blocstar/BlocContextBase.dart';
import 'package:blocstar/DataManagement/Mergeable.dart';

class TestContext extends BlocContextBase<TestContext> {
  final int count;
  TestContext(Function(dynamic) onContextChanged, {this.count})
      : super(onContextChanged);

  @override
  merge({int newCount}) {
    new TestContext(this.onContextChanged,
        count: resolveValue(count, newCount));
  }
}
