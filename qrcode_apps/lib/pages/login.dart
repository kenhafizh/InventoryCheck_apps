// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qrcode_apps/routes/router.dart';

import '../bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            controller: emailC,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                    labelText: ('Email')),
                    
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            controller: passwordC,
            obscureText: true, // biar password bintang-bintang
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                    labelText: ('Password')),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            // proses login
            onPressed: () {
              context.read<AuthBloc>().add(
                    AuthEventLogin(emailC.text, passwordC.text),
                  );
            },
            style: ElevatedButton.styleFrom(
              elevation: 3,
              backgroundColor: Colors.deepPurple[800],
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            child:
                BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
              if (state is AuthStateLogin) {
                context.goNamed(Routes.home);
              }
              if (state is AuthStateError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                  content: Text(state.message),
                  duration: const Duration(seconds: 2),
                ),
               );
              }
            }, builder: (context, state) {
              if (state is AuthStateLoading) {
                return const Text("Loading...",
                    style: TextStyle(color: Colors.white));
              }
              return const Text(
                "Login",
                style: TextStyle(color: Colors.white),
              );
            }),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.goNamed(Routes.signup), 
            child: Text("SignUp"),
          )
        ],
      ),
    );
  }
}
