import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/features/cubit/auth_cubit/auth_cubit.dart';
import 'package:task_manager/features/cubit/auth_cubit/auth_cubit_state.dart';
import 'package:task_manager/features/cubit/task_cubit/water_cubit.dart';
import 'package:task_manager/features/cubit/task_cubit/water_cubit_state.dart';
import 'package:task_manager/features/pages/auth_page.dart';
import 'package:task_manager/features/pages/water_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String path = '/settings';

  @override
  Widget build(BuildContext context) {
    final TextEditingController dailyAmountController = TextEditingController();

    return BlocListener<AuthCubit, AuthCubitState>(
      listener: (context, state) {
        if (state is AuthCubitUnauthorized) {
          context.go(AuthPage.path);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Colors.amber,
          actions: [
            IconButton(
                onPressed: () => context.go(WaterPage.path),
                icon: const Icon(Icons.water)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily Water Intake Goal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: dailyAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter daily amount (ml)',
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<WaterCubit, WaterCubitState>(
                builder: (context, state) {
                  if (state is WaterCubitLoaded) {
                    final id = state.daylis.last.id;
                    final idToDelete = state.daylis.first.id;
                    return ElevatedButton(
                      onPressed: () async {
                        final dailyAmount =
                            int.tryParse(dailyAmountController.text);
                        if (dailyAmount != null) {
                          context
                              .read<WaterCubit>()
                              .deleteDailyAmount(idToDelete);
                          context
                              .read<WaterCubit>()
                              .updateDailyAmount(dailyAmount, id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Daily amount updated')),
                          );
                          context.go(WaterPage.path);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invalid input')),
                          );
                        }
                      },
                      child: const Text('Save Changes'),
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    context.read<AuthCubit>().signOut();
                  },
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
