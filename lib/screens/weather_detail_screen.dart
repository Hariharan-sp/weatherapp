import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/weather_controller.dart';

class WeatherDetailScreen extends StatelessWidget {
  final WeatherController _weatherController = Get.put(WeatherController());

  final Map<String, dynamic> args;

  WeatherDetailScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final lat = args['lat'] as double;
    final lon = args['lon'] as double;
    final cityName = args['cityName'] as String;

    _weatherController.fetchWeather(lat, lon);

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(cityName),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Obx(() {
            if (_weatherController.isLoading.value) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }
            if (_weatherController.error.value.isNotEmpty) {
              return Center(
                child: Text(
                  _weatherController.error.value,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 18),
                ),
              );
            }
            if (_weatherController.weather.value == null) {
              return const Center(
                child: Text(
                  'No weather data available',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final weather = _weatherController.weather.value!;
            final timeFormat = DateFormat('EEE, MMM d • hh:mm a');

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud, size: 64, color: Colors.yellowAccent),
                      const SizedBox(height: 12),
                      Text(
                        '${weather.temperature}°C',
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        weather.weatherCondition,
                        style: const TextStyle(fontSize: 20, color: Colors.white70),
                      ),
                      const SizedBox(height: 24),
                      weatherRow(Icons.location_on, 'City',cityName ),
                      weatherRow(Icons.air, 'Wind', '${weather.windspeed} km/h'),
                      weatherRow(Icons.access_time, 'Time', timeFormat.format(weather.time)),
                      weatherRow(Icons.light_mode, 'Phase', weather.isDay ? 'Day time' : 'Night time'),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget weatherRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.white70),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
