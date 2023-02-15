import 'package:blocstar/ObjectFactories/BlocstarObjectsProvider.dart';
import 'package:blocstar_example/Modules/Counter/Blocstar/CounterBloc.dart';

class BlocRegistry {
  static register() {
    BlocstarObjectsProvider.objectFactory
      ..registerImplicit<CounterBloc>(() => new CounterBloc());
  }
}
