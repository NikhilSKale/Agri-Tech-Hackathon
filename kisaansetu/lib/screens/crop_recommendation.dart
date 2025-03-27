import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kisaansetu/services/api_service.dart';
import 'package:kisaansetu/services/prompt_template_crop.dart';
import 'package:kisaansetu/widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';

class CropRecommendationScreen extends StatefulWidget {
  const CropRecommendationScreen({Key? key}) : super(key: key);

  @override
  State<CropRecommendationScreen> createState() =>
      _CropRecommendationScreenState();
}

class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
  bool _isLoading = false;
  String _selectedSoilType = 'Loamy';
  String _selectedTimeframe = 'Short-term (1-3 months)';
  Map<String, dynamic>? _weatherData;
  List<Map<String, dynamic>>? _recommendations;
  String? _errorMessage;
  Position? _currentPosition;
  String _selectedLanguage = 'English'; // Match with your HomeScreen

  final List<String> _soilTypes = [
    'Loamy',
    'Clay',
    'Sandy',
    'Silt',
    'Chalky',
    'Peaty',
  ];

  final List<String> _timeframeOptions = [
    'Short-term (1-3 months)',
    'Medium-term (3-6 months)',
    'Long-term (6+ months)',
  ];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      setState(() {
        _isLoading = true;
      });
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _currentPosition = position;
        });
        await _fetchWeatherData();
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to get location: $e';
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _errorMessage =
            'Location permission is required for accurate crop recommendations';
      });
    }
  }

  Future<void> _fetchWeatherData() async {
    if (_currentPosition == null) {
      setState(() {
        _errorMessage = 'Location information is not available';
        _isLoading = false;
      });
      return;
    }

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
        _errorMessage = 'Failed to get weather data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _generateRecommendations() async {
    if (_currentPosition == null) {
      setState(() {
        _errorMessage = 'Location information is not available';
      });
      return;
    }

    if (_weatherData == null) {
      await _fetchWeatherData();
      if (_weatherData == null) {
        return; // _fetchWeatherData will set the error message
      }
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _recommendations = null;
    });

    try {
      // Create a prompt for Gemini API based on weather, soil type, and timeframe
      final weatherCondition = _weatherData!['weather'][0]['main'];
      final temperature = _weatherData!['main']['temp'];
      final humidity = _weatherData!['main']['humidity'];
      final windSpeed = _weatherData!['wind']['speed'];
      final location = _weatherData!['name'];

      final prompt = '''
Based on the following conditions, recommend suitable crops to grow:
- Location: $location
- Current weather: $weatherCondition
- Temperature: ${temperature.toStringAsFixed(1)}°C
- Humidity: $humidity%
- Wind speed: $windSpeed m/s
- Soil type: $_selectedSoilType
- Planting timeframe: $_selectedTimeframe

Please provide 3-5 crop recommendations with the following details for each:
1. Crop name
2. Why it's suitable for these conditions
3. Care instructions
4. Expected time to harvest
''';

      // Use the chatbot API for crop recommendations
      final response = await ApiService().getChatbotResponse(
        prompt,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        weatherData: _weatherData,
        language: _selectedLanguage.toLowerCase(),
      );

      // Parse the AI response into structured recommendations
      // Since this is free-text from AI, we need to extract meaningful data
      _parseRecommendationsFromResponse(response);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to generate recommendations: $e';
        _isLoading = false;
      });
    }
  }

  void _parseRecommendationsFromResponse(String response) {
    // Simple parsing logic - this could be improved with more sophisticated parsing
    List<Map<String, dynamic>> parsedRecommendations = [];

    // Split response by numbered sections or crop names
    final sections = response.split(
      RegExp(r'\n\s*\d+\.\s+|\n\s*Crop\s+\d+:\s+'),
    );

    for (var section in sections) {
      if (section.trim().isEmpty) continue;

      try {
        // Extract the first line as the crop name
        final lines = section.trim().split('\n');
        String cropName =
            lines[0].replaceAll(RegExp(r'^[^a-zA-Z]*'), '').trim();

        // The rest is description
        String description =
            lines.length > 1 ? lines.sublist(1).join('\n').trim() : '';

        // Try to extract care instructions and harvest time if they're clearly marked
        String careInstructions = '';
        String harvestTime = '';

        if (description.contains('Care instructions:') ||
            description.contains('Care:')) {
          final careMatch = RegExp(
            r'Care instructions:|Care:(.+?)(?=Expected time|Harvest time|$)',
            dotAll: true,
          ).firstMatch(description);
          if (careMatch != null && careMatch.groupCount >= 1) {
            careInstructions = careMatch.group(1)?.trim() ?? '';
          }
        }

        if (description.contains('Expected time to harvest:') ||
            description.contains('Harvest time:')) {
          final harvestMatch = RegExp(
            r'Expected time to harvest:|Harvest time:(.+?)(?=\n\n|$)',
            dotAll: true,
          ).firstMatch(description);
          if (harvestMatch != null && harvestMatch.groupCount >= 1) {
            harvestTime = harvestMatch.group(1)?.trim() ?? '';
          }
        }

        // Only add valid crops
        if (cropName.isNotEmpty) {
          parsedRecommendations.add({
            'crop': cropName,
            'description': description,
            'care_instructions': careInstructions,
            'harvest_time': harvestTime,
          });
        }
      } catch (e) {
        print('Error parsing section: $e');
        // Continue to the next section
      }
    }

    setState(() {
      if (parsedRecommendations.isNotEmpty) {
        _recommendations = parsedRecommendations;
      } else {
        // Fallback to simple recommendation if parsing fails
        _recommendations = [
          {
            'crop': 'AI Recommendation',
            'description': response,
            'care_instructions': '',
            'harvest_time': '',
          },
        ];
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crop Recommendations',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade600,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/farm_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.85),
              BlendMode.lighten,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Weather Information Card
              if (_weatherData != null) _buildWeatherCard(),

              // Input Section
              _buildInputSection(),

              // Generate Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: CustomButton(
                  text: 'Generate Recommendations',
                  onPressed:
                      _isLoading ? () {} : () => _generateRecommendations(),
                  color: Colors.teal.shade700,
                ),
              ),

              // Loading or Error
              if (_isLoading) const Center(child: CircularProgressIndicator()),
              if (_errorMessage != null && !_isLoading)
                Card(
                  color: Colors.red.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),

              // Recommendations
              if (_recommendations != null && !_isLoading)
                Expanded(child: _buildRecommendationsList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Weather in ${_weatherData!['name']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _getWeatherIcon(_weatherData!['weather'][0]['main']),
                    const SizedBox(width: 8),
                    Text(
                      '${_weatherData!['main']['temp'].toStringAsFixed(1)}°C',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Humidity: ${_weatherData!['main']['humidity']}%'),
                    Text('Wind: ${_weatherData!['wind']['speed']} m/s'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customize Recommendations',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Soil Type Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Soil Type',
                border: OutlineInputBorder(),
              ),
              value: _selectedSoilType,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedSoilType = newValue;
                  });
                }
              },
              items:
                  _soilTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 16),

            // Timeframe Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Growing Timeframe',
                border: OutlineInputBorder(),
              ),
              value: _selectedTimeframe,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedTimeframe = newValue;
                  });
                }
              },
              items:
                  _timeframeOptions.map<DropdownMenuItem<String>>((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsList() {
    return ListView.builder(
      itemCount: _recommendations!.length,
      itemBuilder: (context, index) {
        final recommendation = _recommendations![index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        recommendation['crop'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  recommendation['description'],
                  style: const TextStyle(fontSize: 14),
                ),
                if (recommendation['care_instructions'].isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Care Instructions:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  Text(recommendation['care_instructions']),
                ],
                if (recommendation['harvest_time'].isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Harvest Time:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  Text(recommendation['harvest_time']),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getWeatherIcon(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'clear':
        return Icon(Icons.wb_sunny, color: Colors.amber, size: 32);
      case 'clouds':
        return Icon(Icons.cloud, color: Colors.grey, size: 32);
      case 'rain':
        return Icon(Icons.grain, color: Colors.blue, size: 32);
      case 'thunderstorm':
        return Icon(Icons.flash_on, color: Colors.amber, size: 32);
      case 'snow':
        return Icon(Icons.ac_unit, color: Colors.lightBlue, size: 32);
      case 'mist':
      case 'fog':
        return Icon(Icons.blur_on, color: Colors.grey, size: 32);
      default:
        return Icon(Icons.wb_sunny, color: Colors.amber, size: 32);
    }
  }
}