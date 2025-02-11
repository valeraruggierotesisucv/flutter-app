import 'package:eventify/data/services/api_client.dart';
import 'package:eventify/models/category_model.dart';
import 'package:eventify/utils/result.dart';

class CategoryRepository {
  final ApiClient _apiClient;

  CategoryRepository(this._apiClient);
  List<CategoryModel>? _cachedCategories;

  Future<Result<List<CategoryModel>>> getCategories() async {
    if (_cachedCategories == null) {
      final result = await _apiClient.getCategories();
      if (result is Ok<List<CategoryModel>>) {
        _cachedCategories = result.value;
      }
      return result;
    } else {
      return Result.ok(_cachedCategories!);
    }
  }


}