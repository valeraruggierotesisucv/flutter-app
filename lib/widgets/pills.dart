import 'package:eventify/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:eventify/models/locale.dart';
import 'package:provider/provider.dart';

class Category {
  final String id;
  final String label;

  const Category({required this.id, required this.label});
}

class Pills extends StatefulWidget {
  final List<CategoryModel> categories;
  final Function(List<int>)? onSelectCategories;
  final List<int> selectedCategories;
  final String? language;

  const Pills({
    super.key,
    required this.categories,
    this.onSelectCategories,
    this.selectedCategories = const [],
    this.language = 'en',
  });

  @override
  State<Pills> createState() => _PillsState();
}

class _PillsState extends State<Pills> {
  late List<int> selected;


  @override
  void initState() {
    super.initState();
    selected = List.from(widget.selectedCategories);
  }

  void handlePress(int categoryId) {
    setState(() {
      if (selected.contains(categoryId)) {
        selected.remove(categoryId);
      } else {
        selected.add(categoryId);
      }
    });
    widget.onSelectCategories?.call(selected);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    LocaleModel localeModel = Provider.of<LocaleModel>(context, listen: false);
    

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: widget.categories.map((category) {
            final isSelected = selected.contains(category.id);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ElevatedButton(
                onPressed: () => handlePress(category.id),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  backgroundColor: isSelected ? const Color(0xFF050F71) : Colors.white,
                  foregroundColor: isSelected ? Colors.white : Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF050F71) : const Color(0xFFE0E0E0),
                    ),
                  ),
                  minimumSize: const Size(0, 40),
                ),
                child: Text(
                  widget.language == 'en' ? category.nameEn : category.nameEs,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),

              ),
            );
          }).toList(),
        ),
      ),
    );
  }
} 