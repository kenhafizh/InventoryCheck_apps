part of 'product_bloc.dart';


abstract class ProductState {}

// state / kondisi product
// 1. product awal -> masih kosong
// 2. product loading
// 3. product complete -> berhasil dapat dari database
// 4. prouduct eror


class ProductStateInitial extends ProductState {}

class ProductStateLoadingAdd extends ProductState {}

class ProductStateLoadingExport extends ProductState {}

class ProductStateCompleteAdd extends ProductState {}

class ProductStateLoadingEdit extends ProductState {}

class ProductStateCompleteEdit extends ProductState {}

class ProductStateLoadingDelete extends ProductState {}

class ProductStateCompleteDelete extends ProductState {}

class ProductStateCompleteExport extends ProductState {}


class ProductStateError extends ProductState {
  ProductStateError(this.message);

    final String message;
  }



