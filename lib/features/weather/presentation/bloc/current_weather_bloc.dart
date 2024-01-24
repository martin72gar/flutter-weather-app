import 'package:course_weather_forecast/commons/app_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:course_weather_forecast/features/weather/domain/get_current_weather_use_case.dart';
import 'package:course_weather_forecast/features/weather/domain/entities/weather_entity.dart';
import 'package:equatable/equatable.dart';

part 'current_weather_event.dart';
part 'current_weather_state.dart';

class CurrentWeatherBloc
    extends Bloc<CurrentWeatherEvent, CurrentWeatherState> {
  final GetCurrentWeatherUseCase _usecase;
  final AppSession _appSession;
  CurrentWeatherBloc(this._usecase, this._appSession)
      : super(CurrentWeatherInitial()) {
    on<OnGetCurrentWeather>((event, emit) async {
      String? cityName = _appSession.cityName;
      if (cityName == null) return;

      emit(CurrentWeatherLoading());
      debugPrint('cityName: $cityName');
      final result = await _usecase(cityName);
      result.fold(
        (failure) => emit(CurrentWeatherFailure(failure.message)),
        (data) => emit(CurrentWeatherLoaded(data)),
      );
    });
  }
}
