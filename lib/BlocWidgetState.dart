import 'package:blocstar/BlocContextBase.dart';
import 'package:blocstar/BlocFactory.dart';
import 'package:flutter/widgets.dart';

import 'BlocBase.dart';
import 'BlocProvider.dart';

abstract class BlocWidgetState<
    TState extends StatefulWidget,
    TBloc extends BlocBase> extends State<TState> {
  TBloc _privateBloc;

  willDispose();

  @override
  dispose() {
    willDispose();
    bloc.dispose();
    super.dispose();
  }

  TBloc get bloc {
    if (_privateBloc == null || _privateBloc.isClosed) {
      _privateBloc = _create();
    }
    return _privateBloc;
  }

  TBloc _create() {
    if (BlocFactory.factories.containsKey(TBloc)) {
      var factory = BlocFactory.factories[TBloc];
      return factory() as TBloc;
    } else {
      throw new Exception("Could not find a factory for type $TBloc");
    }
  }

  Widget bind({@required Widget Function() fnScreenGetter}) {
    return _bootstrapper(
        fnNoData: fnScreenGetter, fnHasData: (_) => fnScreenGetter());
  }

  Widget getCurrentWidget(
      {@required Widget Function() onNullContext,
      @required Widget Function() onBusy,
      @required Widget Function() onError,
      @required Widget Function() onTimeOut,
      @required Widget Function() onSuccess}) {
    if (bloc.initialized == false) {
      return onNullContext();
    }else{
      final context = (bloc.context as BlocContextBase);
      if (context.actionState.busy) {
        return onBusy();
      } else if (context.actionState.lastActionTimedOut) {
        return onTimeOut();
      } else if (context.actionState.errorOccuredOnLastAction) {
        return onError();
      } else {
        return onSuccess();
      }
    }
  }

  Widget _bootstrapper(
      {@required Widget Function() fnNoData,
      @required Widget Function(dynamic) fnHasData}) {
    var widget = BlocProvider<TBloc>(
      bloc: bloc,
      child: StreamBuilder<dynamic>(
          stream: bloc.stream,
          builder: (blocContext, snapshot) {
            if (snapshot.hasData == false) {
              return fnNoData();
            }
            return fnHasData(snapshot.data);
          }),
    );
    return widget;
  }
}
