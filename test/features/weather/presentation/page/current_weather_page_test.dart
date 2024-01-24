import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:course_weather_forecast/features/weather/presentation/bloc/current_weather_bloc.dart';
import 'package:course_weather_forecast/features/weather/presentation/page/current_weather_page.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/dummy_data/weather_data.dart';

class MockCurrentWeatherBloc
    extends MockBloc<CurrentWeatherEvent, CurrentWeatherState>
    implements CurrentWeatherBloc {}

void main() {
  late MockCurrentWeatherBloc bloc;

  setUp(() {
    bloc = MockCurrentWeatherBloc();
    // needed if using Image.network() other than ExtendedImage.network()
    // HttpOverrides.global = null;
  });

  Widget tWidget() {
    return BlocProvider<CurrentWeatherBloc>(
      create: (context) => bloc,
      child: const MaterialApp(
        home: CurrentWeatherPage(),
      ),
    );
  }

  testWidgets(
    'should show noting when bloc state is initial',
    (tester) async {
      // arrange
      when(() => bloc.state).thenReturn(CurrentWeatherInitial());

      // act
      await tester.pumpWidget(tWidget());

      // assert
      final container = find.byType(Container);
      expect(container, findsOneWidget);
    },
  );

  testWidgets(
    'should show dView loading when bloc state is loading',
    (tester) async {
      // arrange
      when(() => bloc.state).thenReturn(CurrentWeatherLoading());

      // act
      await tester.pumpWidget(tWidget());

      // assert
      final dViewLoading = find.byWidget(DView.loadingCircle());
      expect(dViewLoading, findsOneWidget);
    },
  );

  testWidgets(
    'should show error text when bloc state is failure',
    (tester) async {
      // arrange
      when(() => bloc.state)
          .thenReturn(const CurrentWeatherFailure('not found'));

      // act
      await tester.pumpWidget(tWidget());

      // assert
      final partError = find.byKey(const Key('part_error'));
      expect(partError, findsOneWidget);
      expect(find.text('not found'), findsOneWidget);
    },
  );

  testWidgets(
    'should show part success when bloc state is loaded',
    (tester) async {
      // arrange
      when(() => bloc.state).thenReturn(CurrentWeatherLoaded(tWeatherEntity));

      // act
      await tester.pumpWidget(tWidget());
      // needed if using Image.network() other than ExtendedImage.network()
      // await tester.pumpAndSettle();

      // assert
      final partSuccess = find.byKey(const Key('weather_loaded'));
      expect(partSuccess, findsOneWidget);
    },
  );
}
