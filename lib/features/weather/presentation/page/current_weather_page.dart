import 'package:course_weather_forecast/commons/app_constants.dart';
import 'package:course_weather_forecast/commons/enum.dart';
import 'package:course_weather_forecast/features/weather/presentation/bloc/current_weather_bloc.dart';
import 'package:course_weather_forecast/features/weather/presentation/widget/basic_shadow.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  )),
            ],
          );
        }
        return Container();
      },
    );
  }
}
