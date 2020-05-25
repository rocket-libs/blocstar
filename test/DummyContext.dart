import 'package:blocstar/BlocstarContextBase.dart';
import 'package:blocstar/BlocstarLogicBase.dart';
import 'package:blocstar/DataManagement/Mergeable.dart';

class DummyContext extends BlocstarContextBase<DummyContext> {
  final int count;
  final int rawValue;
  final int lastUpdated;

  DummyContext(BlocstarLogicBase<BlocstarContextBase<DummyContext>> logic,
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
