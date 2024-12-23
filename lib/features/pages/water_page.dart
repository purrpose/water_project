import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/features/cubit/auth_cubit/auth_cubit.dart';
import 'package:task_manager/features/cubit/auth_cubit/auth_cubit_state.dart';
import 'package:task_manager/features/cubit/task_cubit/water_cubit.dart';
import 'package:task_manager/features/cubit/task_cubit/water_cubit_state.dart';
import 'package:task_manager/features/pages/auth_page.dart';
import 'package:task_manager/features/pages/settings_page.dart';
import 'package:task_manager/features/pages/widgets/water_intake_widget.dart';

class WaterPage extends StatelessWidget {
  const WaterPage({super.key});

  static const String path = '/water';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthCubitState>(
      listener: (context, state) {
        if (state is AuthCubitUnauthorized) {
          context.go(AuthPage.path);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My water intake'),
          backgroundColor: Colors.amber,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                context.go(SettingsPage.path);
              },
            ),
          ],
        ),
        body: BlocBuilder<WaterCubit, WaterCubitState>(
          builder: (context, state) {
            if (state is WaterCubitLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WaterCubitLoaded) {
              final dailyAmount = state.daylis.last.dailyAmount;
              final amountTaken = state.drinks.isNotEmpty
                  ? state.drinks
                      .map((v) => v.amountTaken)
                      .reduce((a, b) => a + b)
                  : 0;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WaterIntakeCircle(
                    amountTaken: amountTaken.toDouble(),
                    dailyAmount: dailyAmount.toDouble(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Добавляем новое значение воды
                      final now = DateTime.now();
                      final waterCubit = context.read<WaterCubit>();
                      final uid = await waterCubit.getUid();
                      context.read<WaterCubit>().addDrink(250, now, uid!);
                    },
                    child: const Text("Добавить 250 мл"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final drinkId = state.drinks.last.drinkId;
                      context.read<WaterCubit>().deleteDrink(drinkId);
                    },
                    child: const Text("Удалить 250 мл"),
                  ),
                ],
              );
            } else if (state is WaterCubitError) {
              print(state.error);
              return Center(child: Text(state.error));
            }
            return const Center(child: Text('Задач ещё нет'));
          },
        ),
      ),
    );
  }
}
