import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:kisaansetu/services/api_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class FertilizerRecommendationScreen extends StatefulWidget {
  const FertilizerRecommendationScreen({Key? key}) : super(key: key);

  @override
  _FertilizerRecommendationScreenState createState() =>
      _FertilizerRecommendationScreenState();
}

class _FertilizerRecommendationScreenState
    extends State<FertilizerRecommendationScreen> {
  final TextEditingController _cropController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  bool _isLoading = false;
  String _recommendation = '';
  String _location = 'Fetching location...';
  String _weatherSummary = '';
  String _placeName = '';
  final String _geminiApiKey = 'AIzaSyCPf2GtBruvCynh3Sf5wyncMeFPPwQWyj0';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _cropController.dispose();
    _monthsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getRecommendation() async {
    if (_cropController.text.isEmpty || _monthsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both crop name and planting months')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _recommendation = '';
    });

    try {
      await _getWeatherData();

final prompt = '''
Analyze ${_cropController.text} cultivation during ${_monthsController.text} in $_placeName.
Respond in this exact structured format:

**Suitability Analysis:**
- [✔/✘] 1-line verdict
- Climate: [bullet point]
- Soil: [bullet point]
- Risks: [bullet point]

**Recommended Fertilizers (always provide 3):**
1. **Name:** [Fertilizer 1]
   - Composition: [NPK + micronutrients]
   - Dosage: [amount/area]
   - Timing: [growth stage]
   - Benefits: [1 line]

2. **Name:** [Fertilizer 2]
   [Same format...]

3. **Name:** [Fertilizer 3]
   [Same format...]

**Management Notes:**
- [Bullet 1: Best alternative crop if unsuitable]
- [Bullet 2: Ideal planting window]
- [Bullet 3: Critical precaution]
''';

      final model = GenerativeModel(
        model: 'gemini-1.5-pro-latest',
        apiKey: _geminiApiKey,
      );

      final response = await model.generateContent([Content.text(prompt)]);
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });

      setState(() {
        _recommendation = response.text ?? 'No recommendation available';
      });
    } catch (e) {
      setState(() {
        _recommendation = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      var status = await Permission.location.status;
      if (!status.isGranted) {
        status = await Permission.location.request();
        if (!status.isGranted) {
          setState(() {
            _location = 'Location permission denied';
            _placeName = 'Unknown location';
          });
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _location = '${position.latitude.toStringAsFixed(2)}°N, ${position.longitude.toStringAsFixed(2)}°E';
        _placeName = placemarks.isNotEmpty 
            ? '${placemarks[0].locality}, ${placemarks[0].administrativeArea}' 
            : 'Current location';
      });
    } catch (e) {
      setState(() {
        _location = 'Location unavailable';
        _placeName = 'Unknown location';
      });
    }
  }

  Future<void> _getWeatherData() async {
    try {
      final apiService = ApiService();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      final weatherData = await apiService.getCurrentWeather(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      setState(() {
        _weatherSummary = '${weatherData['weather'][0]['main']}, ${weatherData['main']['temp'].round()}°C, Humidity: ${weatherData['main']['humidity']}%';
      });
    } catch (e) {
      setState(() {
        _weatherSummary = 'Weather data unavailable';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fertilizer Recommendation'),
        backgroundColor: Colors.green.shade700,
        elevation: 4,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Input Section
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextField(
                              controller: _cropController,
                              decoration: InputDecoration(
                                labelText: 'Crop Name',
                                border: OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _monthsController,
                              decoration: InputDecoration(
                                labelText: 'Planting Period (Months)',
                                border: OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Location Info
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(_placeName),
                            Text(
                              'Weather: $_weatherSummary',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Recommendation Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _getRecommendation,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green.shade700,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Get Fertilizer Recommendation'),
                    ),

                    const SizedBox(height: 20),

                    // Results Section
                    if (_recommendation.isNotEmpty)
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Recommendation for ${_cropController.text}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.green.shade700,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _recommendation,
                                style: const TextStyle(height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    // Spacer to prevent overflow
                    if (_recommendation.isEmpty) const Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}