
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/custom_input.dart';
import 'package:eventify/widgets/icon_logo.dart';

import 'package:flutter/material.dart';

import 'widgets/comments_section.dart';

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
  bool _isLoading = true;

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

  Future<void> onComment(String eventId, String comment) async {
    // Implementar lógica para manejar comentarios
    debugPrint('Nuevo comentario en evento $eventId: $comment');
  }

  Future<List<Comment>> fetchComments() async {
    // Simular obtención de comentarios
    return [
      Comment(
        username: "Usuario1",
        comment: "¡Gran evento!",
        profileImage: "https://avatars.githubusercontent.com/u/1",
        timestamp: DateTime.now(),
      ),
      Comment(
        username: "Usuario2",
        comment: "¡No puedo esperar!",
        profileImage: "https://avatars.githubusercontent.com/u/2",
        timestamp: DateTime.now(),
      ),
    ];
  }

  void handleLike() {
    debugPrint('Like presionado');
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
            Text("Hello"),
            ElevatedButton(
              onPressed: () => showCommentsModal(
                context, 
                [
                  Comment(
                    username: "starryskies23", 
                    timeAgo: DateTime.now(), 
                    message: "This is a comment! 😄"
                  ),
                ],
                User(username: "starryskies23", imageUrl: "https://m.media-amazon.com/images/S/pv-target-images/16627900db04b76fae3b64266ca161511422059cd24062fb5d900971003a0b70._SX1080_FMjpg_.jpg"),
                (comment) async {
                  await Future.delayed(const Duration(seconds: 1));
                  print("Comment submitted: ${comment.message}");
                  return comment;
                }
              ),
              child: Text("Show Comments")
            )
          ],
        ),
      ),
    );
  }
}
