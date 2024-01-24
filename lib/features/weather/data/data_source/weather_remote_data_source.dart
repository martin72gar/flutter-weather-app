import 'dart:convert';
import 'dart:developer';

import 'package:course_weather_forecast/api/key.dart';
import 'package:course_weather_forecast/api/urls.dart';
import 'package:course_weather_forecast/core/error/exception.dart';
import 'package:course_weather_forecast/features/weather/data/model/weather_model.dart';
import 'package:http/http.dart' as http;

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather(String cityName);
  Future<List<WeatherModel>> getHourlyForecast(String cityName);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;

  WeatherRemoteDataSourceImpl(this.client);

  @override
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    String countryCode = 'ID';
    Uri uri = Uri.parse(
        '${URLs.baseURL}/weather?q=$cityName,$countryCode&appid=$apiKey');

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return WeatherModel.fromJson(responseBody);
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<WeatherModel>> getHourlyForecast(String cityName) async {
    String countryCode = 'ID';
    Uri uri = Uri.parse(
        '${URLs.baseURL}/forecast?q=$cityName,$countryCode&appid=$apiKey');

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      Map responseBody = jsonDecode(response.body);
      List list = responseBody['list'];

      return list.map((e) => WeatherModel.fromJson(Map.from(e))).toList();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw ServerException();
    }
  }
}
