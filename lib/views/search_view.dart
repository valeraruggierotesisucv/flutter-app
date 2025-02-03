import 'package:eventify/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  bool _isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Búsqueda'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomButton(
                label: "Event Details",
                onPress: () =>
                    {Navigator.pushReplacementNamed(context, '/home')},
              )
            ],
          ),
        ));
  }
}
