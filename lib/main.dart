import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp/screens/recent_seraches_screen.dart';
import 'screens/city_search_screen.dart';
import 'screens/weather_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/search',
      getPages: [
        GetPage(name: '/search', page: () => CitySearchScreen()),
        GetPage(name: '/weather', page: () => WeatherDetailScreen(args: Get.arguments)),
        GetPage(name: '/recent', page: () => RecentSearchesScreen()),
      ],
    );
  }
}