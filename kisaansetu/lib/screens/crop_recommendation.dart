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