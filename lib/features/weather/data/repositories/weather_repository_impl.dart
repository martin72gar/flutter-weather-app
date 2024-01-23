import 'dart:io';

import 'package:course_weather_forecast/core/error/exception.dart';
import 'package:course_weather_forecast/core/error/failure.dart';
import 'package:course_weather_forecast/features/weather/data/data_source/weather_remote_data_source.dart';
import 'package:course_weather_forecast/features/weather/domain/entities/weather_entity.dart';
import 'package:course_weather_forecast/features/weather/domain/repositories/weather_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  WeatherRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(
      String cityName) async {
    try {
      final result = await remoteDataSource.getCurrentWeather(cityName);
      return Right(result.toEntity);
    } on NotFoundException {
      return const Left(NotFoundFailure('Not found'));
    } on ServerException {
      return const Left(ServerFailure('Server error'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed connect to the network'));
    } catch (e) {
      debugPrint('Someting failure: $e');
      return const Left(SomethingFailure('Something wrong occurred'));
    }
  }
}
