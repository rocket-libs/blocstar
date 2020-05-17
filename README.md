# blocstar
![Dart CI](https://github.com/rocket-libs/blocstar/workflows/Dart%20CI/badge.svg?branch=master)

Bloc based nano framework, that helps structure how your flutter code is laid out and written.

## Why?
A couples of reasons
1. State Management - While State Management is supported out of the box in Flutter, it encourages pollution of UI (widgets) with business logic. This is bad. Thankfully Flutter also comes with excellent support for Streams, out of which the BLoC pattern was born.
2. Enforcing Structure - While BLoC allows us to move business logic from widgets, it does not impose and opinions on how your code should be laid out. As with everything, there are pros and cons with this freedom, but an overwhelming con is that it leaves your codebase open to cognitive dissonance as based on context and constraints (deadlines anyone?) you may find yourself writing your BLoCs inconsistently. And obviously the problem becomes compounded when the code is written by a team rather than a single individual.

## Aspirations For This 
1. A rock-solid, light and easy to learn library. Pick it up, test drive it and see if it'll work for you, all in under a half hour.
2. Minimal boilerplate - focus on your code, not on rituals. Come back, and be able to easily understand the code a couple of weeks/months/years/(decades?) later.

## Getting Started
Alright enough of the selling, how does it work?
### Installing
Install from https://pub.dev/packages/blocstar#-installing-tab- , blocstar's installation page on pub.dev

### Blocstar's Philosophy (or a bit of context)
A key principle of Blocstar is that a Flutter application will be generally composed of:
1. User Interface - self explanatory I guess.
2. Business logic - the rules that do the heavy lifting that make your app, "your app".
3. Context (or State) - these are conditions that your Business Logic will take into account when executing (e.g Is user signed into app? Is the app busy doing an async action? Did an error occur on last action? e.t.c)
4. Events (e.g button tapped, push notification received, error occured and so on and so on).

A second principle is your application should be modular, and each module should maintain as single source of truth which is globally available the specific module. This source of truth forms our context.

Ok, so nothing earth shattering so far, let's look how Blocstar views these elements, and how it orchestrates their interaction.

For code examples, we'll pick snippets from the example app included with Blocstar (available in the 'example' folder in the Blocstar repository at https://github.com/rocket-libs/blocstar)

### Usage
#### 1. **Blocstar Context**
As mentioned above Blocstar applications are modular and we employ a dedicated source of truth for each module. This source of truth will contain all variables and constants that should be accessible by more than one class.
    The context is nothing more than a plain old flutter class that extends the ```BlocContextBase``` base class provided by Blocstar.
    The ```BlocContextBase``` base class is a fairly light class that provides the following behaviour:
    **1.** Tracking whether or not the module is busy performing an async action and allowing you to bake behaviour for both the busy and idle states (e.g automatically showing a progress indicator when busy, and your main UI when idle)
    **2.** Catching timed-out async actions and just like with the busy mode tracking above, you can specify what to show when an action timed-out versus when it completed in time.
    **3.** Catching errors arising from async action and yes, you also get to decide what to show when an error occurs (you also get the error information, so that's nice right?)
    **4.** A poor man's version of JavaScript's spread method to allow you to quickly and reliably mutate context without having to pass 5 million parameters to a class constructor every time you need to change one ```final``` variable.
    
***Example Blocstar Context***
```dart
class CounterContext extends BlocContextBase<CounterContext> {
  final int count;
  final String description;

  CounterContext(
      {this.count,
      this.description,
      Function(ActionState) onActionStateChanged})
      : super(onActionStateChanged);

  @override
  CounterContext merge({int newCount, String newDescription}) {
    final newModel = new CounterContext(
        count: resolveValue(count, newCount),
        description: resolveValue(description, newDescription));
    return mergeAppState(newModel);
  }
}
```
Points of note:
    **1.** It is just a simple class that extends Blocstar's ```BlocContextBase```.
    **2.** You can create you own custom variables. 
    **3.** Your custom variables should ideally be final and should be passed as named parameters in the constructor.
    **4.** *Function(ActionState) onActionStateChanged* parameter in the constructor - this is a callback function that shuttles in formation about the aforementioned  "busyness", timing out, and errors from async actions through your business logic and to your UI. All you need to do with this parameter here is pass it to the base class.
    **5.** The ```merge``` method. This is the poor man's version of JavaScript's spread. You'll still call your constructor, but you run your variables through an inbuilt static method call ```resolveValue```. Calling the above ```merge``` method will ensure that you can selectively pass only the values that need to be changed while maintaining those you don't want to change. Incidentally, the whole reason the ```BlocContextBase``` is generic, is so that the ```merge``` method's return value is can be strongly typed instead of being generic.
    
#### 2. **Business Logic**
The next step is to bring in your business logic. The business logic should be the only place where reading and writing of **Context** is done. Whenever the context is updated, your business logic class for the module should broadcast that a change occured, and your entire module can look a the new context and react to it.

***Example a Blocstar Business Logic Class***
```dart
class CounterBloc extends BlocBase<CounterContext> {
  @override
  Future initializeAsync() async {
    context = new CounterContext(
        count: 0,
        description: "Button Press Count",
        onActionStateChanged: onActionStateChangedCallback);
    sinkDefault();
  }

  buttonPressedAsync(
    int duration,
  ) async {
    final incrementedCount = await runAsync(
        function: () async => await _incrementAsync(duration),
        timeoutSeconds: 3);
    
    //Timed out calls or calls in error, return null
    if (incrementedCount != null) {
      context = context.merge(newCount: incrementedCount);
      sinkDefault();
    }
  }
}
```

Points of note:
    **1.** Your class needs to extend BlocBase
    **2.** BlocBase is a generic class that expects a type parameter of the **Context** class to use. In this excample, we we'll use the **Context** class created above. The base class being generic ensures type-safety, and all the goodness that comes with it such as fewer bugs, more readable code and of course, long time fan favourite, IDE auto-completion :)
    **3.** You are required to implement a ```initializeAsync``` method. In this method, you **must** as a first step initialize your **Context**. You may of course additionally do any other preparation you want.
    **4.** ```onActionStateChanged: onActionStateChangedCallback``` - When instantiating our **Context** we pass a method called ```onActionStateChangedCallback``` to parameter ```onActionStateChanged```. The ```onActionStateChangedCallback``` is already implemented in ```BlocBase``` which allows Blocstar to automatically catch results of async methods, and update the **Context** for you.
    **5.** The ```sinkDefault()``` calls. ```sinkDefault``` is implemented in the ```BlocBase``` and it abstracts the broadcasting of changes to **Context**. Always call this after your **Context** changes, otherwise the rest of your module won't know anything changed.
