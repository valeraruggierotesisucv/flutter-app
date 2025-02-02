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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults.clear();
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                if (value.length > 2) {
                  _performSearch(value);
                }
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _searchResults.isEmpty
                    ? const Center(
                        child: Text('No hay resultados'),
                      )
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.article),
                            title: Text(_searchResults[index]),
                            onTap: () {
                              // TODO: Implementar acción al seleccionar un resultado
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
