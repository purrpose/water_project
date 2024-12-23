import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/features/cubit/auth_cubit/auth_cubit.dart';
import 'package:task_manager/features/cubit/auth_cubit/auth_cubit_state.dart';
import 'package:task_manager/features/pages/auth_page.dart';
import 'package:task_manager/features/pages/water_page.dart';

class RegPage extends StatefulWidget {
  const RegPage({super.key});
  static const String path = '/reg';

  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthCubitState>(
      listener: (context, state) {
        if (state is AuthCubitAuthorized) {
          context.go(WaterPage.path);
        } else if (state is AuthCubitUnauthorized && state.error != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registration'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 68, 243, 243),
          actions: [
            TextButton(
                onPressed: () {
                  context.go(AuthPage.path);
                },
                child: const Text('Log in'))
          ],
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(label: Text('Email')),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(label: Text('Password')),
              ),
              ElevatedButton(onPressed: () {
                context.read<AuthCubit>().signUp(
                    email: emailController.text,
                    password: passwordController.text);
              }, child: BlocBuilder<AuthCubit, AuthCubitState>(
                builder: (context, state) {
                  if (state is AuthCubitLoading) {
                    return const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(),
                    );
                  }
                  return const Text('Register');
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
