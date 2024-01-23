import 'package:course_weather_forecast/commons/app_session.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'city_state.dart';

class CityCubit extends Cubit<String> {
  final AppSession appSession;
  CityCubit(this.appSession) : super('');

  String init() {
    String? city = appSession.cityName;
    if (city != null) emit(city);
    return state;
  }

  listenChange(String n) {
    emit(n);
  }

  saveCity() async {
    bool success = await appSession.saveCityName(state);
    DMethod.printTitle('saveCity', success.toString());
  }
}
