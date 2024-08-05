// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_local_variable, avoid_print, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:go_router/go_router.dart';
import 'package:qrcode_apps/bloc/bloc.dart';
import 'package:qrcode_apps/bloc/product/bloc/product_bloc.dart';
import 'package:qrcode_apps/models/product.dart';
import 'package:qrcode_apps/routes/router.dart';
// import 'package:qrcode_apps/routes/router.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProductBloc productB = context.read<ProductBloc>();
    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        title: const Text("All Products"),
      ),
      body: StreamBuilder<QuerySnapshot<Product>>(
        stream: productB.streamProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text("Tidak ada data."),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Tidak dapat mengambil data."),
            );
          }

          List<Product> allProducts = [];

          for (var element in snapshot.data!.docs) {
            allProducts.add(element.data());
          }

          if (allProducts.isEmpty) {
            return const Center(
              child: Text("Tidak ada data."),
            );
          }

          return ListView.builder(
            itemCount: allProducts.length,
            padding: EdgeInsets.all(20),
            itemBuilder: (context, index) {
              Product product = allProducts[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(9),
                  onTap: () {
                    context.goNamed(
                      Routes.detailProduct,
                      pathParameters: {
                        "productId": product.productId!,
                      },
                      extra: product,
                    );
                  },
                  child: Container(
                    height: 100,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.code!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(product.name!),
                              Text("Jumlah : ${product.qty}"),
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          child: QrImageView(
                            data: product.code!,
                            size: 200,
                            version: QrVersions.auto,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
