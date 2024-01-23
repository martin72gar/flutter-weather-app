import 'package:course_weather_forecast/commons/app_session.dart';
import 'package:course_weather_forecast/core/error/failure.dart';
import 'package:course_weather_forecast/features/pick_place/get_current_weather_use_case.dart';
import 'package:course_weather_forecast/features/weather/presentation/bloc/current_weather_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../../../helpers/dummy_data/weather_data.dart';

class MockAppSession extends Mock implements AppSession {}

class MockGetCurrentWeatherUseCase extends Mock
    implements GetCurrentWeatherUseCase {}

void main() {
  late MockAppSession mockAppSession;
  late MockGetCurrentWeatherUseCase currentWeatherUseCase;
  late CurrentWeatherBloc bloc;

  setUp(() {
    mockAppSession = MockAppSession();
    currentWeatherUseCase = MockGetCurrentWeatherUseCase();
    bloc = CurrentWeatherBloc(currentWeatherUseCase, mockAppSession);
  });

  blocTest<CurrentWeatherBloc, CurrentWeatherState>(
    'emits [CurrentWeatherLoading, CurrentWeatherLoaded] when usecase success.',
    build: () {
      when(() => mockAppSession.cityName).thenReturn(tCityName);
      when(
        () => currentWeatherUseCase(any()),
      ).thenAnswer((_) async => Right(tWeatherEntity));
      return bloc;
    },
    act: (bloc) => bloc.add(OnGetCurrentWeather()),
    expect: () => [
      CurrentWeatherLoading(),
      CurrentWeatherLoaded(tWeatherEntity),
    ],
  );

  blocTest<CurrentWeatherBloc, CurrentWeatherState>(
    'emits [CurrentWeatherLoading, CurrentWeatherFailed] when usecase failed.',
    build: () {
      when(() => mockAppSession.cityName).thenReturn(tCityName);
      when(
        () => currentWeatherUseCase(any()),
      ).thenAnswer((_) async => const Left(NotFoundFailure('not found')));
      return bloc;
    },
    act: (bloc) => bloc.add(OnGetCurrentWeather()),
    expect: () => [
      CurrentWeatherLoading(),
      const CurrentWeatherFailure('not found'),
    ],
  );

  blocTest<CurrentWeatherBloc, CurrentWeatherState>(
    'emits [] when appsession return null.',
    build: () {
      when(() => mockAppSession.cityName).thenReturn(null);
      when(
        () => currentWeatherUseCase(any()),
      ).thenAnswer((_) async => const Left(NotFoundFailure('not found')));
      return bloc;
    },
    act: (bloc) => bloc.add(OnGetCurrentWeather()),
    expect: () => [],
  );
}
