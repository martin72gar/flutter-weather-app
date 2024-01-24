import 'dart:developer';

import 'package:course_weather_forecast/commons/app_constants.dart';
import 'package:course_weather_forecast/features/weather/presentation/bloc/hourly_forecast/hourly_forecast_bloc.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HourlyForecastPage extends StatefulWidget {
  const HourlyForecastPage({super.key});

  @override
  State<HourlyForecastPage> createState() => _HourlyForecastPageState();
}

class _HourlyForecastPageState extends State<HourlyForecastPage> {
  refresh() {
    context.read<HourlyForecastBloc>().add(OnGetHourlyForecast());
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: background()),
          Positioned.fill(
            child: Material(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          foreground(),
        ],
      ),
    );
  }

  Widget background() {
    return Image.asset(
      weatherBG['mist']!,
      fit: BoxFit.cover,
    );
  }

  Widget foreground() {
    return Column(
      children: [
        AppBar(
          title: const Text('Hourly Forecast'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        Expanded(
          child: BlocBuilder<HourlyForecastBloc, HourlyForecastState>(
            builder: (context, state) {
              if (state is HourlyForecastLoading) return DView.loadingCircle();

              if (state is HourlyForecastFailure) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.white60),
                    ),
                    DView.height(8),
                    IconButton.filledTonal(
                      onPressed: () {},
                      icon: const Icon(Icons.refresh),
                    )
                  ],
                );
              }

              if (state is HourlyForecastLoaded) {
                log("data: ${state.data.length}");
              }

              return Container();
            },
          ),
        )
      ],
    );
  }
}
