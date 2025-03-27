// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:kisaansetu/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  Map<String, dynamic> _currentWeather = {};
  Map<String, dynamic> _forecastData = {};
  List<dynamic> _weatherAlerts = [];
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      var status = await Permission.location.request();
      if (status.isGranted) {
        setState(() => _isLoading = true);
        _currentPosition = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high,
        );
        await _fetchWeatherData();
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = 'Location permission is required to show weather data.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to get location: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchWeatherData() async {
    if (_currentPosition == null) return;

    try {
      final currentWeather = await _apiService.getCurrentWeather(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
      );

      final forecast = await _apiService.getWeatherForecast(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
      );

      List<dynamic> alerts = _generateMockAlerts(forecast);

      if (mounted) {
        setState(() {
          _currentWeather = currentWeather;
          _forecastData = forecast;
          _weatherAlerts = alerts;
          _isLoading = false;
          _hasError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to fetch weather data: $e';
          _isLoading = false;
        });
      }
    }
  }

  List<dynamic> _generateMockAlerts(Map<String, dynamic> forecast) {
    List<dynamic> alerts = [];
    try {
      List<dynamic> forecastList = forecast['list'] ?? [];
      if (forecastList.isNotEmpty) {
        for (var hourlyForecast in forecastList.take(8)) {
          double temp = hourlyForecast['main']['temp'] ?? 0;
          if (temp > 40) {
            alerts.add({
              'type': 'Extreme Heat',
              'description': 'Temperature expected to rise above 40°C. Take precautions.',
              'time': hourlyForecast['dt_txt'],
              'severity': 'high',
              'icon': 'hot',
            });
            break;
          }
        }

        for (var hourlyForecast in forecastList.take(8)) {
          var weather = hourlyForecast['weather'];
          if (weather != null && weather.isNotEmpty && weather[0]['main'] == 'Rain') {
            double rainAmount = hourlyForecast['rain']?['3h'] ?? 0;
            if (rainAmount > 10) {
              alerts.add({
                'type': 'Heavy Rain',
                'description': 'Heavy rainfall expected. Consider protecting crops.',
                'time': hourlyForecast['dt_txt'],
                'severity': 'medium',
                'icon': 'rain',
              });
              break;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error generating alerts: $e');
    }
    return alerts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Information'),
        elevation: 0,
        backgroundColor: Colors.green.shade600,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchWeatherData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? _buildErrorView()
              : _buildWeatherView(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherView() {
    return RefreshIndicator(
      onRefresh: _fetchWeatherData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCurrentWeather(),
              const SizedBox(height: 24),
              if (_weatherAlerts.isNotEmpty) ...[
                _buildWeatherAlerts(),
                const SizedBox(height: 24),
              ],
              _buildHourlyForecast(),
              const SizedBox(height: 24),
              _buildDailyForecast(),
              const SizedBox(height: 24),
              _buildWeatherMap(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentWeather() {
    try {
      if (_currentWeather.isEmpty || _currentWeather['weather'] == null || _currentWeather['main'] == null) {
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No current weather data available'),
          ),
        );
      }

      final weather = _currentWeather['weather'][0];
      final main = _currentWeather['main'];
      final wind = _currentWeather['wind'] ?? {'speed': 0};
      final location = _currentWeather['name'] ?? 'Unknown Location';
      final weatherCondition = weather['main']?.toLowerCase() ?? 'clear';

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _getGradientColors(weatherCondition),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      DateFormat('E, d MMM').format(DateTime.now()),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${main['temp'].toStringAsFixed(1)}°',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Feels like ${main['feels_like'].toStringAsFixed(1)}°',
                          style: const TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            // ignore: duplicate_ignore
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '↑${main['temp_max'].toStringAsFixed(1)}° ↓${main['temp_min'].toStringAsFixed(1)}°',
                            style: const TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        _getWeatherIconWidget(weatherCondition),
                        const SizedBox(height: 8),
                        Text(
                          weather['description'] ?? '',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _weatherDetailItem(
                        BoxedIcon(WeatherIcons.humidity, size: 20, color: Colors.white),
                        'Humidity',
                        '${main['humidity']}%',
                      ),
                      _weatherDetailItem(
                        BoxedIcon(WeatherIcons.strong_wind, size: 20, color: Colors.white),
                        'Wind',
                        '${wind['speed']} m/s',
                      ),
                      _weatherDetailItem(
                        BoxedIcon(WeatherIcons.barometer, size: 20, color: Colors.white),
                        'Pressure',
                        '${main['pressure']} hPa',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error in current weather: $e');
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Error loading current weather data'),
        ),
      );
    }
  }

  List<Color> _getGradientColors(String condition) {
    switch (condition) {
      case 'clear':
        return [Colors.blue.shade300, Colors.blue.shade600];
      case 'clouds':
        return [Colors.blueGrey.shade300, Colors.blueGrey.shade700];
      case 'rain':
        return [Colors.indigo.shade300, Colors.indigo.shade800];
      case 'thunderstorm':
        return [Colors.deepPurple.shade400, Colors.deepPurple.shade900];
      case 'snow':
        return [Colors.lightBlue.shade100, Colors.lightBlue.shade300];
      default:
        return [Colors.blue.shade300, Colors.blue.shade600];
    }
  }

  Widget _weatherDetailItem(Widget icon, String title, String value) {
    return Column(
      children: [
        icon,
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }

  Widget _getWeatherIconWidget(String condition) {
    IconData iconData;
    double size = 60;
    Color color = Colors.white;

    switch (condition) {
      case 'clear':
        iconData = WeatherIcons.day_sunny;
        break;
      case 'clouds':
        iconData = WeatherIcons.cloudy;
        break;
      case 'rain':
        iconData = WeatherIcons.rain;
        break;
      case 'drizzle':
        iconData = WeatherIcons.sprinkle;
        break;
      case 'thunderstorm':
        iconData = WeatherIcons.thunderstorm;
        break;
      case 'snow':
        iconData = WeatherIcons.snow;
        break;
      case 'mist':
      case 'fog':
        iconData = WeatherIcons.fog;
        break;
      default:
        iconData = WeatherIcons.day_sunny;
    }

    return BoxedIcon(iconData, size: size, color: color);
  }

  Widget _buildWeatherAlerts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.warning_amber, color: Colors.orange),
            SizedBox(width: 8),
            Text(
              'Weather Alerts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _weatherAlerts.length,
          itemBuilder: (context, index) {
            final alert = _weatherAlerts[index];
            Color alertColor = alert['severity'] == 'high'
                ? Colors.red
                : alert['severity'] == 'medium'
                    ? Colors.orange
                    : Colors.yellow;

            IconData alertIcon = alert['icon'] == 'hot'
                ? WeatherIcons.hot
                : alert['icon'] == 'rain'
                    ? WeatherIcons.rain
                    : Icons.warning_amber;

            return Card(
              elevation: 2,
              color: alertColor.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: alertColor, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: alertColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: BoxedIcon(alertIcon, color: alertColor, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alert['type'] ?? 'Alert',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: alertColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(alert['description'] ?? ''),
                          if (alert['time'] != null)
                            Text(
                              'Expected: ${DateFormat('E, d MMM HH:mm').format(DateTime.parse(alert['time']))}',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHourlyForecast() {
    try {
      List<dynamic> hourlyData = _forecastData['list'] ?? [];
      if (hourlyData.isEmpty) {
        return const Text('No hourly forecast data available');
      }

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.access_time, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '24-Hour Forecast',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: hourlyData.length > 8 ? 8 : hourlyData.length,
                  itemBuilder: (context, index) {
                    try {
                      final hourData = hourlyData[index];
                      final time = DateTime.parse(hourData['dt_txt'] ?? DateTime.now().toIso8601String());
                      final temp = hourData['main']?['temp'] ?? 0.0;
                      final weather = hourData['weather'];
                      final condition = weather != null && weather.isNotEmpty
                          ? weather[0]['main']?.toLowerCase() ?? 'clear'
                          : 'clear';

                      return Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: index == 0 ? Colors.blue.shade50 : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: index == 0 ? Colors.blue.shade200 : Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              index == 0 ? 'Now' : DateFormat('HH:mm').format(time),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
                                color: index == 0 ? Colors.blue.shade700 : Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            BoxedIcon(
                              _getWeatherIcon(condition),
                              size: 28,
                              color: index == 0 ? Colors.blue.shade700 : Colors.grey.shade700,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${temp.toStringAsFixed(1)}°',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: index == 0 ? Colors.blue.shade700 : Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      );
                    } catch (e) {
                      debugPrint('Error in hourly item $index: $e');
                      return const SizedBox(width: 80);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error in hourly forecast: $e');
      return const Text('Error loading hourly forecast');
    }
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition) {
      case 'clear':
        return WeatherIcons.day_sunny;
      case 'clouds':
        return WeatherIcons.cloudy;
      case 'rain':
        return WeatherIcons.rain;
      case 'drizzle':
        return WeatherIcons.sprinkle;
      case 'thunderstorm':
        return WeatherIcons.thunderstorm;
      case 'snow':
        return WeatherIcons.snow;
      case 'mist':
      case 'fog':
        return WeatherIcons.fog;
      default:
        return WeatherIcons.day_sunny;
    }
  }

  Widget _buildDailyForecast() {
    try {
      List<dynamic> forecastList = _forecastData['list'] ?? [];
      if (forecastList.isEmpty) {
        return const Text('No daily forecast data available');
      }

      Map<String, List<dynamic>> dailyForecasts = {};
      for (var forecast in forecastList) {
        try {
          DateTime date = DateTime.parse(forecast['dt_txt'] ?? '');
          String dayKey = DateFormat('yyyy-MM-dd').format(date);
          if (!dailyForecasts.containsKey(dayKey)) {
            dailyForecasts[dayKey] = [];
          }
          dailyForecasts[dayKey]!.add(forecast);
        } catch (e) {
          debugPrint('Error processing forecast item: $e');
        }
      }

      List<String> sortedKeys = dailyForecasts.keys.toList()..sort();
      if (sortedKeys.isEmpty) {
        return const Text('Could not organize forecast data');
      }

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.calendar_today, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '5-Day Forecast',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedKeys.length > 5 ? 5 : sortedKeys.length,
                separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200),
                itemBuilder: (context, index) {
                  try {
                    String dayKey = sortedKeys[index];
                    List<dynamic> dayForecasts = dailyForecasts[dayKey]!;

                    double maxTemp = dayForecasts.fold(
                      -100,
                      (prev, forecast) => math.max(prev, forecast['main']?['temp_max'] ?? prev),
                    );
                    double minTemp = dayForecasts.fold(
                      100,
                      (prev, forecast) => math.min(prev, forecast['main']?['temp_min'] ?? prev),
                    );

                    var middayForecast = dayForecasts[dayForecasts.length ~/ 2];
                    var weather = middayForecast['weather'];
                    String condition = weather != null && weather.isNotEmpty
                        ? weather[0]['main']?.toLowerCase() ?? 'clear'
                        : 'clear';
                    String description = weather != null && weather.isNotEmpty
                        ? weather[0]['description'] ?? 'Unknown'
                        : 'Unknown';

                    DateTime date = DateTime.parse(dayKey);
                    String dayName = index == 0
                        ? 'Today'
                        : index == 1
                            ? 'Tomorrow'
                            : DateFormat('EEEE').format(date);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              dayName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          BoxedIcon(_getWeatherIcon(condition), size: 24),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                description,
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${minTemp.toStringAsFixed(0)}°',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                width: 60,
                                height: 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  gradient: LinearGradient(
                                    colors: [Colors.blue.shade500, Colors.red.shade500],
                                  ),
                                ),
                              ),
                              Text(
                                '${maxTemp.toStringAsFixed(0)}°',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } catch (e) {
                    debugPrint('Error in daily item $index: $e');
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Error loading forecast'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error in daily forecast: $e');
      return const Text('Error loading daily forecast');
    }
  }

  Widget _buildWeatherMap() {
    if (_currentPosition == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.map, size: 20),
                SizedBox(width: 8),
                Text(
                  'Weather Map',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    initialZoom: 9.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openweathermap.org/map/precipitation_new/{z}/{x}/{y}.png?appid=${ApiService.weatherApiKey}',
                      additionalOptions: {'appId': ApiService.weatherApiKey},
                    ),
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                          ),
                          width: 80,
                          height: 80,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _mapLegendItem(Colors.blue.withOpacity(0.3), 'Light Rain'),
                  _mapLegendItem(Colors.blue.withOpacity(0.6), 'Moderate Rain'),
                  _mapLegendItem(Colors.blue.withOpacity(0.9), 'Heavy Rain'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}