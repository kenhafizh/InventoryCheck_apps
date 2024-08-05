// ignore_for_file: unused_catch_clause


import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthStateLogout()) {
    FirebaseAuth auth = FirebaseAuth.instance;
    on<AuthEventLogin>((event, emit) async {
      try {
        emit(AuthStateLoading());
        // fungsi untuk login 
         await auth.signInWithEmailAndPassword(email: event.email, password: event.password);
          emit(AuthStateLogin());
      } on FirebaseAuthException catch(e) {
        //error dari firebase auth
         emit(AuthStateError(e.message.toString()));
      }
      catch (e) {
        // error general
        emit(AuthStateError(e.toString()));
      }
    });
     on<AuthEventLogout>((event, emit) async {
      // fungsi untuk logout
    try {
      emit(AuthStateLoading());
      // fungsi untuk logout
      await auth.signOut();
      emit(AuthStateLogout());
      } on FirebaseAuthException catch (e) {
        // error dari firebase auth
        emit (AuthStateError(e.message.toString()));
      }
      catch (e) {
        // error general
        emit(AuthStateError(e.toString()));
      }
    });
  }
}
