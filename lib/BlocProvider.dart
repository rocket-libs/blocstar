import 'package:blocstar/BlocstarLogicBase.dart';
import 'package:flutter/widgets.dart';

class BlocProvider<T extends BlocstarLogicBase?> extends StatefulWidget {
  final Widget child;
  final T bloc;

  const BlocProvider({Key? key, required this.bloc, required this.child})
      : super(key: key);

  static T of<T extends BlocstarLogicBase>(BuildContext context) {
    final type = _providerType<BlocProvider<T>>();
    final BlocProvider<T>? provider = context.findAncestorWidgetOfExactType<
        BlocProvider<T>>(); //context.ancestorWidgetOfExactType(type);
    if (provider == null) {
      throw new Exception("Could not find provider for bloc of type $type");
    }
    return provider.bloc;
  }

  static Type _providerType<T>() => T;

  @override
  State createState() => _BlocProviderState();
}

class _BlocProviderState extends State<BlocProvider> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    widget.bloc?.dispose();
    super.dispose();
  }
}
