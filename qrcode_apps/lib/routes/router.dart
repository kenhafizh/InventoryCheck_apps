// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:qrcode_apps/models/product.dart';
import 'package:qrcode_apps/pages/HomePage.dart';
import 'package:qrcode_apps/pages/add_product.dart';
import 'package:qrcode_apps/pages/detail_product.dart';
import 'package:qrcode_apps/pages/login.dart';
import 'package:qrcode_apps/pages/products.dart';
// import 'package:qrcode_apps/pages/settings.dart';
// import 'package:qrcode_apps/pages/signup.dart';

part 'route_name.dart';

//GoRouter Configuration
final router = GoRouter(
  redirect: (context, state) {
    FirebaseAuth auth = FirebaseAuth.instance;
    // cek kondisi saat ini -> sedang terautentikasi
    if (auth.currentUser == null) {
      // tidak sedang login / tidak ada user yg aktif saat ini
      return "/login";
    } else {
      return null;
    }
  },
  // errorBuilder: (context, state) => const ErrorPage(),
  routes: [
    // KALAU 1 LEVEL -> Push Replacement
    // KALAU SUB LEVEL -> Push (biasa)
    // Prioritas dalam pebuatan GoRoute (Urutan dari atas -> bawah)
    GoRoute(
      path: '/',
      name: Routes.home,
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'products',
          name: Routes.products,
          builder: (context, state) => const ProductsPage(),
          routes: [
            GoRoute(
              path: ':productId',
              name: Routes.detailProduct,
              builder: (context, state) => DetailProductPage(
                state.pathParameters['productId'].toString(),
                state.extra as Product,
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'add-product',
          name: Routes.addProducts,
          builder: (context, state) => AddProductPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      name: Routes.login,
      builder: (context, state) => LoginPage(),
    ),
  ],
);

