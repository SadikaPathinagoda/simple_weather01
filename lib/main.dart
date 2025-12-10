import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_weather01/services/database/favourites_provider.dart';

import 'providers/weather_api_service.dart';
import 'providers/weather_provider.dart';
import 'screens/home_screen.dart';
import 'screens/loading_screen.dart';

void main() {
  runApp(const SimpleWeatherApp());
}

class SimpleWeatherApp extends StatelessWidget {
  const SimpleWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
    ChangeNotifierProvider(
      create: (_) => WeatherProvider(WeatherApiService()),
    ),
    ChangeNotifierProvider(
      create: (_) => FavouritesProvider()..loadFavourites(),
    ),
  ],
      child: MaterialApp(
        title: 'SimpleWeather',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        // First screen = wrapper that shows loading, then goes to home
        home: const LoadingWrapper(),
      ),
    );
  }
}

class LoadingWrapper extends StatefulWidget {
  const LoadingWrapper({super.key});

  @override
  State<LoadingWrapper> createState() => _LoadingWrapperState();
}

class _LoadingWrapperState extends State<LoadingWrapper> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // This shows your nice loading screen UI
    return const LoadingPage();
  }
}
