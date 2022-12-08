import 'package:ring_button_group/ring_button_group.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Ring Button Group'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String displayName = "Test";

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: SizedBox(
                width: 200,
                height: 200,
                child: RingButtonGroup(
                  buttonNumber: 5,
                  icons: const [
                    Icon(Icons.abc, color: Colors.white,),
                    Icon(Icons.baby_changing_station, color: Colors.white,),
                    Icon(Icons.cabin, color: Colors.white,),
                    Icon(Icons.dangerous, color: Colors.white,),
                    Icon(Icons.e_mobiledata, color: Colors.white,),
                  ],
                  type: RingButtonGroupType.MULTIPLE_SELECTABLE,
                  pressedIndex: const {1},
                  shadowEffect: true,
                  onPressed: (index, selected) {  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: SizedBox(
                width: 200,
                height: 200,
                child: RingButtonGroup(
                  disabled: true,
                  buttonNumber: 6,
                  buttonSize: 60,
                  labels: const [
                    Text("I"),
                    Text("II"),
                    Text("III"),
                    Text("IV"),
                    Text("V"),
                    Text("VI"),
                  ],
                  type: RingButtonGroupType.SINGLE_SELECTABLE,
                  pressedIndex: const {1},
                  onPressed: (index, selected) {  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: SizedBox(
                width: 200,
                height: 220,
                child: RingButtonGroup(
                  buttonNumber: 6,
                  buttonSize: 50,
                  toneColor: Colors.deepOrange,
                  borderColor: Colors.orange,
                  activeColor: Colors.deepOrange.shade200,
                  tintColor: Colors.deepOrange.shade400,
                  labels: const [
                    Text("1", style: TextStyle(color: Colors.white),),
                    Text("2", style: TextStyle(color: Colors.white),),
                    Text("3", style: TextStyle(color: Colors.white),),
                    Text("4", style: TextStyle(color: Colors.white),),
                    Text("5", style: TextStyle(color: Colors.white),),
                    Text("6", style: TextStyle(color: Colors.white),),
                  ],
                  type: RingButtonGroupType.SINGLE_SELECTABLE,
                  // pressedIndex: {},
                  onPressed: (index, selected) {
                    setState(() {
                      displayName = "Test $index";
                    });
                  },
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: const [BoxShadow(blurStyle: BlurStyle.outer, color: Colors.black12, blurRadius: 5)],
                      ),
                      width: 80,
                      height: 80,
                      child: Center(child: Text(displayName))
                      ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
