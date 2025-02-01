import 'package:flutter/material.dart';
import 'widgets/custom_search_bar.dart';
import 'widgets/category_button.dart';
import 'widgets/tabs.dart';
import 'widgets/input_field.dart';
import 'widgets/profile_card.dart';
import 'widgets/custom_button.dart';
import 'widgets/user_card.dart';

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
    debugPrint('Search value from main: $_searchValue');
  }

  void _handleCategoryPress(String category) {
    setState(() {
      _selectedCategory = category;
    });
    debugPrint('Category pressed: $category');
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
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomSearchBar(
                onSearch: _handleSearch,
              ),
              const SizedBox(height: 20),
              ProfileCard(
                username: 'John Doe',
                biography: 'Flutter Developer',
                events: 10,
                followers: 150,
                following: 120,
                isFollowing: false,
                onFollow: () {
                  debugPrint('Follow pressed');
                },
                onEditProfile: () {
                  debugPrint('Edit profile pressed');
                },
                onEvents: () {
                  debugPrint('Events pressed');
                },
                onFollowers: () {
                  debugPrint('Followers pressed');
                },
                onFollowed: () {
                  debugPrint('Following pressed');
                },
              ),
              const SizedBox(height: 20),
              UserCard(
                username: 'John Doe',
                profileImage:
                    'https://avatars.githubusercontent.com/u/82007072',
                onPressUser: () {
                  debugPrint('User pressed');
                },
                onPressButton: () {
                  debugPrint('Button pressed');
                },
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              CustomButton(
                label: 'Button',
                onPress: () {
                  debugPrint('Button pressed');
                },
              ),
              const SizedBox(height: 20),
              CategoryButton(
                onPress: _handleCategoryPress,
                category: 'Category 1',
                icon: Icons.camera_alt,
              ),
              Tabs(
                tabs: [
                  TabItem(id: 1, title: 'Tab 1'),
                  TabItem(id: 2, title: 'Tab 2'),
                  TabItem(id: 3, title: 'Tab 3'),
                ],
                onTabTap: (index) {
                  debugPrint('Tab ${index} tapped');
                },
              ),
              InputField(
                label: 'Label',
                hint: 'Hint',
                controller: _controller,
                error: '',
                onChanged: (value) {
                  debugPrint('Value changed: $value');
                },
                onIconTap: () {
                  debugPrint('Icon tapped');
                },
                icon: Icons.calendar_today,
              ),
              Text('Current search: $_searchValue'),
            ],
          ),
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
