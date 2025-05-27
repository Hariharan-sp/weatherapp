import 'package:get/get.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';

class WeatherController extends GetxController {
  final ApiService _apiService = ApiService();
  final Rx<Weather?> weather = Rx<Weather?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> fetchWeather(double lat, double lon) async {
    isLoading.value = true;
    error.value = '';
    try {
      final result = await _apiService.getWeather(lat, lon);
      weather.value = result;
    } catch (e) {
      error.value = 'Failed to fetch weather: $e';
      weather.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}