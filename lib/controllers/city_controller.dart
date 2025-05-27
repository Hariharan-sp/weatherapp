import 'package:get/get.dart';
import '../models/city_model.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<Results> cities = <Results>[].obs;
  final RxList<String> recentSearches = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecentSearches();
  }

  Future<void> searchCities(String query) async {
    isLoading.value = true;
    error.value = '';
    cities.clear();

    try {
      final results = await _apiService.searchCities(query);
      cities.assignAll(results);

      if (results.isEmpty) {
        error.value = 'No cities found matching "$query"';
      }
    } catch (e) {
      error.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToRecentSearches(String cityName) async {
    if (cityName.trim().isEmpty) return;
    recentSearches.removeWhere((item) => item == cityName);
    recentSearches.insert(0, cityName);
    if (recentSearches.length > 5) {
      recentSearches.removeLast();
    }
    await _saveRecentSearches();
  }

  Future<void> loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    recentSearches.assignAll(prefs.getStringList('recentSearches') ?? []);
  }

  Future<void> _saveRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recentSearches', recentSearches.toList());
  }
}
