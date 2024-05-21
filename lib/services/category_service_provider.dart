import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/utils/api_client.dart';

final categoryServiceProvider = Provider((ref) => CategoryService(ref));

abstract class CategoryRepository {
  Future<Response> getCategories({
    required String? search,
    required int? perPage,
    required int? page,
  });
  Future<Response> getParentCategory();
  Future<Response> addCategory({
    required String categoryName,
    required int? parentCategoryId,
    required File? categoryImage,
  });
  Future<Response> updateCategory({
    required int categoryId,
    required String categoryName,
    required int? parentCategoryId,
    required File? categoryImage,
  });
  Future<Response> deleteCategory({required int id});
}

class CategoryService implements CategoryRepository {
  final Ref ref;
  CategoryService(this.ref);
  @override
  Future<Response> getCategories({
    required String? search,
    required int? perPage,
    required int? page,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (search != null) queryParams['search'] = search;
    queryParams['page'] = page;
    queryParams['per_page'] = perPage;

    if (search != null) {}
    final response = await ref.read(apiClientProvider).get(
          AppConstants.categories,
          query: queryParams,
        );
    return response;
  }

  @override
  Future<Response> getParentCategory() async {
    final response =
        await ref.read(apiClientProvider).get(AppConstants.parentCategory);
    return response;
  }

  @override
  Future<Response> addCategory({
    required String categoryName,
    required int? parentCategoryId,
    required File? categoryImage,
  }) async {
    final response = await ref.read(apiClientProvider).post(
          AppConstants.addCategory,
          data: FormData.fromMap({
            'name': categoryName,
            'parent_id': parentCategoryId,
            'image': categoryImage != null
                ? await MultipartFile.fromFile(categoryImage.path,
                    filename: 'category_image.jpg')
                : null
          }),
        );

    return response;
  }

  @override
  Future<Response> updateCategory({
    required int categoryId,
    required String categoryName,
    required int? parentCategoryId,
    required File? categoryImage,
  }) async {
    final response = await ref.read(apiClientProvider).post(
          "${AppConstants.updateCategory}/$categoryId",
          data: FormData.fromMap({
            'name': categoryName,
            'parent_id': parentCategoryId,
            'image': categoryImage != null
                ? await MultipartFile.fromFile(categoryImage.path,
                    filename: 'category_image.jpg')
                : null
          }),
        );
    return response;
  }

  @override
  Future<Response> deleteCategory({required int id}) async {
    final response = await ref
        .read(apiClientProvider)
        .delete("${AppConstants.deleteCategory}/$id");
    return response;
  }
}
