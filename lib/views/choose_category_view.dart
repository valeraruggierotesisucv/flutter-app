import 'package:eventify/views/add_event_view.dart';
import 'package:eventify/widgets/app_header.dart';
import 'package:eventify/widgets/category_button.dart';
import 'package:eventify/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseCategoriesView extends StatelessWidget {
  final Function(StepsEnum) onStepChanged;
  final Function(int, String) onCategoryChanged;

  const ChooseCategoriesView({
    super.key,
    required this.onCategoryChanged,
    required this.onStepChanged,
  });

  String _getCategoryName(BuildContext context, String categoryKey) {
    final t = AppLocalizations.of(context)!;
    switch (categoryKey) {
      case 'culture': return t.categoryNameCulture;
      case 'education': return t.categoryNameEducation;
      case 'parties': return t.categoryNameParties;
      case 'concerts': return t.categoryNameConcerts;
      case 'festivals': return t.categoryNameFestivals;
      case 'sports': return t.categoryNameSports;
      case 'theater': return t.categoryNameTheater;
      case 'exhibitions': return t.categoryNameExhibitions;
      case 'clubs': return t.categoryNameClubs;
      default: return categoryKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    final categories = [
      {'id': 1, 'key': 'culture', 'icon': Icons.palette},
      {'id': 2, 'key': 'education', 'icon': Icons.book},
      {'id': 3, 'key': 'parties', 'icon': Icons.party_mode},
      {'id': 4, 'key': 'concerts', 'icon': Icons.music_note},
      {'id': 5, 'key': 'festivals', 'icon': Icons.bookmark},
      {'id': 6, 'key': 'sports', 'icon': Icons.sports},
      {'id': 7, 'key': 'theater', 'icon': Icons.theater_comedy},
      {'id': 8, 'key': 'exhibitions', 'icon': Icons.image},
      {'id': 9, 'key': 'clubs', 'icon': Icons.group},
    ];

    return Scaffold(
      appBar: AppHeader(
        title: t.chooseCategoryTitle, 
        goBack: () { 
          onStepChanged(StepsEnum.defaultStep);
        }
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 20,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final categoryData = categories[index];
                  return CategoryButton(
                    category: _getCategoryName(context, categoryData['key'] as String),
                    icon: categoryData['icon'] as IconData,
                    categoryId: categoryData['id'] as int,
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
                  label: t.chooseCategoryNext,
                  onPress: () {
                    onStepChanged(StepsEnum.defaultStep);
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
