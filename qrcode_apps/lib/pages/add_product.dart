// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qrcode_apps/bloc/product/bloc/product_bloc.dart';

class AddProductPage extends StatelessWidget {
  AddProductPage({super.key});

  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: codeC,
            keyboardType: TextInputType.number,
            maxLength: 10,
            autocorrect: false,
            decoration: InputDecoration(
                labelText: ('Product Code'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                )),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: nameC,
            autocorrect: false,
            decoration: InputDecoration(
                labelText: ('Product Name'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                )),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: qtyC,
            keyboardType: TextInputType.number,
            autocorrect: false,
            decoration: InputDecoration(
                labelText: ('Quantity'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                )),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (codeC.text.length == 10) {
                  context.read<ProductBloc>().add(
                        ProductEventAddProduct(
                            code: codeC.text,
                            name: nameC.text,
                            qty: int.tryParse(qtyC.text) ?? 0),
                      );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Code product must 10 characters")));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9)),
              ),
              child: BlocConsumer<ProductBloc, ProductState>(
                listener: (context, state) {
                  if (state is ProductStateError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message),
                    ));
                  }
                  if (state is ProductStateCompleteAdd) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 3),
                      content: Text("Produk berhasil ditambahkan"),
                    ));
                    context.pop();
                  }
                },
                builder: (context, state) {
                  return Text(
                    state is ProductStateLoadingAdd
                        ? "Loading.."
                        : "Add Product",
                    style: TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
