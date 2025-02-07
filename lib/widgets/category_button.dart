import 'package:flutter/material.dart';

class CategoryButton extends StatefulWidget {
  final Function(String, String) onPress;
  final String category;
  final IconData icon;
  final String categoryId;

  const CategoryButton({
    super.key,
    required this.onPress,
    required this.category,
    required this.icon,
    required this.categoryId,
  });

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 7,
      children: [
      Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF050F71) : Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: Color(0xFF050F71), width: 2),
        ),
        child: IconButton(onPressed: () => {
          setState(() {
            isSelected = !isSelected;
          }),
          widget.onPress(widget.category, widget.categoryId)
        }, icon: Icon(widget.icon, color: isSelected ? Colors.white : Color(0xFF050F71), size: 50,)),
      ),
      Text(widget.category, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
    ],);
  }
}