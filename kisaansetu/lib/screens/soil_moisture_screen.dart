import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class SoilMoistureScreen extends StatefulWidget {
  const SoilMoistureScreen({Key? key}) : super(key: key);

  @override
  _SoilMoistureScreenState createState() => _SoilMoistureScreenState();
}

class _SoilMoistureScreenState extends State<SoilMoistureScreen> {
  final String apiKey = '5f28e4cc234bce862f7ed11116adde7e';
  final String baseUrl = 'http://api.agromonitoring.com/agro/1.0/soil';
  
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  
  double? moisture;
  double? temperature;
  String? lastUpdated;
  String? recommendation;
  
  @override
  void initState() {
    super.initState();
    _fetchSoilData();
  }
  
  Future<void> _fetchSoilData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    
    try {
      // Check and request location permission
      var status = await Permission.location.status;
      if (!status.isGranted) {
        status = await Permission.location.request();
        if (!status.isGranted) {
          throw Exception('Location access is needed to get soil data');
        }
      }
      
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
      
      // Fetch soil data
      final response = await http.get(
        Uri.parse('$baseUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        setState(() {
          moisture = data['moisture']?.toDouble();
          temperature = data['temperature']?.toDouble();
          lastUpdated = _formatDate(DateTime.now());
          recommendation = _getRecommendation(moisture);
          isLoading = false;
        });
      } else {
        throw Exception('Could not get soil data. Please try again later.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
  
  String _getRecommendation(double? moisture) {
    if (moisture == null) return 'Data not available';
    
    if (moisture < 20) {
      return '❌ Soil too dry - Water your fields immediately';
    } else if (moisture < 40) {
      return '⚠️ Soil dry - Water your fields soon';
    } else if (moisture < 60) {
      return '✅ Perfect moisture - Good for crops';
    } else if (moisture < 80) {
      return '🌧️ Soil moist - No need to water now';
    } else {
      return '💧 Soil too wet - Stop watering to avoid damage';
    }
  }
  
  Color _getMoistureColor(double? moisture) {
    if (moisture == null) return Colors.grey;
    
    if (moisture < 20) return Colors.red;
    if (moisture < 40) return Colors.orange;
    if (moisture < 60) return Colors.green;
    if (moisture < 80) return Colors.blue;
    return Colors.purple;
  }
  
  String _getMoistureStatus(double? moisture) {
    if (moisture == null) return 'Not available';
    
    if (moisture < 20) return 'Very Dry';
    if (moisture < 40) return 'Dry';
    if (moisture < 60) return 'Good';
    if (moisture < 80) return 'Moist';
    return 'Too Wet';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soil Health Check'),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchSoilData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SingleChildScrollView(  // Added to fix overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Main Soil Status Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : hasError
                        ? Column(
                            children: [
                              const Icon(Icons.error_outline, size: 50, color: Colors.red),
                              const SizedBox(height: 16),
                              Text(
                                errorMessage,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchSoilData,
                                child: const Text('Try Again'),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              const Text(
                                'Your Soil Status',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Moisture Indicator
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _getMoistureColor(moisture).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '${moisture?.toStringAsFixed(0) ?? '--'}%',
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: _getMoistureColor(moisture),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _getMoistureStatus(moisture),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: _getMoistureColor(moisture),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Soil Temperature
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.thermostat, color: Colors.orange),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Soil Temp: ${temperature?.toStringAsFixed(1) ?? '--'}°C',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Last Updated
                              Text(
                                'Updated: $lastUpdated',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Recommendation Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.lightGreen.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What Should You Do?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      recommendation ?? 'No recommendation available',
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Help Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Understanding Soil Moisture',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('0-20%', 'Very Dry', 'Water immediately'),
                    _buildInfoRow('20-40%', 'Dry', 'Water soon'),
                    _buildInfoRow('40-60%', 'Good', 'Ideal for crops'),
                    _buildInfoRow('60-80%', 'Moist', 'No need to water'),
                    _buildInfoRow('80-100%', 'Too Wet', 'Stop watering'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String percentage, String status, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            child: Text(
              percentage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text('$status - $action'),
          ),
        ],
      ),
    );
  }
}