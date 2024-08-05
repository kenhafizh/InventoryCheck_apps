part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

// Event = action / aksi / tindakan
// 1. isLogout ? -> melakuan tindakan logout
// 2. isLogin ? -> melakuan tindakan login

class AuthEventLogin extends AuthEvent {
  AuthEventLogin(this.email, this.password);
  final String email;
  final String password;
}

class AuthEventLogout extends AuthEvent {}
