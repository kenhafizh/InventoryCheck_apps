// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_apps/bloc/bloc.dart';
import 'package:qrcode_apps/models/product.dart';

class DetailProductPage extends StatelessWidget {
  DetailProductPage(this.id, this.product, {super.key});

  final String id;

  final Product product;

  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    codeC.text = product.code!;
    nameC.text = product.name!;
    qtyC.text = product.qty!.toString();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Detail Product Page"),
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: QrImageView(
                    data: product.code!,
                    size: 200,
                    version: QrVersions.auto,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              autocorrect: false,
              controller: codeC,
              keyboardType: TextInputType.number,
              readOnly: true,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: "Product Code",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              autocorrect: false,
              controller: nameC,
              decoration: InputDecoration(
                labelText: "Product Name",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              autocorrect: false,
              controller: qtyC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Product Quantity",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<ProductBloc>().add(
                      ProductEventEditProduct(
                          productId: product.productId!,
                          name: nameC.text,
                          qty: int.tryParse(qtyC.text) ?? 0),
                    );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              child: BlocConsumer<ProductBloc, ProductState>(
                listener: (context, state) {
                  if (state is ProductStateError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                  if (state is ProductStateCompleteEdit) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Produk berhasil diperbarui"),
                    ));
                    context.pop();
                  }
                },
                builder: (context, state) {
                  return Text(
                    state is ProductStateLoadingAdd
                        ? "Loading"
                        : "Update Product",
                    style: TextStyle(color: Colors.black),
                  );
                },
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<ProductBloc>().add(
                      ProductEventRemoveProduct(product.productId!),
                    );
              },
              child: BlocConsumer<ProductBloc, ProductState>(
                listener: (context, state) {
                  if (state is ProductStateError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                  if (state is ProductStateCompleteDelete) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      // duration: Duration(seconds: 10),
                      content: Text("Produk berhasil dihapus"),
                    ));
                    context.pop();
                  }
                },
                builder: (context, state) {
                  return Text(
                    state is ProductStateLoadingDelete
                        ? "Loading"
                        : "Delete Product",
                    style: TextStyle(color: Colors.red.shade900),
                  );
                },
              ),
            )
          ],
        ));
  }
}
