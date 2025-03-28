import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kisaansetu/services/api_service.dart';
import 'package:kisaansetu/widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';

class CropRecommendationScreen extends StatefulWidget {
  const CropRecommendationScreen({Key? key}) : super(key: key);

  @override
  State<CropRecommendationScreen> createState() => _CropRecommendationScreenState();
}

class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _weatherData;
  List<Map<String, dynamic>>? _recommendations;
  String? _errorMessage;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      setState(() => _isLoading = true);
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() => _currentPosition = position);
        await _fetchWeatherData();
      } catch (e) {
        setState(() {
          _errorMessage = 'Location access needed for best recommendations';
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Please enable location for crop suggestions';
      });
    }
  }

  Future<void> _fetchWeatherData() async {
    if (_currentPosition == null) return;

    try {
      final weatherData = await ApiService().getCurrentWeather(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
      );
      setState(() {
        _weatherData = weatherData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Weather data unavailable';
        _isLoading = false;
      });
    }
  }

  Future<void> _generateRecommendations() async {
    if (_currentPosition == null || _weatherData == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _recommendations = null;
    });

    try {
      final prompt = '''
Suggest 5 best crops to grow in ${_weatherData!['name']} right now considering:
- Weather: ${_weatherData!['weather'][0]['main']}
- Temperature: ${_weatherData!['main']['temp']}°C
- Humidity: ${_weatherData!['main']['humidity']}%
- Local market demand

For each crop provide:
1. Name (clean format, no special chars)
2. One-line suitability reason
3. Detailed growing method
4. Financial benefits (market price, demand, profit margin)
5. Additional advantages
''';

      final response = await ApiService().getChatbotResponse(
        prompt,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        weatherData: _weatherData,
      );

      _parseRecommendations(response);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to get recommendations';
        _isLoading = false;
      });
    }
  }

  void _parseRecommendations(String response) {
    final recommendations = <Map<String, dynamic>>[];
    final cropSections = response.split(RegExp(r'\n\d+\.'));

    for (var section in cropSections) {
      if (section.trim().isEmpty) continue;

      final lines = section.trim().split('\n');
      if (lines.isEmpty) continue;

      // Clean crop name - remove special chars and extra spaces
      final cropName = lines[0].trim().replaceAll(RegExp(r'[^\w\s]+'), '');

      String reason = '';
      String instructions = '';
      String financial = '';
      String benefits = '';

      for (var line in lines.skip(1)) {
        line = line.trim();
        if (line.startsWith('Why:')) reason = line.replaceAll('Why:', '').trim();
        else if (line.startsWith('How:')) instructions = line.replaceAll('How:', '').trim();
        else if (line.startsWith('Financial:')) financial = line.replaceAll('Financial:', '').trim();
        else if (line.startsWith('Benefits:')) benefits = line.replaceAll('Benefits:', '').trim();
        else if (reason.isEmpty) reason = line;
        else if (instructions.isEmpty) instructions += '\n$line';
        else if (financial.isEmpty) financial += '\n$line';
        else benefits += '\n$line';
      }

      if (cropName.isNotEmpty) {
        recommendations.add({
          'name': cropName,
          'reason': reason,
          'instructions': instructions,
          'financial': financial,
          'benefits': benefits,
        });
      }
    }

    setState(() {
      _recommendations = recommendations.take(5).toList();
      _isLoading = false;
    });
  }

  void _showCropDetails(Map<String, dynamic> crop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(crop['name']),
            backgroundColor: Colors.green.shade700,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crop['name'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  crop['reason'],
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                _buildDetailCard('Growing Method', crop['instructions']),
                _buildDetailCard('Financial Benefits', crop['financial']),
                _buildDetailCard('Additional Advantages', crop['benefits']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Best Crops For You'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFE8F5E9)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (_weatherData != null) ...[
                Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        _getWeatherIcon(_weatherData!['weather'][0]['main']),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_weatherData!['name']}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('${_weatherData!['main']['temp'].round()}°C | ${_weatherData!['weather'][0]['main']}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              CustomButton(
                text: 'Find Best Crops',
                onPressed: _isLoading ? () {} : _generateRecommendations,
                color: Colors.green.shade700,
              ),
              const SizedBox(height: 16),
              if (_isLoading) const CircularProgressIndicator(),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              if (_recommendations != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'Recommended Crops:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    itemCount: _recommendations!.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final crop = _recommendations![index];
                      return Card(
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            crop['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(crop['reason']),
                          trailing: const Icon(Icons.info_outline, color: Colors.green),
                          onTap: () => _showCropDetails(crop),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _getWeatherIcon(String condition) {
    IconData icon;
    Color color;

    switch (condition.toLowerCase()) {
      case 'rain':
        icon = Icons.umbrella;
        color = Colors.blue.shade700;
        break;
      case 'clouds':
        icon = Icons.cloud;
        color = Colors.blueGrey;
        break;
      case 'clear':
        icon = Icons.wb_sunny;
        color = Colors.amber;
        break;
      default:
        icon = Icons.device_thermostat;
        color = Colors.grey;
    }

    return Icon(icon, color: color, size: 36);
  }
}

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// class CropRecommendationScreen extends StatefulWidget {
//   @override
//   _CropRecommendationScreenState createState() => _CropRecommendationScreenState();
// }

// class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
//   bool _isLoading = false;
//   bool _locationLoading = false;
//   List<dynamic> _recommendations = [];
//   String _errorMessage = '';
//   String _locationName = 'Fetching location...';
//   double? _latitude;
//   double? _longitude;
//   double? _temperature;
//   double? _humidity;
//   double? _rainfall;
//   double _phValue = 6.5; // Default soil pH (can be improved with soil APIs)

//   // OpenWeatherMap API Key - replace with your own
//   final String _weatherApiKey = '7e3cac2d274dba29e7551e1f3b582971';
//   final String _backendUrl = 'http://192.168.74.180:5000/recommend_crops';

//   @override
//   void initState() {
//     super.initState();
//     _determinePosition();
//   }

//   Future<void> _determinePosition() async {
//     setState(() {
//       _locationLoading = true;
//     });

//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         throw 'Location services are disabled.';
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw 'Location permissions are denied';
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         throw 'Location permissions are permanently denied, we cannot request permissions.';
//       }

//       Position position = await Geolocator.getCurrentPosition();
//       setState(() {
//         _latitude = position.latitude;
//         _longitude = position.longitude;
//       });

//       await _getLocationName(position.latitude, position.longitude);
//       await _fetchWeatherData(position.latitude, position.longitude);
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Could not get location: $e';
//         _locationLoading = false;
//       });
//     }
//   }

//   Future<void> _getLocationName(double lat, double lng) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
//       Placemark place = placemarks[0];
//       setState(() {
//         _locationName = '${place.locality}, ${place.administrativeArea}, ${place.country}';
//       });
//     } catch (e) {
//       setState(() {
//         _locationName = 'Location: $lat, $lng';
//       });
//     }
//   }

//   Future<void> _fetchWeatherData(double lat, double lng) async {
//   try {
//     final response = await http.get(
//       Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&units=metric&appid=$_weatherApiKey'),
//     );

//     debugPrint('Weather API Response: ${response.body}'); // Debug the full response

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       debugPrint('Parsed Weather Data: $data'); // Debug parsed data

//       // Safely extract values with null checks
//       final mainData = data['main'] ?? {};
//       final rainData = data['rain'] ?? {};

//       setState(() {
//         _temperature = mainData['temp']?.toDouble();
//         _humidity = mainData['humidity']?.toDouble();
//         _rainfall = rainData['1h']?.toDouble() ?? 0.0; // Default to 0 if no rain
        
//         debugPrint('Extracted Values - '
//           'Temp: $_temperature, '
//           'Humidity: $_humidity, '
//           'Rainfall: $_rainfall');
        
//         _locationLoading = false;
//       });

//       // Check if we have all required data
//       if (_temperature == null || _humidity == null) {
//         throw 'Incomplete weather data received';
//       }
      
//       _getRecommendations();
//     } else {
//       throw 'API Error: ${response.statusCode} - ${response.reasonPhrase}';
//     }
//   } catch (e) {
//     debugPrint('Error fetching weather: $e');
//     setState(() {
//       _errorMessage = 'Weather data unavailable. Using default values.';
//       _temperature = _temperature ?? 25.0; // Default fallback
//       _humidity = _humidity ?? 60.0; // Default fallback
//       _rainfall = _rainfall ?? 0.0;
//       _locationLoading = false;
//     });
//     _getRecommendations(); // Proceed with fallback values
//   }
// }

//   Future<void> _getRecommendations() async {
//     if (_temperature == null || _humidity == null || _rainfall == null) {
//       setState(() {
//         _errorMessage = 'Weather data not available yet';
//         // Show error message and return without making API call
//         //i want to debug print to check which value is null
//         debugPrint('Temperature: $_temperature, Humidity: $_humidity, Rainfall: $_rainfall');
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _recommendations = [];
//       _errorMessage = '';
//     });

//     try {
//       final response = await http.post(
//         Uri.parse(_backendUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'temperature': _temperature,
//           'humidity': _humidity,
//           'rainfall': _rainfall,
//           'ph': _phValue,
//           'duration': 3, // Default duration (can be made configurable)
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           _recommendations = data['recommendations'];
//         });
//       } else {
//         throw 'Failed to get recommendations: ${response.reasonPhrase}';
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error: ${e.toString()}';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Smart Crop Recommendation'),
//         centerTitle: true,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () {
//               _determinePosition();
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Card(
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     ListTile(
//                       leading: Icon(Icons.location_on, color: Colors.blue),
//                       title: Text(_locationName),
//                       subtitle: _locationLoading
//                           ? LinearProgressIndicator()
//                           : Text('Tap refresh to update location'),
//                     ),
//                     Divider(),
//                     if (_temperature != null) _buildWeatherInfo('Temperature', '${_temperature!.toStringAsFixed(1)}°C', Icons.thermostat),
//                     if (_humidity != null) _buildWeatherInfo('Humidity', '${_humidity!.toStringAsFixed(1)}%', Icons.water_drop),
//                     if (_rainfall != null) _buildWeatherInfo('Rainfall', '${_rainfall!.toStringAsFixed(1)} mm', Icons.umbrella),
//                     _buildWeatherInfo('Soil pH', '${_phValue.toStringAsFixed(1)}', Icons.grass),
//                     SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: _isLoading ? null : _getRecommendations,
//                       child: _isLoading
//                           ? CircularProgressIndicator(color: Colors.white)
//                           : Text('Get Smart Recommendations'),
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: Size(double.infinity, 50),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             if (_errorMessage.isNotEmpty)
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8),
//                 child: Text(
//                   _errorMessage,
//                   style: TextStyle(color: Colors.red, fontSize: 16),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             if (_recommendations.isNotEmpty)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Recommended Crops for Your Location',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   ..._recommendations.map((crop) => _buildCropCard(crop)).toList(),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWeatherInfo(String label, String value, IconData icon) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(icon, size: 24, color: Colors.blue),
//           SizedBox(width: 16),
//           Text(
//             label,
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//           Spacer(),
//           Text(
//             value,
//             style: TextStyle(fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCropCard(Map<String, dynamic> crop) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 12),
//       elevation: 3,
//       child: ExpansionTile(
//         title: Text(
//           crop['name'],
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(
//           'Confidence: ${(crop['probability'] * 100).toStringAsFixed(1)}%',
//           style: TextStyle(color: Colors.green),
//         ),
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildDetailRow('Description', crop['description']),
//                 _buildDetailRow('Season', crop['season'] ?? 'Not specified'),
//                 _buildDetailRow('Soil Type', crop['soil'] ?? 'Not specified'),
//                 _buildDetailRow('Water Requirements', crop['water'] ?? 'Not specified'),
//                 _buildDetailRow('Temperature Range', crop['temperature'] ?? 'Not specified'),
//                 _buildDetailRow('Soil pH Range', crop['ph'] ?? 'Not specified'),
//                 _buildDetailRow('Duration', crop['duration'] ?? 'Not specified'),
//                 _buildDetailRow('Expected Yield', crop['yield'] ?? 'Not specified'),
//                 SizedBox(height: 12),
//                 if (crop['fertilizer'] != null)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Fertilizer Requirements:',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 4),
//                       ...(crop['fertilizer'] as Map<String, dynamic>).entries.map(
//                         (e) => Padding(
//                           padding: EdgeInsets.only(left: 8, bottom: 4),
//                           child: Text('${e.key}: ${e.value}'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 SizedBox(height: 12),
//                 if (crop['process'] != null && (crop['process'] as List).isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Growing Process:',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 8),
//                       ...(crop['process'] as List).map(
//                         (stage) => Padding(
//                           padding: EdgeInsets.only(left: 8, bottom: 8),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 '${stage['stage']} (${stage['time']})',
//                                 style: TextStyle(fontWeight: FontWeight.w600),
//                               ),
//                               Text(stage['details']),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 8),
//       child: RichText(
//         text: TextSpan(
//           style: TextStyle(color: Colors.black87, fontSize: 14),
//           children: [
//             TextSpan(
//               text: '$label: ',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             TextSpan(text: value),
//           ],
//         ),
//       ),
//     );
//   }
// }