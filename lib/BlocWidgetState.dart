import 'package:blocstar/BlocFactory.dart';
import 'package:blocstar/BlocModelBase.dart';
import 'package:flutter/widgets.dart';

import 'BlocBase.dart';
import 'BlocProvider.dart';

abstract class BlocState<TState extends StatefulWidget, TBloc extends BlocBase,
    TBlocModel extends BlocModelBase> extends State<TState> {
  TBloc _privateBloc;
  TBlocModel model;

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

  Widget bootstrapper({@required Widget Function() fnContentBuilder}) {
    return _bootstrapper(
        fnNoData: fnContentBuilder, fnHasData: (_) => fnContentBuilder());
  }

  Widget getCurrentWidget(
      {@required Widget Function() onNullModel,
      @required Widget Function() onBusy,
      @required Widget Function() onError,
      @required Widget Function() onTimeOut,
      @required Widget Function() onSuccess}) {
    if (model == null) {
      return onNullModel();
    } else if (model.actionState.busy) {
      return onBusy();
    } else {
      if (model.actionState.lastActionTimedOut) {
        return onTimeOut();
      } else {
        return onSuccess();
      }
    }
  }

  Widget _bootstrapper(
      {@required Widget Function() fnNoData,
      @required Widget Function(TBlocModel) fnHasData}) {
    var widget = BlocProvider<TBloc>(
      bloc: bloc,
      child: StreamBuilder<TBlocModel>(
          stream: bloc.stream,
          builder: (blocContext, snapshot) {
            if (snapshot.hasData == false) {
              return fnNoData();
            }
            model = snapshot.data;
            return fnHasData(snapshot.data);
          }),
    );
    return widget;
  }
}
