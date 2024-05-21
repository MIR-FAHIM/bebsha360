import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/models/category/category.dart';
import 'package:readypos_flutter/models/category/parent_category.dart';
import 'package:readypos_flutter/models/common_response.dart';
import 'package:readypos_flutter/services/category_service_provider.dart';

final categoryControllerProvider =
    StateNotifierProvider<CategoryController, bool>(
        (ref) => CategoryController(ref));

class CategoryController extends StateNotifier<bool> {
  final Ref ref;
  CategoryController(this.ref) : super(false);

  int? _total;
  int? get total => _total;

  List<Category>? _categories;
  List<Category>? get categories => _categories;

  List<ParentCategory> _parentCategories = [];
  List<ParentCategory> get parentCategories => _parentCategories;

  Future<void> getCategories({
    required int page,
    required int perPage,
    required String? search,
    required bool pagination,
  }) async {
    try {
      state = true;
      final response = await ref.read(categoryServiceProvider).getCategories(
            search: search,
            perPage: perPage,
            page: page,
          );
      _total = response.data['data']['total'];
      final List<dynamic> categoriesData = response.data['data']['categories'];
      if (pagination) {
        List<Category> data = categoriesData
            .map((category) => Category.fromMap(category))
            .toList();
        _categories!.addAll(data);
      } else {
        _categories = categoriesData
            .map((category) => Category.fromMap(category))
            .toList();
      }
      state = false;
    } catch (e, structrac) {
      debugPrint(e.toString());
      state = false;
      throw structrac;
    }
  }

  Future<void> getParentCategory() async {
    try {
      final response =
          await ref.read(categoryServiceProvider).getParentCategory();
      final List<dynamic> categoriesData = response.data['data']['categories'];
      _parentCategories = categoriesData
          .map((category) => ParentCategory.fromMap(category))
          .toList();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<CommonResponse> addCategory({
    required String categoryName,
    required int? parentCategoryId,
    required File? categoryImage,
  }) async {
    try {
      state = true;
      final response = await ref.read(categoryServiceProvider).addCategory(
            categoryName: categoryName,
            parentCategoryId: parentCategoryId,
            categoryImage: categoryImage,
          );
      final String message = response.data['message'];
      if (response.statusCode == 200) {
        state = false;
        return CommonResponse(message: message, isSuccess: true);
      } else {
        state = false;
        return CommonResponse(message: message, isSuccess: false);
      }
    } catch (e) {
      state = false;
      debugPrint(e.toString());
      return CommonResponse(message: e.toString(), isSuccess: true);
    }
  }

  Future<CommonResponse> updateCategory({
    required int categoryId,
    required String categoryName,
    required int? parentCategoryId,
    required File? categoryImage,
  }) async {
    try {
      final response = await ref.read(categoryServiceProvider).updateCategory(
            categoryId: categoryId,
            categoryName: categoryName,
            parentCategoryId: parentCategoryId,
            categoryImage: categoryImage,
          );
      final String message = response.data['message'];
      if (response.statusCode == 200) {
        state = false;
        return CommonResponse(message: message, isSuccess: true);
      } else {
        state = false;
        return CommonResponse(message: message, isSuccess: false);
      }
    } catch (e) {
      state = false;
      debugPrint(e.toString());
      return CommonResponse(message: e.toString(), isSuccess: true);
    }
  }

  Future<CommonResponse> deleteCategory({required int id}) async {
    try {
      final response = await ref.read(categoryServiceProvider).deleteCategory(
            id: id,
          );
      final String message = response.data['message'];
      if (response.statusCode == 200) {
        state = false;
        return CommonResponse(message: message, isSuccess: true);
      } else {
        state = false;
        return CommonResponse(message: message, isSuccess: false);
      }
    } catch (e) {
      state = false;
      debugPrint(e.toString());
      return CommonResponse(message: e.toString(), isSuccess: true);
    }
  }
}
