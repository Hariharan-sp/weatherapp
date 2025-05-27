import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/city_controller.dart';

class RecentSearchesScreen extends StatelessWidget {
  final CityController _cityController = Get.find();

  RecentSearchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recent Searches'),
          elevation: 0,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Obx(() {
            if (_cityController.recentSearches.isEmpty) {
              return const Center(
                child: Text(
                  'No recent searches',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cityController.recentSearches.length,
              itemBuilder: (context, index) {
                final cityName = _cityController.recentSearches[index];
                return GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.toNamed('/search');
                    _cityController.searchCities(cityName.split(',').first.trim());
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    color: Colors.white.withOpacity(0.9),
                    child: ListTile(
                      leading: const Icon(Icons.location_city, color: Colors.deepPurple),
                      title: Text(
                        cityName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
