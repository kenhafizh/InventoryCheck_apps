part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

// State == kondisi saat ini
// 1. isLogout ? -> tidak terautentikasi
// 2. isLogin ? -> terautentikasi
// 3. isLoading -> loading ...
// 4. isError -> gagal login ...


class AuthStateLogin extends AuthState {}

class AuthStateLoading extends AuthState {}

class AuthStateLogout extends AuthState {}

class AuthStateError extends AuthState {
  AuthStateError(this.message);

  final String message;
}





