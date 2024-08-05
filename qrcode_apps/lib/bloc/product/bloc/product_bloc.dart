// ignore_for_file: avoid_print

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qrcode_apps/models/product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

 Stream<QuerySnapshot<Product>> streamProducts() async* {
    yield* firestore
        .collection("products")
        .withConverter<Product>(
          fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
          toFirestore: (product, _) => product.toJson(),
        )
        .snapshots();
  }

  ProductBloc() : super(ProductStateInitial()) {
    on<ProductEventAddProduct>((event, emit) async {
      try {
        emit(ProductStateLoadingAdd());
        // Menambahkan product ke firebase
        var hasil = await firestore.collection("products").add({
          "name": event.name,
          "code": event.code,
          "qty": event.qty,
        });

        await firestore.collection("products").doc(hasil.id).update({"productId": hasil.id});
        emit(ProductStateCompleteAdd());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Tidak dapat menambah product"));
      } catch (e) {
        emit(ProductStateError("Tidak dapat menambah product"));
      }
    });


    on<ProductEventEditProduct>((event, emit) async {
      try {
        emit(ProductStateLoadingEdit());
        // edit product dari firebase
        await firestore.collection("products").doc(event.productId).update({
          "name" : event.name,
          "qty" : event.qty
        });

        emit(ProductStateCompleteEdit());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Tidak dapat menambah product"));
      } catch (e) {
        emit(ProductStateError("Tidak dapat menambah produk"));
      }
    });


    on<ProductEventRemoveProduct>((event, emit) async {
      // menghapus product ke firebase
      try {
        emit(ProductStateLoadingAdd());
        // Menambahkan product ke firebase

        await firestore.collection("products").doc(event.id).delete();

        emit(ProductStateCompleteDelete());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Tidak dapat menghapus product"));
      } catch (e) {
        emit(ProductStateError("Tidak dapat menghapus product"));
      }
    });

     on<ProductEventExportToPdf>((event, emit) async {
      // menghapus product ke firebase
      try {
        emit(ProductStateLoadingExport());

        // 1. ambil data product dari firebase
        var querySnap = await firestore
        .collection("products")
        .withConverter<Product>(
          fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
          toFirestore: (product, _) => product.toJson(),
        )
        .get();

        List<Product> allProducts = [];

        for (var element in querySnap.docs) {
         Product product = element.data();
         allProducts.add(product);
        }

        // all product sudah ada isinya

        // 2. create pdf
        final pdf = pw.Document();

        // masukin data product ke pdf
        var data = await rootBundle.load("android/assets/fonts/opensans/OpenSans-Regular.ttf");
        var myFont = pw.Font.ttf(data);
        var myStyle = pw.TextStyle(font: myFont);

        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              return [
                pw.Text("Hello", style: myStyle),
              ];
            }
          ),
        );

        // 3. open pdf
        Uint8List bytes = await pdf.save();

        final dir = await getApplicationDocumentsDirectory();
        File file = File("${dir.path}/myproducts.pdf");

        // masukan data bytes ke file pdf
        await file.writeAsBytes(bytes);

        await OpenFile.open(file.path);

        print(file.path);
        

        emit(ProductStateCompleteExport());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Tidak dapat mengexport product"));
      } catch (e) {
        emit(ProductStateError("Tidak dapat export product"));
      }
    });
  }
}
