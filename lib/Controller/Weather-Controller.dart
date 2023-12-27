import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

import '../consts.dart';

class WeatherController extends GetxController {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Rx<Weather?> weather = Rx<Weather?>(null);
  RxBool isLoading = RxBool(false);
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();


  @override
  void onInit() {
    super.onInit();
    getWeather('Faisalabad');
  }
  Future<String> _getCurrentCity() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Use a reverse geocoding service to get the city name from the coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Extract the city name from the placemarks
      String currentCity = placemarks.isNotEmpty ? placemarks.first.locality ?? "Unknown" : "Unknown";

      return currentCity;
    } catch (e) {
      // Handle errors related to location services
      return "Unknown";
    }
  }


  Future<void> getWeather(String cityName) async {
    BuildContext? context;
    try {
      isLoading(true); // Set loading to true when starting the search
      Weather? w = await _wf.currentWeatherByCityName(cityName);

      print('Current Weather is.....$w');

      // if (cityName.isNotEmpty) {
      //   getWeather(cityName);
      // }

      weather(w);
    } catch (e) {
      // Handle errors as needed
      print("Error fetching weather: $e");
      // Show an error message to the user
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(
          content: Text('City not found. Please enter a valid city name.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      isLoading(false); // Set loading to false after completing the search
    }
  }
  Future<void> getCurrentLocationWeather() async {
    try {
      String currentCity = await _getCurrentCity(); //// Get the current city
      print('Here is the current city....$currentCity');
      await getWeather(currentCity);
    } catch (e) {
      // Handle errors as needed
    }
  }
}
