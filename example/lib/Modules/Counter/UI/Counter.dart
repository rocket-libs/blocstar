import 'package:blocstar/BlocstarUIBinder.dart';
import 'package:blocstar_example/Modules/Counter/Blocstar/CounterBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Counter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _CounterState();
  }
}

class _CounterState extends BlocstarUIBinder<Counter, CounterBloc> {
  Widget _getCenterText(String text) {
    return Center(
      child: Container(padding: EdgeInsets.all(20), child: Text(text)),
    );
  }

  Widget _getButton(
      {@required String displayLabel, @required Function() onPressed}) {
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: SizedBox(
          width: double.infinity,
          child: RaisedButton(
            onPressed: onPressed,
            child: Text(displayLabel),
          ),
        ));
  }

  List<Widget> get _inputWidgets {
    return [
      _getButton(
          displayLabel: "Simulate Timeout",
          onPressed: () => logic.buttonPressedAsync(4)),
      _getButton(
          displayLabel: "Simulate Exception",
          onPressed: () => logic.simulateExceptionAsync()),
      _getButton(
          displayLabel: "Increment Count",
          onPressed: () => logic.buttonPressedAsync(3))
    ];
  }

  Widget get _readyWidget {
    final columnChildren = new List<Widget>();
    columnChildren.add(_outputWidgets);
    columnChildren.addAll(_inputWidgets);
    return SingleChildScrollView(
        child: Column(
      children: columnChildren,
    ));
  }

  Widget get _workingWidget {
    return Center(
      child: Column(children: [
        CircularProgressIndicator(),
        _getCenterText("Pretending to do some work")
      ]),
    );
  }

  Widget get _body {
    if (logic.initialized == false) {
      logic.initializeAsync();
      return _getCenterText("Initializing");
    } else {
      if (logic.context.actionState.busy) {
        return _workingWidget;
      } else {
        return _readyWidget;
      }
    }
  }

  Widget get _outputWidgets {
    if (logic.context.actionState.lastActionTimedOut) {
      return _getCenterText(
          "Oopsie. Looks like last action took too long to complete. Gracefully inform the user and give suggestions");
    } else if (logic.context.actionState.errorOccuredOnLastAction) {
      return _getCenterText(
          "Wow! An exception. How could this happen while we were so careful? Anyhow, inform the user, figure out a fallback action e.t.c");
    } else {
      return _getCenterText(logic.context.count.toString());
    }
  }

  Widget _getScreen() {
    return Scaffold(
        appBar: AppBar(
          title: Text("Blocstar Counter Example"),
        ),
        body: _body);
  }

  @override
  Widget build(BuildContext context) {
    return bind(fnScreenGetter: () => _getScreen());
  }

  @override
  willDispose() {}
}
