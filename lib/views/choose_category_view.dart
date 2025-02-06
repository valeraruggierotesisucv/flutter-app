import 'package:eventify/views/add_view.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/category_button.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ChooseCategoriesView extends StatelessWidget {
  final Function(StepsEnum) onStepChanged;
  final Function(String, String) onCategoryChanged;
  final Function(String) onCategoryIdChanged;

  const ChooseCategoriesView({
    super.key,
    required this.onCategoryChanged,
    required this.onCategoryIdChanged,
    required this.onStepChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'id': 1, 'label': 'culture', 'icon': Icons.palette},
      {'id': 2, 'label': 'education', 'icon': Icons.book},
      {'id': 3, 'label': 'parties', 'icon': Icons.party_mode},
      {'id': 4, 'label': 'concerts', 'icon': Icons.music_note},
      {'id': 5, 'label': 'festivals', 'icon': Icons.bookmark},
      {'id': 6, 'label': 'sports', 'icon': Icons.sports},
      {'id': 7, 'label': 'theater', 'icon': Icons.theater_comedy},
      {'id': 8, 'label': 'exhibitions', 'icon': Icons.image},
      {'id': 9, 'label': 'clubs', 'icon': Icons.group},
    ];

    return Scaffold(
      appBar: AppHeader(title: "Categoría", goBack: () { onStepChanged(StepsEnum.defaultStep);}),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final categoryData = categories[index];
                  return CategoryButton(
                    category: categoryData['label'] as String,
                    icon: categoryData['icon'] as IconData,
                    categoryId: categoryData['id'].toString(),
                    onPress: (id, label) {
                      onCategoryChanged(id, label);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Align(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CustomButton(
                label:
                    "Siguiente", // Cambia esto por la traducción correspondiente
                onPress: () {
                  onStepChanged(
                      StepsEnum.defaultStep); // Llama al callback
                },
              ),
            ),
          )
          ],
        ),
      ),
    );
  }
}
