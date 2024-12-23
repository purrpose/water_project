import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/cubit/auth_cubit/auth_cubit.dart';
import 'package:task_manager/features/cubit/task_cubit/water_cubit.dart';
import 'package:task_manager/features/rep/water_rep.dart';
import 'package:task_manager/firebase_options.dart';
import 'package:task_manager/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final drinkRepository = DrinkRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthCubit(FirebaseAuth.instance, drinkRepository),
        ),
        BlocProvider(
          create: (context) => WaterCubit(
            DrinkRepository(
              FirebaseAuth.instance,
              FirebaseFirestore.instance,
            ),
          )..loadDrinksAndDailys(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
      ),
    );
  }
}
