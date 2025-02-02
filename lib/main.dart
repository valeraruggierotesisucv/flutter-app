import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/custom_input.dart';
import 'package:eventify/widgets/icon_logo.dart';
import 'package:flutter/material.dart';
import 'widgets/custom_search_bar.dart';
import 'widgets/category_button.dart';
import 'widgets/tabs.dart';
import 'widgets/input_field.dart';

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
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  String _searchValue = '';
  String _selectedCategory = '';
  TextEditingController _controller = TextEditingController();

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

  void _handleSearch(String value) {
    setState(() {
      _searchValue = value;
    });
    print('Search value from main: $_searchValue');
  }

  void _handleCategoryPress(String category) {
    setState((){
      _selectedCategory = category;
    });
    print('Category pressed: $category');
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppHeader(title: 'Eventify', goBack: () => print('Back button pressed')),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: <Widget>[
            IconLogo(width: 300, height: 300),
            // Default Input with placeholder and required
            CustomInput(
              label: 'Search',
              placeholder: 'Search for an event',
              variant: InputVariant.defaultInput,
              required: true,
              value: _searchValue,
              onChangeValue: _handleSearch,
            ),
            
            const SizedBox(height: 20),
          
            // Arrow variant with placeholder
            CustomInput(
              label: 'Category',
              placeholder: 'Select a category',
              variant: InputVariant.arrow,
              required: false,
              onPress: () => print('Category pressed'),
            ),
            
            const SizedBox(height: 20),
            
            // Optional field (not required)
            CustomInput(
              label: 'Description',
              placeholder: 'Enter event description',
              variant: InputVariant.defaultInput,
              required: false,
              onChangeValue: (value) => print(value),
            ),
            
            const SizedBox(height: 20),
            
            // Multiline disabled
            CustomInput(
              label: 'Location',
              placeholder: 'Enter event location',
              variant: InputVariant.defaultInput,
              multiline: false,
              onChangeValue: (value) => print(value),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
