import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:map_launcher/map_launcher.dart' as launcher;

import '../../../models/model_response/restaurants_response.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/data_session_util_controller.dart';

class FindNearbyRestaurantsController extends GetxController {
  final ApiRepository apiRepository;
  final DataSessionUtilController session;

  FindNearbyRestaurantsController({
    required this.apiRepository,
    required this.session,
  });

  final RxList<Places> restaurants = <Places>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<Position?> currentPosition = Rx<Position?>(null);

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      debugPrint("Location services enabled: $serviceEnabled");

      if (!serviceEnabled) {
        debugPrint("Location services are disabled.");
        // Fallback to a default location if needed, e.g., Jakarta
        _setFallbackLocation();
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint("Location permissions are denied.");
          _setFallbackLocation();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint("Location permissions are permanently denied.");
        _setFallbackLocation();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      currentPosition.value = position;
      await findNearbyRestaurants(position.latitude, position.longitude);
      debugPrint("Current location: ${position.latitude}, ${position.longitude}");
    } catch (e) {
      debugPrint("Error getting current location: $e");
      _setFallbackLocation();
    }
  }

  void _setFallbackLocation() {
    final fallbackPosition = Position(
      latitude: -6.2088,
      longitude: 106.8456,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
    currentPosition.value = fallbackPosition;
    findNearbyRestaurants(fallbackPosition.latitude, fallbackPosition.longitude);
  }

  Future<void> findNearbyRestaurants(double latitude, double longitude) async {
    isLoading.value = true;
    try {
      debugPrint("Fetching restaurants for lat: $latitude, lon: $longitude");
      final result = await apiRepository.getNearbyRestaurntsByCategory(
        lat: latitude,
        lon: longitude,
      );

      if (result != null && result is Map<String, dynamic>) {
        final response = FindNearbyRestaurantResponse.fromJson(result);
        restaurants.assignAll(response.places ?? []);
        debugPrint("Restaurants found: ${restaurants.length}");
      } else {
        debugPrint("Invalid API response format: $result");
      }
    } catch (e) {
      debugPrint("Error fetching nearby restaurants: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openDirections(double lat, double lon, String title) async {
    try {
      await launcher.MapLauncher.directions(
        launcher.LocationCoords(lat, lon, title: title),
      ).show();
    } catch (e) {
      debugPrint("Error launching map: $e");
    }
  }
}