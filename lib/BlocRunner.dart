import 'dart:async';

import 'package:async/async.dart';
import 'package:blocstar/ActionState.dart';
import 'package:flutter/widgets.dart';

class BlocRunner {
  static Future<TResult> runAsync<TResult>(
      {@required Future<TResult> Function() function,
      @required ActionState actionState,
      @required int timeoutSeconds}) async {
    final cancelableCompleter =
        new CancelableCompleter<TResult>(onCancel: () => null);

    try {
      assert(function != null && actionState != null);
      actionState.lastActionTimedOut = false;
      actionState.busy = true;
      actionState.lastActionException = null;
      final timedFuture = () async =>
          await function().timeout(Duration(seconds: timeoutSeconds));
      cancelableCompleter.complete(await timedFuture());
      final result = cancelableCompleter.operation.value;
      if (actionState.errorOccuredOnLastAction || actionState.lastActionTimedOut) {
        return null;
      } else{
        return result;
      }
    } on TimeoutException catch (toe) {
      cancelableCompleter.operation.cancel();
      actionState.lastActionTimedOut = true;
      actionState.lastActionException = toe;
      return null;
    } catch (e) {
      cancelableCompleter.operation.cancel();
      actionState.lastActionException = e;
      return null;
    } finally {
      actionState.busy = false;
    }
  }
}
