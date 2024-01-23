import 'package:course_weather_forecast/commons/enum.dart';
import 'package:course_weather_forecast/features/pick_place/presentation/cubit/city_cubit.dart';
import 'package:course_weather_forecast/features/pick_place/presentation/page/pick_place_page.dart';
import 'package:course_weather_forecast/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await initLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<CityCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            textTheme: GoogleFonts.poppinsTextTheme(),
            progressIndicatorTheme: const ProgressIndicatorThemeData(
              color: Colors.white,
            )),
        initialRoute: '/',
        routes: {
          '/': (context) => const PickPlacePage(),
          AppRoute.pickPlace.name: (context) => const Scaffold(),
          AppRoute.hourlyForecast.name: (context) => const Scaffold(),
        },
      ),
    );
  }
}