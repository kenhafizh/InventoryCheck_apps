part of 'product_bloc.dart';

sealed class ProductEvent {}

// aksi / tindakam
// 1. add product
// 2. edit product
// 3. hapus product

class ProductEventAddProduct extends ProductEvent{
  ProductEventAddProduct({required this.code, required this.name, required this.qty});

  final String code;
  final String name;
  final int qty;
}

class ProductEventEditProduct extends ProductEvent{
  ProductEventEditProduct({required this.productId, required this.name, required this.qty});

  final String productId;
  final String name;
  final int qty;
}

class ProductEventRemoveProduct extends ProductEvent{
  ProductEventRemoveProduct(this.id);

  final String id;
}

class ProductEventExportToPdf extends ProductEvent{

  
}
