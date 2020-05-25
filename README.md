# blocstar

Bloc based nano framework, that helps structure how your flutter code is laid out and written.

## Why?
A couples of reasons
1. State Management - While State Management is supported out of the box in Flutter, it encourages pollution of the UI with business logic. This is bad and makes testing hard. Thankfully Flutter also comes with excellent support for Streams, out of which the BLoC pattern was born.
2. Enforcing Structure - While BLoC allows us to move business logic out of widgets, it does not impose and opinions on how your code should be laid out. As with everything, there are pros and cons with this freedom, but an overwhelming con is that it invites variety in your code, which later on imposes a huge open to cognitive load while trying to read BLoCs that were written inconsistently. And obviously the problem becomes compounded when the code is written by a team rather than a single individual, and you end up with a larger variation in your codebase.

## Blocstar's Aspirations 
1. A rock-solid, light and easy to learn library. Pick it up, test drive it and see if it'll work for you, all in under a half hour.
2. Minimal boilerplate - focus on your code, not on rituals aka boilerplate, leaving your code lean and clean enough, that you come back, and are able to easily understand the code a couple of weeks/months/years/(decades?) later.

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

A second principle is that your application should be modular, and each module should maintain a single source of truth which is globally available in that specific module. This source of truth forms our context. Going forward, the word module shall be used to mean the collection of widgets and other files that perform a very specific function in your application. An examples of a module would be ***user registration*** while  ***sign in*** would be a second one.

Ok, so nothing earth shattering so far, let's look how Blocstar views these elements, and how it orchestrates their interaction.

For code examples, we'll pick snippets from the example app included with Blocstar (available in the 'example' folder in the Blocstar repository at https://github.com/rocket-libs/blocstar)

### Usage
#### 1. **Blocstar Context**
As mentioned above Blocstar applications are modular and we employ a dedicated source of truth for each module. This source of truth will contain all variables and constants that should be accessible by more than one class in the module.
    The context is nothing more than a plain old flutter class that extends the ```BlocstarContextBase``` base class provided by Blocstar.
    The ```BlocstarContextBase``` base class is a fairly light class that provides the following behaviour:
    
**1.** Tracking whether or not the module is busy performing an async action and allowing you to bake behaviour for both the busy and idle states (e.g automatically showing a progress indicator when busy, and your main UI when idle)
    
**2.** Catching timed-out async actions and just like with the busy mode tracking above, you can specify what to show, when an action timed-out versus when it completed in time.
    
