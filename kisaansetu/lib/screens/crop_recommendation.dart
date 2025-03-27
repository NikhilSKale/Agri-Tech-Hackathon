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

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// class CropRecommendationScreen extends StatefulWidget {
//   final Map<String, dynamic> weatherData;
  
//   const CropRecommendationScreen({
//     Key? key,
//     required this.weatherData,
//   }) : super(key: key);

//   @override
//   _CropRecommendationScreenState createState() => _CropRecommendationScreenState();
// }

// class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
//   bool _isLoading = false;
//   String _errorMessage = '';
//   List<dynamic> _recommendedCrops = [];
//   int _duration = 6; // Default duration in months
//   Position? _currentPosition;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       var status = await Permission.location.request();
//       if (status.isGranted) {
//         setState(() => _isLoading = true);
//         _currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.medium,
//         );
//         await _fetchCropRecommendations();
//       } else {
//         setState(() {
//           _errorMessage = 'Location permission helps provide more accurate recommendations.';
//         });
//         // Proceed without location
//         await _fetchCropRecommendations();
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Location service unavailable. Using general recommendations.';
//       });
//       // Proceed without location
//       await _fetchCropRecommendations();
//     }
//   }

//   Future<void> _fetchCropRecommendations() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });

//     try {
//       final response = await http.post(
//         Uri.parse('http://YOUR_FLASK_SERVER_IP:5000/recommend-crops'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'temperature': widget.weatherData['temperature'],
//           'humidity': widget.weatherData['humidity'],
//           'rainfall': widget.weatherData['rainfall'] ?? 0,
//           'duration': _duration,
//           'latitude': _currentPosition?.latitude,
//           'longitude': _currentPosition?.longitude,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['success'] == true) {
//           setState(() {
//             _recommendedCrops = data['crops'];
//           });
//         } else {
//           setState(() {
//             _errorMessage = data['error'] ?? 'Failed to get recommendations';
//           });
//         }
//       } else {
//         setState(() {
//           _errorMessage = 'Server error: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Connection error: $e';
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
//         title: const Text('Crop Recommendations'),
//         backgroundColor: Colors.teal.shade700,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _fetchCropRecommendations,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _buildRecommendationView(),
//     );
//   }

//   Widget _buildRecommendationView() {
//     return RefreshIndicator(
//       onRefresh: _fetchCropRecommendations,
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Weather summary card
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Current Conditions',
//                       style: TextStyle(
//                         fontSize: 16, 
//                         fontWeight: FontWeight.bold
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _buildConditionItem('Temperature', '${widget.weatherData['temperature']?.toStringAsFixed(1) ?? 'N/A'}°C'),
//                         _buildConditionItem('Humidity', '${widget.weatherData['humidity']?.toStringAsFixed(0) ?? 'N/A'}%'),
//                         _buildConditionItem('Rainfall', '${widget.weatherData['rainfall']?.toStringAsFixed(1) ?? 'N/A'} mm'),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
            
//             // Duration selector
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Select Growing Duration',
//                   style: TextStyle(
//                     fontSize: 16, 
//                     fontWeight: FontWeight.bold
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Slider(
//                   value: _duration.toDouble(),
//                   min: 3,
//                   max: 15,
//                   divisions: 12,
//                   label: '$_duration months',
//                   activeColor: Colors.teal.shade700,
//                   inactiveColor: Colors.teal.shade100,
//                   onChanged: (value) {
//                     setState(() {
//                       _duration = value.round();
//                     });
//                   },
//                   onChangeEnd: (value) {
//                     _fetchCropRecommendations();
//                   },
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: const [
//                     Text('3 months'),
//                     Text('15 months'),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
            
//             // Error message if any
//             if (_errorMessage.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 16),
//                 child: Text(
//                   _errorMessage,
//                   style: TextStyle(
//                     color: Colors.orange.shade700,
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//               ),
            
//             // Recommended crops list
//             if (_recommendedCrops.isNotEmpty) ...[
//               const Text(
//                 'Recommended Crops',
//                 style: TextStyle(
//                   fontSize: 18, 
//                   fontWeight: FontWeight.bold
//                 ),
//               ),
//               const SizedBox(height: 12),
//               ..._recommendedCrops.map((crop) => _buildCropCard(crop)).toList(),
//             ] else if (!_isLoading) ...[
//               Center(
//                 child: Column(
//                   children: [
//                     Image.asset(
//                       'assets/images/no_crops.png', // Add this asset
//                       height: 150,
//                       width: 150,
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'No crop recommendations available\nfor current conditions',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 16, 
//                         color: Colors.grey
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildConditionItem(String label, String value) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 12, 
//             color: Colors.grey
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 16, 
//             fontWeight: FontWeight.bold
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCropCard(Map<String, dynamic> crop) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ExpansionTile(
//         title: Text(
//           crop['name'],
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(
//           '${(crop['probability'] * 100).toStringAsFixed(1)}% suitable | ${crop['duration']}',
//         ),
//         leading: CircleAvatar(
//           backgroundColor: Colors.teal.shade100,
//           child: Text(
//             crop['name'][0],
//             style: TextStyle(color: Colors.teal.shade800),
//           ),
//         ),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   crop['description'],
//                   style: const TextStyle(fontStyle: FontStyle.italic),
//                 ),
//                 const SizedBox(height: 16),
                
//                 // Growing process timeline
//                 const Text(
//                   'Growing Process:',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 ...crop['process'].map((stage) => Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: 80,
//                         child: Text(
//                           stage['time'],
//                           style: const TextStyle(fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               stage['stage'],
//                               style: const TextStyle(fontWeight: FontWeight.w500),
//                             ),
//                             Text(
//                               stage['details'],
//                               style: TextStyle(color: Colors.grey.shade700),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 )).toList(),
//                 const SizedBox(height: 16),
                
//                 // Benefits section
//                 const Text(
//                   'Benefits:',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 ...crop['benefits'].map((benefit) => Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(
//                         Icons.check_circle,
//                         color: Colors.teal.shade600,
//                         size: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(child: Text(benefit)),
//                     ],
//                   ),
//                 )).toList(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }