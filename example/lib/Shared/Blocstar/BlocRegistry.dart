import 'package:blocstar/ObjectFactories/BlocstarObjectsProvider.dart';
import 'package:blocstar_example/Modules/Counter/Blocstar/CounterBloc.dart';

class BlocRegistry {
  static register() {
    BlocstarObjectsProvider.objectFactory
      ..register<CounterBloc>(() => new CounterBloc());
  }
}
