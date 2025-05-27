import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/city_controller.dart';
import '../models/city_model.dart';

class CitySearchScreen extends StatelessWidget {
  final CityController _cityController = Get.put(CityController());
  final TextEditingController _searchController = TextEditingController();

  CitySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('City Search'),
          backgroundColor: Colors.teal,
          elevation: 4,
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () => Get.toNamed('/recent'),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Material(
                elevation: 2,
                shadowColor: Colors.tealAccent,
                borderRadius: BorderRadius.circular(12),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search City',
                    prefixIcon: const Icon(Icons.location_city),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _performSearch,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: (_) => _performSearch(),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (_cityController.isLoading.value) {
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                }

                if (_cityController.error.value.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      _cityController.error.value,
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (_cityController.cities.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text(
                        'Enter a city name to search',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: ListView.separated(
                    itemCount: _cityController.cities.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final city = _cityController.cities[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          title: Text(
                            city.name ?? 'N/A',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (city.timezone != null || city.country != null)
                                Text(
                                  '${city.timezone ?? ''}, ${city.country ?? ''}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              if (city.latitude != null && city.longitude != null)
                                Text(
                                  'Lat: ${city.latitude!.toStringAsFixed(4)}, Lon: ${city.longitude!.toStringAsFixed(4)}',
                                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => _navigateToWeather(city),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _cityController.searchCities(query);
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void _navigateToWeather(Results city) async {
    if (city.name == null || city.country == null || city.latitude == null || city.longitude == null) {
      Get.snackbar(
        'Incomplete Data',
        'Cannot show weather for this location',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await _cityController.addToRecentSearches('${city.name}, ${city.country}');

    Get.toNamed(
      '/weather',
      arguments: {
        'lat': city.latitude,
        'lon': city.longitude,
        'cityName': '${city.name}, ${city.country}',
      },
    );
  }
}
