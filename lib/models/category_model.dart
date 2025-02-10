class CategoryModel {
  int id;
  String nameEs;
  String nameEn;
  String description;

  CategoryModel({
    required this.id,
    required this.nameEs,
    required this.nameEn,
    required this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      nameEs: json['name_es'],
      nameEn: json['name_en'],
      description: json['description'],
    );
  }
}