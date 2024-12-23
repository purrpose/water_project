import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/cubit/auth_cubit/auth_cubit_state.dart';
import 'package:task_manager/features/rep/water_rep.dart';

class AuthCubit extends Cubit<AuthCubitState> {
  final FirebaseAuth _firebaseAuth;
  final DrinkRepository _repository;

  AuthCubit(this._firebaseAuth, this._repository) : super(AuthCubitInitial());

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthCubitLoading());

    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      emit(AuthCubitAuthorized(user: userCredential.user!));
    } catch (e) {
      emit(AuthCubitUnauthorized(error: e.toString()));
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    emit(AuthCubitLoading());
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final uid = userCredential.user?.uid;
      if (uid != null) {
        await _repository.createInitialDailyAmount(uid);
      }
      emit(AuthCubitAuthorized(user: userCredential.user!));
    } catch (e) {
      emit(AuthCubitUnauthorized());
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    emit(AuthCubitUnauthorized());
  }
}
