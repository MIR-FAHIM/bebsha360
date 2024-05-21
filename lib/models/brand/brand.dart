import 'dart:convert';

class Brand {
  final int id;
  final String name;
  final String thumbnail;
  final int totalProducts;
  Brand({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.totalProducts,
  });

  Brand copyWith({
    int? id,
    String? name,
    String? thumbnail,
    int? totalProducts,
  }) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      totalProducts: totalProducts ?? this.totalProducts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'total_products': totalProducts,
    };
  }

  factory Brand.fromMap(Map<String, dynamic> map) {
    return Brand(
      id: map['id'].toInt() as int,
      name: map['name'] as String,
      thumbnail: map['thumbnail'] as String,
      totalProducts: map['total_products'].toInt() as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Brand.fromJson(String source) =>
      Brand.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Brand(id: $id, name: $name, thumbnail: $thumbnail, total_products: $totalProducts)';
  }

  @override
  bool operator ==(covariant Brand other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.thumbnail == thumbnail &&
        other.totalProducts == totalProducts;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        thumbnail.hashCode ^
        totalProducts.hashCode;
  }
}
