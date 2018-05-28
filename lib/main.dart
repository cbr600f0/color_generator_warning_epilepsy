import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'models/Goal.dart';
import 'providers/GoalProvider.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

_MyAppState() {
  this.initialize();
}

  bool hasLoaded = false;

  Future initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "demo.db");

    Database database = await openDatabase(
      path, 
      version: 1,
      onCreate: _databaseOnCreate
    );

    final goalProvider = new GoalProvider(database);
    final goal = new Goal();
    goal.name = "Je dikke moeder";
    await goalProvider.insert(goal);
    setState(() {hasLoaded = true;});
  }

  _databaseOnCreate (Database db, int version) async {
    // When creating the db, create the table
    await db.execute("CREATE TABLE goal (id INTEGER PRIMARY KEY, name TEXT)");
    await db.execute("""
      CREATE TABLE task (
        id INTEGER PRIMARY KEY, 
        goal_id INTEGER, 
        name TEXT, 
        description TEXT, 
        done INTEGER,
        FOREIGN KEY (goal_id) REFERENCES goal(id)
      )
    """);
  }

  // This widget is the root of your application.
  @override 
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'School planner',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: hasLoaded ? new MyHomePage(title: 'Goals main page') : new Text("is loading"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Color> colorList = [Colors.black, Colors.purpleAccent, Colors.pink, Colors.amberAccent, Colors.lightBlue, Colors.lightBlueAccent, Colors.white, Colors.brown, Colors.pinkAccent, Colors.red];
  Random random = new Random();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return new Container(
              decoration: new BoxDecoration(color: colorList[random.nextInt(colorList.length)]),
              child: new Padding(
                  padding: new EdgeInsets.symmetric(vertical: 40.0),
                  child: new Text('Random colour',
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                        color: Colors.red,
                        fontSize: 40.0,
                      ))));
        },
        itemCount: _counter,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}