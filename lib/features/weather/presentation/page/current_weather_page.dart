import 'package:course_weather_forecast/api/urls.dart';
import 'package:course_weather_forecast/commons/app_constants.dart';
import 'package:course_weather_forecast/commons/enum.dart';
import 'package:course_weather_forecast/commons/extension.dart';
import 'package:course_weather_forecast/features/weather/presentation/bloc/current_weather_bloc.dart';
import 'package:course_weather_forecast/features/weather/presentation/widget/basic_shadow.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extended_image/extended_image.dart';
import 'package:intl/intl.dart';

class CurrentWeatherPage extends StatefulWidget {
  const CurrentWeatherPage({super.key});

  @override
  State<CurrentWeatherPage> createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  refresh() {
    context.read<CurrentWeatherBloc>().add(OnGetCurrentWeather());
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
          Positioned.fill(
            child: background(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 8,
            width: double.infinity,
            child: BasicShadow(
              topDown: true,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
              child: BasicShadow(
                topDown: false,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 50, right: 20),
                child: headerAction(),
              ),
            ],
          ),
          Expanded(
            child: foreground(),
          )
        ],
      ),
    );
  }

  Widget headerAction() {
    return Row(
      children: [
        buttonAction(
            onTap: () {
              Navigator.pushNamed(context, AppRoute.pickPlace.name)
                  .then((backResponse) {
                if (backResponse == null) return;
                if (backResponse == 'refresh') refresh();
              });
            },
            title: "City",
            icon: Icons.edit),
        DView.width(8),
        buttonAction(
            onTap: () => refresh(), title: "Refresh", icon: Icons.refresh),
        DView.width(8),
        buttonAction(
            onTap: () =>
                Navigator.pushNamed(context, AppRoute.hourlyForecast.name),
            title: "Hourly",
            icon: Icons.access_time),
      ],
    );
  }

  Widget buttonAction({
    required VoidCallback onTap,
    required String title,
    required IconData icon,
  }) {
    return Expanded(
      child: Material(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                DView.width(4),
                Icon(
                  icon,
                  size: 12,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget background() {
    return BlocBuilder<CurrentWeatherBloc, CurrentWeatherState>(
      builder: (context, state) {
        String assetPath = weatherBG.entries.first.value;
        debugPrint('state: $state');

        if (state is CurrentWeatherLoaded) {
          assetPath = weatherBG[state.data.description] ?? assetPath;
          debugPrint('assetPath: $assetPath');
        }

        return Image.asset(assetPath, fit: BoxFit.cover);
      },
    );
  }

  Widget foreground() {
    return BlocBuilder<CurrentWeatherBloc, CurrentWeatherState>(
      builder: (context, state) {
        if (state is CurrentWeatherLoading) {
          return DView.loadingCircle();
        }

        if (state is CurrentWeatherFailure) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DView.error(data: state.message),
              IconButton.filledTonal(
                onPressed: () {
                  refresh();
                },
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              ),
            ],
          );
        }

        if (state is CurrentWeatherLoaded) {
          final weather = state.data;
          return Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  weather.cityName,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black12,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                ),
                Text(
                  '- ${weather.main} -',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black26,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                ),
                ExtendedImage.network(URLs.weatherIcon(weather.icon)),
                Text(
                  weather.description.capitalize,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black26,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                ),
                Text(
                  DateFormat('EEEE, d MMM yyyy').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black26,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                ),
                DView.height(20),
                Text(
                  '${(weather.temperature - 273.15).round()}\u2103',
                  style: const TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black26,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                ),
                GridView(
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 60,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8),
                  children: [
                    itemStats(
                        icon: Icons.thermostat,
                        title: 'Temperature',
                        data: '${weather.temperature}\u2103'),
                    itemStats(
                        icon: Icons.air,
                        title: 'Wind',
                        data: '${weather.wind}m/s'),
                    itemStats(
                        icon: Icons.compare_arrows,
                        title: 'Pressure',
                        data: '${NumberFormat.currency(
                          decimalDigits: 0,
                          symbol: '',
                        ).format(weather.pressure)}hPa'),
                    itemStats(
                        icon: Icons.water_drop_outlined,
                        title: 'Humidity',
                        data: '${weather.humidity}%'),
                  ],
                ),
              ],
            ),
          );
        }
        return DView.nothing();
      },
    );
  }

  Widget itemStats({
    required IconData icon,
    required String title,
    required String data,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          foregroundColor: Theme.of(context).primaryColor,
          radius: 18,
          child: Icon(icon),
        ),
        DView.width(6),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            Text(
              data,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ]),
    );
  }
}
