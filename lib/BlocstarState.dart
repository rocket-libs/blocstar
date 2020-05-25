import 'package:blocstar/BlocstarLogicBase.dart';
import 'package:flutter/widgets.dart';
import 'BlocProvider.dart';
import 'ObjectFactories/BlocstarObjectsProvider.dart';

abstract class BlocstarState<TState extends StatefulWidget,
    TLogic extends BlocstarLogicBase> extends State<TState> {
  TLogic _logic;

  Widget rootWidget();

  @override
  Widget build(BuildContext context) {
    return _bootstrapper(
        fnNoData: rootWidget, fnHasData: (_) => rootWidget());
  }

  @override
  dispose() {
    logic.dispose();
    super.dispose();
  }

  TLogic get logic {
    if (_logic == null || _logic.isClosed) {
      _logic = _create();
    }
    return _logic;
  }

  TLogic _create() {
    return BlocstarObjectsProvider.objectFactory.getInstance<TLogic>();
  }

  Widget getCurrentWidget(
      {@required Widget Function() onNullContext,
      @required Widget Function() onBusy,
      @required Widget Function() onError,
      @required Widget Function() onTimeOut,
      @required Widget Function() onSuccess}) {
    if (logic.initialized == false) {
      return onNullContext();
    } else {
      final context = logic.context;
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
    var widget = BlocProvider<TLogic>(
      bloc: logic,
      child: StreamBuilder<dynamic>(
          stream: logic.stream,
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
