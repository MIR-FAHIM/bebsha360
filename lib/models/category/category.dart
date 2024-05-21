import 'dart:convert';

class Category {
  final int id;
  final String name;
  final String thumbnail;
  final int? parentCategoryId;
  final String? parentCategoryName;
  final String? parentCategoryThumbnail;
  final int totalProducts;
  Category({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.parentCategoryId,
    required this.parentCategoryName,
    required this.parentCategoryThumbnail,
    required this.totalProducts,
  });

  Category copyWith({
    int? id,
    String? name,
    String? thumbnail,
    int? parentCategoryId,
    String? parentCategoryName,
    String? parentCategoryThumbnail,
    int? totalProducts,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      parentCategoryId: parentCategoryId ?? this.parentCategoryId,
      parentCategoryName: parentCategoryName ?? this.parentCategoryName,
      parentCategoryThumbnail:
          parentCategoryThumbnail ?? this.parentCategoryThumbnail,
      totalProducts: totalProducts ?? this.totalProducts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'parent_category_id': parentCategoryId,
      'parent_category_name': parentCategoryName,
      'parent_category_thumbnail': parentCategoryThumbnail,
      'total_products': totalProducts,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'].toInt() as int,
      name: map['name'] as String,
      thumbnail: map['thumbnail'] as String,
      parentCategoryId: map['parent_category_id']?.toInt() as int?,
      parentCategoryName: map['parent_category_name'] as String?,
      parentCategoryThumbnail: map['parent_category_thumbnail'] as String?,
      totalProducts: map['total_products'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Category(id: $id, name: $name, thumbnail: $thumbnail, parent_category_id: $parentCategoryId, parent_category_name: $parentCategoryName, parent_category_thumbnail: $parentCategoryThumbnail, total_products: $totalProducts)';
  }

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.thumbnail == thumbnail &&
        other.parentCategoryId == parentCategoryId &&
        other.parentCategoryName == parentCategoryName &&
        other.parentCategoryThumbnail == parentCategoryThumbnail &&
        other.totalProducts == totalProducts;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        thumbnail.hashCode ^
        parentCategoryId.hashCode ^
        parentCategoryName.hashCode ^
        parentCategoryThumbnail.hashCode ^
        totalProducts.hashCode;
  }
}
