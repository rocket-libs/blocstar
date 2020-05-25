
import 'package:blocstar/BlocContextBase.dart';
import 'package:blocstar/BlocstarLogicBase.dart';
import 'package:blocstar/DataManagement/Mergeable.dart';

class TestContext extends BlocstarLogicBaseContextBase<TestContext> {
  final int count;
  final int rawValue;
  final int lastUpdated;

  TestContext(BlocstarLogicBase<BlocstarLogicBaseContextBase<TestContext>> logic,
      {this.count, this.rawValue, this.lastUpdated})
      : super(logic);

  @override
  merge({int newCount, int newRawValue}) {
    new TestContext(logic,
        count: resolveValue(count, newCount),
        rawValue: resolveValue(rawValue, newRawValue),
        lastUpdated: DateTime.now().millisecondsSinceEpoch);
  }
}
