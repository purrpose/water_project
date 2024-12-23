import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:task_manager/features/cubit/task_cubit/water_cubit_state.dart';
import 'package:task_manager/features/model/daily_amount_model.dart';
import 'package:task_manager/features/model/water_model.dart';
import 'package:task_manager/features/rep/water_rep.dart';

class WaterCubit extends Cubit<WaterCubitState> {
  final DrinkRepository _repository;

  WaterCubit(this._repository) : super(WaterCubitInitial());

  Future<String?> getUid() => _repository.getUid();

  void loadDrinksAndDailys() {
    emit(WaterCubitLoading());

    final drinksStream = _repository.getDrinks();
    final dailysStream = _repository.getDailys();

    Rx.combineLatest2<List<WaterModel>, List<DailyModel>, WaterCubitLoaded>(
      drinksStream,
      dailysStream,
      (drinks, daylis) => WaterCubitLoaded(drinks: drinks, daylis: daylis),
    ).listen(
      (loadedState) {
        emit(loadedState);
      },
      onError: (error) {
        emit(WaterCubitError(error.toString()));
      },
    );
  }

  Future<void> addDrink(int amountTaken, DateTime date, String uid) async {
    try {
      await _repository.addDrink(amountTaken, date, uid);
    } catch (e) {
      emit(WaterCubitError(e.toString()));
    }
  }

  Future<void> updateDailyAmount(int dailyAmount, String id) async {
    try {
      await _repository.addDailyAmount(dailyAmount, id);
    } catch (e) {
      emit(WaterCubitError(e.toString()));
    }
  }

  Future<void> deleteDailyAmount(String id) async {
    try {
      await _repository.deleteDailyAmount(id);
    } catch (e) {
      emit(WaterCubitError(e.toString()));
    }
  }

  Future<void> deleteDrink(String drinkId) async {
    try {
      await _repository.deleteDrink(drinkId);
    } catch (e) {
      emit(WaterCubitError(e.toString()));
    }
  }
}
