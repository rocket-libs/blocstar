import 'dart:async';

import 'package:async/async.dart';
import 'package:blocstar/ActionState.dart';
import 'package:blocstar/BlocstarContextBase.dart';
import 'package:flutter/widgets.dart';

import 'BlocstarException.dart';

abstract class BlocstarLogicBase<
    TBlocstarLogicBaseContext extends BlocstarContextBase?> {
  final StreamController<TBlocstarLogicBaseContext?> _controller = StreamController<TBlocstarLogicBaseContext>();
  TBlocstarLogicBaseContext? context;

  Stream<TBlocstarLogicBaseContext?> get stream => _controller.stream;

  Future initializeAsync();

  onContextChangedCallback(TBlocstarLogicBaseContext updatedContext) {
    sink(updatedContext);
  }

  sink(TBlocstarLogicBaseContext updatedContext) {
    if (isClosed == false) {
      context = updatedContext ?? context;
      _controller.sink.add(context);
    } else {
      throw new Exception("Cannot sink into a closed controller");
    }
  }

  bool get initialized {
    return context != null;
  }

  /// This method will return null should an exception be thrown or should it timeout.
  /// Non-null return values are only returned on success
  /// Calling 'sinkDefault' after this method returns null, overwrites any error or timeout information that
  /// will have been set by Blocstar. First consume the error or timeout information if you you need it, before subsequent
  /// calls to 'sinkDefault'
  @protected
  Future runAsync<TResult>(
      {required Future<TResult> Function() function,
      required int timeoutSeconds}) async {
    return await _BlocRunner.runAsync(
        function: function,
        actionState: context!.actionState!,
        timeoutSeconds: timeoutSeconds);
  }

  void dispose() {
    _controller.close();
  }

  bool get isClosed => _controller.isClosed;
}

class _BlocRunner {
  /// This method will return null should an exception be thrown or should it timeout.
  ///  Non-null return values are only returned on success
  static Future<TResult?> runAsync<TResult>(
      {required Future<TResult> Function() function,
      required ActionState actionState,
      required int timeoutSeconds}) async {
    final cancelableCompleter =
        new CancelableCompleter<TResult>(onCancel: () => null);

    try {
      assert(function != null && actionState != null);
      actionState.lastActionTimedOut = false;
      actionState.busy = true;
      actionState.clearErrors();
      final timedFuture = () async =>
          await function().timeout(Duration(seconds: timeoutSeconds));
      cancelableCompleter.complete(await timedFuture());
      final result = cancelableCompleter.operation.value;
      if (actionState.errorOccuredOnLastAction ||
          actionState.lastActionTimedOut) {
        return null;
      } else {
        return result;
      }
    } on TimeoutException catch (toe, timeoutStackTrace) {
      cancelableCompleter.operation.cancel();
      actionState.lastActionTimedOut = true;
      actionState.onError(toe, timeoutStackTrace);
      return null;
    } catch (otherValue, stackTrace) {
      cancelableCompleter.operation.cancel();
      //We can't guarantee 'otherValue' will always be an exception, so we wrap it in 'BlocstarException' to ensure we can guarantee it will be passed to caller successfully.
      actionState.onError(new BlocstarException(otherValue), stackTrace);
      return null;
    } finally {
      actionState.busy = false;
    }
  }
}
