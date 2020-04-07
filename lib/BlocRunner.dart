import 'dart:async';

import 'package:blocstar/ActionState.dart';
import 'package:flutter/widgets.dart';

class BlocRunner {
  static Future<TResult> runAsync<TResult>(
      {@required Future<TResult> Function() function,
      @required ActionState actionState,
      @required int timeoutSeconds}) async {
    try {
      assert(function != null && actionState != null);
      actionState.lastActionTimedOut = false;
      actionState.busy = true;
      actionState.lastActionException = null;
      final result =
          await function().timeout(Duration(seconds: timeoutSeconds));
      return result;
    } on TimeoutException catch (toe) {
      actionState.lastActionTimedOut = true;
      actionState.lastActionException = toe;
      return null;
    } catch (e) {
      actionState.lastActionException = e;
    } finally {
      actionState.busy = false;
    }
  }
}
