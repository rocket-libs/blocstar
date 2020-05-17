import 'package:blocstar/BlocBase.dart';
import 'package:blocstar/BlocContextBase.dart';
import 'package:blocstar/DataManagement/Mergeable.dart';

class TestContext extends BlocContextBase<TestContext> {
  final int count;
  final int rawValue;
  final int lastUpdated;

  TestContext(BlocBase<BlocContextBase<TestContext>> blocBase,
      {this.count, this.rawValue, this.lastUpdated})
      : super(blocBase);

  @override
  merge({int newCount, int newRawValue}) {
    new TestContext(blocBase,
        count: resolveValue(count, newCount),
        rawValue: resolveValue(rawValue, newRawValue),
        lastUpdated: DateTime.now().millisecondsSinceEpoch);
  }
}
