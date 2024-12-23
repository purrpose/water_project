import 'package:task_manager/features/model/daily_amount_model.dart';
import 'package:task_manager/features/model/water_model.dart';

abstract class WaterCubitState {}

class WaterCubitInitial extends WaterCubitState {}

class WaterCubitLoading extends WaterCubitState {}

class WaterCubitLoaded extends WaterCubitState {
  final List<WaterModel> drinks;
  final List<DailyModel> daylis;

  WaterCubitLoaded({
    required this.drinks,
    required this.daylis,
  });
}

class WaterCubitError extends WaterCubitState {
  final String error;

  WaterCubitError(this.error);
}
