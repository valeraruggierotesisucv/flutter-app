import 'package:eventify/widgets/custom_search_bar.dart';
import 'package:eventify/widgets/pills.dart';
import 'package:eventify/widgets/tabs.dart';
import 'package:flutter/material.dart';
import 'package:eventify/routes.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/event_card.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:eventify/widgets/user_card.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  bool _isLoading = false;
  int selectedTab = 1;


  Future<List<Category>> fetchCategories() async {
    return [
      Category(id: '1', label: 'Fiesta'),
      Category(id: '2', label: 'Concierto'),
      Category(id: '3', label: 'Deporte'),
      Category(id: '4', label: 'Cultura'),
      Category(id: '5', label: 'Fiesta'),
      Category(id: '6', label: 'Concierto'),
      Category(id: '7', label: 'Deporte'),
      Category(id: '8', label: 'Cultura'),
    ];
  }

  Future<List<dynamic>> fetchUsers() async {
    return [
      {
        'id': '1',
        'name': 'Usuario 1',
        'image': 'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg',
      },
      {
        'id': '2',
        'name': 'Usuario 2',
        'image': 'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg',
      },
    ];
  }

  Future<List<dynamic>> fetchEvents() async {
    // Add artificial delay of 2 seconds
    await Future.delayed(const Duration(seconds: 8));

    return [
      {
        'id': '1',
        'title': 'Evento 1',
        'description': 'Descripción del evento 1',
        'image':
            'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg',
        'location': 'Ciudad, País',
        'date': DateTime.now(),
      },
      {
        'id': '2',
        'title': 'Evento 2',
        'description': 'Descripción del evento 2',
        'image':
            'https://theglobalfilipinomagazine.com/wp-content/uploads/2024/03/white-bg-97.jpg',
        'location': 'Ciudad, País',
        'date': DateTime.now(),
      },
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _isLoading = true;
    });

    // Simulando una búsqueda con datos de ejemplo
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _searchResults = [
          'Resultado 1: $query',
          'Resultado 2: $query',
          'Resultado 3: $query',
          'Resultado 4: $query',
          'Resultado 5: $query',
        ];
        _isLoading = false;
      });
    });
  }
  final tabs = [
    TabItem(id: 1, title: 'Eventos'),
    TabItem(id: 2, title: 'Usuarios'),
  ];
  
  void onTabTap(int id) {
    setState(() {
      selectedTab = id;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                CustomSearchBar(
                  onSearch: _performSearch,
                ),
                const SizedBox(height: 16),
                Tabs(tabs: tabs, onTabTap: onTabTap),
                const SizedBox(height: 16),
                
                selectedTab == 1
                ? Column(  // Events tab content
                    children: [
                      Container(
                        child: FutureBuilder(
                          future: fetchCategories(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const SizedBox();
                            return Pills(
                              categories: snapshot.data!.map((category) => category).toList()
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _isLoading 
                        ? const Center(child: CircularProgressIndicator())
                        : FutureBuilder(
                            future: fetchEvents(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(child: Loading());
                              }
                              return Column(
                                children: snapshot.data!.map((event) => EventCard(
                                  eventId: event['id'],
                                  profileImage: event['image'],
                                  username: 'Usuario 1',
                                  eventImage: event['image'],
                                  title: event['title'],
                                  description: 'Descripción del evento 1',
                                  isLiked: false,
                                  date: '2024-01-01',
                                  userComment: {},
                                  onPressUser: () {},
                                  onComment: (eventId, comment) async {
                                    print(eventId);
                                    print(comment);
                                  },
                                  onMoreDetails: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/${AppScreens.eventDetails.name}',
                                    );
                                  },
                                  onShare: () {},
                                  fetchComments: () async => [],
                                  handleLike: () {},
                                )).toList(),
                              );
                            },
                          ),
                    ],
                  )
                : FutureBuilder(  // Users tab content
                    future: fetchUsers(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Center(child: Loading());
                      return Column(
                        children: snapshot.data!.map((user) => UserCard(
                          username: user['name'],
                          profileImage: user['image'],
                          onPressUser: () {
                          },
                          variant: UserCardVariant.withButton,
                          onPressButton: () {},
                        )).toList(),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
