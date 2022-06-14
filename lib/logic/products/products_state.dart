// ignore_for_file: non_constant_identifier_names

part of '../products/products_cubit.dart';

class ProductsState {
  final List<Product> products;

  const ProductsState(this.products);

  static ProductsState initial() {
    return const ProductsState([]);
  }

  ProductsState copyWith({
    List<Product>? products,
  }) {
    return ProductsState(
      products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'products': products.map((x) => x.toMap()).toList(),
    };
  }

  factory ProductsState.fromMap(Map<String, dynamic> map) {
    return ProductsState(
      List<Product>.from(map['products']?.map((x) => Product.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductsState.fromJson(String source) =>
      ProductsState.fromMap(json.decode(source));
}

class Product {
  final String id;
  final String name;
  final String image_path;
  final String description;

  const Product(this.id, this.name, this.image_path, this.description);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image_path': image_path,
      'description': description,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      map['id'] ?? '',
      map['name'] ?? '',
      map['image_path'] ?? '',
      map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
