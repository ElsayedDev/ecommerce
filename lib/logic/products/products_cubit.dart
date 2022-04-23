// ignore_for_file: non_constant_identifier_names

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'dart:convert';

part 'products_state.dart';

class ProductsCubit extends HydratedCubit<ProductsState> {
  ProductsCubit() : super(ProductsState.initial());

  Future<void> addProduct(Product product) async {
    emit(state.copyWith(products: [...state.products, product]));
  }

  Future<void> removeAllProducts() async {
    emit(ProductsState.initial());
  }

  @override
  ProductsState? fromJson(Map<String, dynamic> json) {
    return ProductsState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(ProductsState state) {
    return state.toMap();
  }
}
