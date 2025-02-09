import 'package:eventify/view_models/search_view_model.dart';
import 'package:eventify/widgets/custom_search_bar.dart';
import 'package:eventify/widgets/pills.dart';
import 'package:eventify/widgets/tabs.dart';
import 'package:flutter/material.dart';
import 'package:eventify/routes.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/event_card.dart';
import 'package:eventify/widgets/loading.dart';
import 'package:eventify/widgets/user_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchView extends StatefulWidget {
  final SearchViewModel viewModel;
  const SearchView({super.key, required this.viewModel});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  bool _isLoading = false;
  int selectedTab = 1;
  String query = '';


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

  
  @override
  void initState() {
    super.initState();
    widget.viewModel.searchEvents.addListener(_onSearch);
    widget.viewModel.searchUsers.addListener(_onSearch);
  }

  @override
  void didUpdateWidget(covariant SearchView oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.searchEvents.removeListener(_onSearch);
    oldWidget.viewModel.searchUsers.removeListener(_onSearch);
    widget.viewModel.searchEvents.addListener(_onSearch);
    widget.viewModel.searchUsers.addListener(_onSearch);
  }

  @override
  void dispose( ) {
    _searchController.dispose();
    widget.viewModel.searchEvents.removeListener(_onSearch);
    widget.viewModel.searchUsers.removeListener(_onSearch);
    super.dispose();
  }

  void _performSearch(String query) {
    
    setState(() {
      this.query = query;
    });
    switch (selectedTab) {
      case 1:
        widget.viewModel.searchEvents.execute(query);
        break;
      case 2:
        widget.viewModel.searchUsers.execute(query);
        break;
    }
  }
  final tabs = [
    TabItem(id: 1, title: 'Eventos'),
    TabItem(id: 2, title: 'Usuarios'),
  ];
  
  void onTabTap(int id) {
    setState(() {
      selectedTab = id;
    });
    widget.viewModel.searchUsers.execute(query);
  }
  

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
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
                ? Column(  
                    
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
                        : ListenableBuilder(
                            listenable: widget.viewModel.searchEvents,
                            builder: (context, child) {
                              if (widget.viewModel.searchEvents.running) {
                                return Loading();
                              }
                              
                              if (query.isEmpty) {
                                return Center(
                                  child: Text(
                                    t.searchViewInitialEvents,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              }

                              if(widget.viewModel.events.isEmpty) {
                                return Center(child: Text(t.searchViewNoEvents));
                              }
                              return Column(
                                children: widget.viewModel.events.map((event) => EventCard(
                                  eventId: event.eventId,
                                  profileImage: event.profileImage,
                                  username: event.username,
                                  eventImage: event.eventImage,
                                  title: event.title,
                                  description: event.description,
                                  isLiked: event.isLiked,
                                  date: event.date,
                                  userComment: {},
                                  onPressUser: () {},
                                  onComment: (eventId, comment) async {
                                    print(eventId);
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
                : ListenableBuilder(  // Users tab content
                    listenable: widget.viewModel.searchUsers,
                    builder: (context, child) {
                      if (widget.viewModel.searchUsers.running) {
                        return Loading();
                      }

                      if (query.isEmpty) {
                        return Center(
                            child: Text(
                              t.searchViewInitialUsers,
                              style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      } 

                      if(widget.viewModel.users.isEmpty) {
                        return Center(child: Text(t.searchViewNoUsers));
                      }

                      return Column(
                        spacing: 10,
                        children: widget.viewModel.users.map((user) => UserCard(
                          username: user.username,
                          profileImage: user.profileImage,
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

  void _onSearch() {
    
  }
}
