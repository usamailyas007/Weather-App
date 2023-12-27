import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

import '../Controller/Weather-Controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  final WeatherController weatherController = Get.put(WeatherController());
  final FocusNode searchFocusNode = FocusNode();

  // final TextEditingController searchController = TextEditingController();
  // Weather? _weather;

  @override
  // void initState() {
  //   super.initState();
  //   _wf.currentWeatherByCityName("Faisalabad").then((w) {
  //     setState(() {
  //       _weather = w;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _buildUI(),
    );
  }


  Widget _buildUI() {

    return Obx((){
      Weather? _weather = weatherController.weather.value;
      if (weatherController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.07,
                ),
                _searchBar(),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('City',style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),),
                    _locationHeader(),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),
                _dateTimeInfo(),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                _weatherIcon(),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                _currentTemp(),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                _extraInfo(),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
              ],
            ),
          ),
        ),
      );
    });

  }

  Widget _locationHeader() {
    Weather? _weather = weatherController.weather.value;
    return Text(
      _weather?.areaName ?? "",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _dateTimeInfo() {
    Weather? _weather = weatherController.weather.value;
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "  ${DateFormat("d.m.y").format(now)}",
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    Weather? _weather = weatherController.weather.value;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"),
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    Weather? _weather = weatherController.weather.value;
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: const TextStyle(
        color: Colors.black,
        fontSize: 90,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _extraInfo() {
    Weather? _weather = weatherController.weather.value;
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.80,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      padding: const EdgeInsets.all(
        8.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )
            ],
          )
        ],
      ),
    );
  }


  Widget _searchBar() {

    return TextField(
      controller: weatherController.searchController,
      onSubmitted: (value) {
        // Search for the weather when the user submits the text
        weatherController.getWeather(value);

        // Clear the text in the TextField
        weatherController.searchController.clear();

        // Remove the focus from the TextField
        weatherController.searchFocusNode.unfocus();
      },
      decoration: InputDecoration(
        hintText: 'Enter City Name',
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // Search for the weather when the search button is pressed
            weatherController.getWeather(weatherController.searchController.text);

            // Remove the focus from the TextField
            searchFocusNode.unfocus();

          },
        ),
      ),
    );
  }
}
