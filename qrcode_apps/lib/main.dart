import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_apps/bloc/auth_bloc.dart';
import 'package:qrcode_apps/bloc/product/bloc/product_bloc.dart';
import 'package:qrcode_apps/routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
         BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }
}
