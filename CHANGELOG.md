## 1.3.8

- Bugfix

## 1.3.6

- Fixed crash occuring during logic initialization

## 1.3.1

- Fixed analysis issues

## 1.3.2

- Ensured logic and logic.context are non-nullable

## 1.3.0 - Migrated to Null Safety

## 1.2.5 - Fixed Stacktrace Forwarding Issue.

- Fixed bug preventing stacktrace from errors from bubbling up.
- Added test to verify stacktrace is actually passed up.

## 1.2.4 - Library Now Forwards All Stacktraces.

## 1.2.3 - Fixed Bug That Caused Some Errors Not To Be Passed To Client.

- Began wrapping all failure values that are non-timeout exceptions in the object 'BlocstarException' as previously, anything that didn't implement or extend 'Exception' was discarded.

## 1.2.2 - Simplified Binding To UI

- Added a single abstract method called _'rootWidget'_ which is now all that the developer needs to implement to bind to UI to Blocstar.

## 1.2.1 - Deprecated Method

- Marked method 'willDispose' in BlocstarUIBinder as deprecated

## 1.2.0 - Changes To Make Class Names More Descriptive

- Refactored and renamed classes for added clarity

## 1.1.0 - Efficiency & Documentation

- Removed massively reduced boilerplate required and also enriched the documentation to allow better description of the project.

## 1.1.0-beta09 - Fixed breaking tests

- Fixed breaking tests due to change in code

## 1.1.0-beta08 - Removed redundant call

- Removed redundant call

## 1.1.0-beta07 - Blocked passing of null values to BlocBase

- Blocked passing of null values to BlocBase

## 1.1.0-beta06 - Bugfix

- Will this work

## 1.1.0-beta05 - Bugfix

- Replaced code using closure as capture variable was preventing proper update

## 1.1.0-beta04 - Bugfix

- Removed code that was breaking build

## 1.1.0-beta03 - Reduce boilerplate even further

- No need to pass ActionState in business logic, moved its setup to context class for clearer code

## 1.1.0-beta01 - Reduce boilerplate

- Centralized functionality to broadcast changes to context in the context object itself.
  This way there is no need to manually call a method everytime context is updated.

## 1.0.4 - Added documentation.

- Added documentation

## 0.1.0 - DRYing up code.

- Outsourced object creation to the excellent bargain_di package

## 0.0.23 - New Functionality.

- Fixed crash

## 0.0.22 - New Functionality.

- Added code to assist with serialization and deserialization of models

## 0.0.21 - Refactor.

- Removed unnecessary cast

## 0.0.20 - Bugfix.

- Simple refactor

## 0.1.2 - Refactor.

- Simple refactor

## 0.0.19 - Refactor.

- Changed confusing name 'model' to 'context'

## 0.0.17 - Bugfix.

- Simple refactor

## 0.0.16 - Bugfix.

- Fixed issue that was resulting in timed-out calls later returning a value when they should return null (super for real this time).

## 0.0.15 - Bugfix.

- Fixed issue that was resulting in timed-out calls later returning a value when they should return null (for real this time).

## 0.0.14 - Bugfix.

- Fixed issue that was resulting in timed-out calls later returning a value when they should return null.

## 0.0.13 - Refactor.

- Added functionality for self-canceling of tasks that throw exceptions or those that timeout

## 0.0.12 - Refactor.

- Added a working example to demonstrate how to use the code

## 0.0.11 - Refactor.

- Renamed method 'bootstrapper' to more descriptive 'bind' in BlocWidgetState

## 0.0.9 - Convenience.

- Convenience method for running async directly from bloc

## 0.0.8 - Simple Refactor

- Gave timeout result a higher precedence than general exceptions

## 0.0.7 - Simple Refactor

- Added functionality to catch errors

## 0.0.6 - Simple Refactor

- Stopped rethrowing exceptions caught in the bloc runner

## 0.0.5 - Simple Refactor

- Made onAppStateChanged mandatory in BlocModelBase