**3.** Catching errors arising from async action and yes, you also get to decide what to show when an error occurs (you also get the error information, so that's nice right?)
    
**4.** A poor man's version of JavaScript's spread method to allow you to quickly and reliably mutate context without having to pass 5 million parameters to a class constructor every time you need to change one ```final``` variable.
    
***Example Blocstar Context***
```dart
class CounterContext extends BlocstarContextBase<CounterContext> {
  final int count;
  final String description;

  CounterContext(BlocstarContextBase<BlocstarContextBase<CounterContext>> logic, {this.count, this.description}) : super(logic);

  

  @override
  merge({int newCount, String newDescription}) {
    new CounterContext(logic,
        count: resolveValue(count, newCount),
        description: resolveValue(description, newDescription));
  }
}
```

Points of note:
    
**1.** It is just a simple class that extends Blocstar's ```BlocstarContextBase```.
    
**2.** You can create you own custom variables.
 
**3.** Your custom variables should ideally be final and should be passed as named parameters in the constructor.

**4.** ```BlocstarContextBase<BlocstarContextBase<CounterContext>> logic``` parameter in the constructor - this is an instance of the object that handles our business logic. Supplying it to the context like this allows Blocstar to automatically handle broadcasting of changes in context to the rest of the module.

**5.** The ```merge``` method. This is the poor man's version of JavaScript's spread. You can selectively pass either all or just some of the parameters. In the method, all you have to do is create a new instance of you context class, ensuring that when passing values to parameters, you run them through Blocstar's  ```resolveValue``` method, which figures out whether to use the already existing value for variable, or to overwrite it with a newly supplied value. Because of the ```logic``` object we pass in the constructor of contexts, simply creating a new instance of your class triggers a broadcast of change in context, and the rest of your module now knows to evaluate the update context, and react accordingly.
    
#### 2. **Business Logic**
The next step is to bring in your business logic. The business logic should be the only place where reading and writing of **Context** is done. Whenever the context is updated, your business logic class for the module should broadcast that a change occured, and your entire module can look a the new context and react to it.

***Example a Blocstar Business Logic Class***
```dart
class CounterBloc extends BlocstarContextBase<CounterContext> {
  @override
  Future initializeAsync() async {
    context = new CounterContext(this,
        count: 0, description: "Button Press Count");
  }

  buttonPressedAsync(
    int duration,
  ) async {
    final incrementedCount = await runAsync(
        function: () async => await _incrementAsync(duration),
        timeoutSeconds: 3);

    //Timed out calls or calls in error, return null
    if (incrementedCount != null) {
      context.merge(newCount: incrementedCount);
    }
  }

  /// This method emulates an a async operation by instituting an delay of a user specified number of seconds before it does the increment.
  /// It allows us to see how Blocstar handles async calls.
  Future<int> _incrementAsync(int duration) async {
    final incrementedCount =
        await Future.delayed(new Duration(seconds: duration), () {
      return context.count + 1;
    });
    return incrementedCount;
  }
}
```

Points of note:
    
**1.** Your business logic class needs to extend BlocstarContextBase,
    
**2.** BlocstarContextBase is a generic class that expects a type parameter of the **Context** class to use. In this excample, we we'll use the **Context** class created previously. The base class being generic ensures type-safety, and all the goodness that comes with it such as fewer bugs, more readable code and of course, long time fan favourite, IDE auto-completion :)
    
**3.** You are required to implement a ```initializeAsync``` method. In this method, you **must** as a first step initialize your **Context**. You may of course additionally do any other preparation you want.
    
**4.** When instantiating our **Context**, the business logic class passes an instance of itself into the context, as mentioned above, this instance allows Blocstar to broadcast context changes to the rest of the module.

**5.** The ```BlocstarContextBase``` base class supplies us with a object called ***context***. This is an instance of the object we create as our **Context** above. In it we'll find whatever public variables and/or methods we declared. In addition, the *context* object also contains the ```merge``` method.

**6.** Calls to async methods are wrapped in Blocstar's ```runAsync``` method. This method takes in two parameters; the first being the async method to call, and the second being the duration in second s before the method is deemed to have timed out. The ```runAsync``` method returns null if either a timeout or an error occurs when running the async method. 
**Important**: on either the occurence of a timeout or an error, the context is updated with the occurence and a broadcast is sent out automatically. In the next section, we'll see how to handle these broadcasts in the UI. Lastly, the ```runAsync``` method returns the value of the async method passed into it, if it completed successfully. This value can be fed into the ```merge``` method to update the context.

**7.** The ```merge``` method allows us to update the context by selectively passing in one or more values to overwrite the context. If you setup the context as shown above, then calling the ```merge``` method not only updates your context, but will also broadcast the change to the rest of your module. 

#### 3. **User Interface**
This is where we bring it all together. A key principle of Blocstar, is a modular approach to building functionality. As such, Blocstar will expect the business logic class we built in step 2 above to be bound to exactly one widget, then it is this master widget's responsibility to host the rest of the UI. This allows us to provide a single connection point between your user interface and the business logic and module's context.

```dart
class Counter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _CounterState();
  }
}

class _CounterState extends BlocstarState<Counter, CounterBloc> {
    @override
  Widget rootWidget() {
    return Scaffold(
        appBar: AppBar(
          title: Text("Blocstar Counter Example"),
        ),
        body: _body);
    }
    
    Widget get _body {
        if (logic.initialized == false) {
          logic.initializeAsync();
          return Text("Initializing");
        } else {
            if (logic.context.actionState.busy) {
                return Text("Working. Please Wait");
            } elseif (logic.context.actionState.lastActionTimedOut) {
                return Text("Last Action Timed Out");
            } else if (logic.context.actionState.errorOccuredOnLastAction) {
                return Text("Last Action Failed");
            } else {
                return Text("Count Is ${logic.context.count.toString()}"");
            }
        }
    }
}
```

Let's break it down:

**1.** A StatefulWidget is required.

**2.** The widget's state needs to extend ```BlocstarState``` which takes two type parameters. The first being of the StatefulWidget and the second being the type of the business logic class.

**3.** Bind the Widget's state to the business logic by implementing ```BlocstarState```'s abstract method ```rootWidget```. This let's Blocstar know what widget to bind to. There are no special requirements for the widget to return; you may return any widget you please.

**4.** After performing the bind in the previous step, we use the getter ```_body``` to show how we can control what our UI displays, we do this by interrogating the ```logic``` variable (which is an instance of your business logic class) or the ```logic.context``` object (which is an instance of your context class). There are six possible states that we are interested in.

- ```logic.initialized == false``` - this is usually when your widget has first loaded and we need to bootstrap our module. Call ```logic.initializeAsync()``` (synchronously) then show a widget to let the use know what is happening.
- ```logic.context.actionState.busy == true``` - this indicates that your module is busy executing an async operation (e.g an http call). You probably want to show the user a progress indication widget here.
- ```logic.context.actionState.lastActionTimedOut == true``` - the module is no longer busy, but your async operation timed out. This allows you to bake important functionality into your app, like analytics, user driven retries e.t.c
- ```logic.context.actionState.errorOccuredOnLastAction == true``` - the module is no longer busy, but the operation failed with an error. The details of the error are available in ```logic.context.actionState.lastActionException```. Again, just like above you get an access point in your module where you can track performance of your app and gracefully handle non-happy-paths. Additionally, this allows you to standardize error handling, making for an easy to learn codebase.
- All of the above states are false. This indicates that the module is on the happy-path.



## Testing
### Basic Testing
Clone the repo and run ```flutter test```
### Testing With Coverage Information (Linux only)
1. Ensure you have lcov installed and setup on your system (http://ltp.sourceforge.net/coverage/lcov.php).
2. Ensure the run-tests script in the project root is executable (```chmod +x ./run-tests.sh```).
3. Execute the run-tests script in the project root ```./run-tests.sh```.
4. Navigate into directory ./coverage/html/ (relative to project root). 
5. Open index.html to view coverage information.

### Coverage Information On Other Systems
It is unlikely that I'll be porting the run-tests.sh script to other systems, my reason mostly being that I don't frequently use any other OS and would not want to pick a sub-optimal tool for coverage generation (also laziness probably is a factor).

Anyhow, it should be fairly straight-forward to do the porting if you so wish.

The run-tests.sh consists of all of two lines:
1. flutter test --coverage
1. genhtml ./coverage/lcov.info  -o ./coverage/html

The first line is platform independent and generates the file ./coverage/lcov.info (again relative to project root).
On Linux, we can consume the coverage info contained in this file via the lcov tool. On Windows and other
platforms, there exists also tools that would be able to similarly consume the coverage information and produce human friendly
output.

In essense, port the script to desired platform by
1. Keeping the first line 'as is'.
1. Finding a tool to process the ./coverage/lcov.info file.
1. Profit!