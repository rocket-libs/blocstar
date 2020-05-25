
import 'package:blocstar/BlocContextBase.dart';
import 'package:blocstar/BlocstarLogicBase.dart';
import 'package:blocstar/DataManagement/Mergeable.dart';

class DummyContext extends BlocstarLogicBaseContextBase<DummyContext> {
  final int count;
  final int rawValue;
  final int lastUpdated;

  DummyContext(BlocstarLogicBase<BlocstarLogicBaseContextBase<DummyContext>> logic,
      {this.count, this.rawValue, this.lastUpdated})
      : super(logic);

  @override
  merge({int newCount, int newRawValue}) {
    new DummyContext(logic,
        count: resolveValue(count, newCount),
        rawValue: resolveValue(rawValue, newRawValue),
        lastUpdated: DateTime.now().millisecondsSinceEpoch);
  }
}
