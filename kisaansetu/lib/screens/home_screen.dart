// // import 'package:flutter/material.dart';
// // import 'package:kisaansetu/screens/chatbot_screen.dart';
// // import 'package:kisaansetu/screens/disease_screen.dart';
// // import 'package:kisaansetu/screens/government_schemes.dart';
// // import 'package:kisaansetu/screens/weather_screen.dart';
// // import 'package:kisaansetu/screens/market_prices.dart';
// // import 'package:kisaansetu/widgets/custom_button.dart';
// // import 'package:kisaansetu/screens/crop_recommendation.dart';

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({Key? key}) : super(key: key);

// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   String selectedLanguage = 'English';
// //   final List<String> languageOptions = [
// //     'English',
// //     'Hindi',
// //     'Punjabi',
// //     'Gujarati',
// //     'Bengali',
// //     'Marathi',
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'KisaanSetu',
// //           style: TextStyle(fontWeight: FontWeight.bold),
// //         ),
// //         backgroundColor: Colors.green.shade600,
// //         actions: [
// //           DropdownButton<String>(
// //             value: selectedLanguage,
// //             icon: const Icon(Icons.language, color: Colors.white),
// //             dropdownColor: Colors.green.shade700,
// //             underline: Container(),
// //             onChanged: (String? newValue) {
// //               setState(() {
// //                 selectedLanguage = newValue!;
// //                 // In a real app, you would call a language change method here
// //               });
// //             },
// //             items:
// //                 languageOptions.map<DropdownMenuItem<String>>((String value) {
// //                   return DropdownMenuItem<String>(
// //                     value: value,
// //                     child: Text(
// //                       value,
// //                       style: const TextStyle(color: Colors.white),
// //                     ),
// //                   );
// //                 }).toList(),
// //           ),
// //           const SizedBox(width: 10),
// //         ],
// //       ),
// //       body: Container(
// //         decoration: BoxDecoration(
// //           image: DecorationImage(
// //             image: AssetImage('assets/farm_background.jpg'),
// //             fit: BoxFit.cover,
// //             colorFilter: ColorFilter.mode(
// //               Colors.white.withOpacity(0.8),
// //               BlendMode.lighten,
// //             ),
// //           ),
// //         ),
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               // Weather Summary Card
// //               Card(
// //                 elevation: 4,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(15),
// //                 ),
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(16.0),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           const Text(
// //                             'Today\'s Weather',
// //                             style: TextStyle(
// //                               fontSize: 18,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                           IconButton(
// //                             icon: const Icon(Icons.refresh),
// //                             onPressed: () {
// //                               // Refresh weather data
// //                             },
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 10),
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                         children: [
// //                           Column(
// //                             children: [
// //                               Icon(
// //                                 Icons.wb_sunny,
// //                                 size: 40,
// //                                 color: Colors.orange,
// //                               ),
// //                               Text('32°C', style: TextStyle(fontSize: 24)),
// //                               Text('Sunny'),
// //                             ],
// //                           ),
// //                           Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text('Humidity: 65%'),
// //                               Text('Wind: 12 km/h'),
// //                               Text('Rain chance: 10%'),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 10),
// //                       CustomButton(
// //                         text: 'Detailed Weather',
// //                         onPressed: () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (context) => WeatherScreen(),
// //                             ),
// //                           );
// //                         },
// //                         color: Colors.blue.shade700,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),

// //               const SizedBox(height: 20),

// //               // Main Features Grid
// //               Expanded(
// //                 child: GridView.count(
// //                   crossAxisCount: 2,
// //                   crossAxisSpacing: 16,
// //                   mainAxisSpacing: 16,
// //                   children: [
// //                     _buildFeatureCard(
// //                       context,
// //                       'AI Assistant',
// //                       Icons.chat,
// //                       Colors.green.shade700,
// //                       () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => ChatbotScreen(),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                     _buildFeatureCard(
// //                       context,
// //                       'Disease Detection',
// //                       Icons.camera_alt,
// //                       Colors.red.shade700,
// //                       () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => const DiseaseScreen(),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                     _buildFeatureCard(
// //                       context,
// //                       'Crop Recommendations',
// //                       Icons.eco,
// //                       Colors.teal.shade700,
// //                       () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder:
// //                                 (context) => CropRecommendationScreen(),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                     _buildFeatureCard(
// //                       context,
// //                       'Market Prices',
// //                       Icons.bar_chart,
// //                       Colors.purple.shade700,
// //                       () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => const MarketScreen(),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                     _buildFeatureCard(
// //                       context,
// //                       'Government Schemes',
// //                       Icons.bar_chart,
// //                       Colors.purple.shade700,
// //                       () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => const FarmerSchemesScreen(),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildFeatureCard(
// //     BuildContext context,
// //     String title,
// //     IconData iconData,
// //     Color color,
// //     VoidCallback onTap,
// //   ) {
// //     return Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //       child: InkWell(
// //         onTap: onTap,
// //         borderRadius: BorderRadius.circular(15),
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Icon(iconData, size: 50, color: color),
// //               const SizedBox(height: 12),
// //               Text(
// //                 title,
// //                 textAlign: TextAlign.center,
// //                 style: const TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';
// // import 'package:kisaansetu/screens/chatbot_screen.dart';
// // import 'package:kisaansetu/screens/disease_screen.dart';
// // import 'package:kisaansetu/screens/government_schemes.dart';
// // import 'package:kisaansetu/screens/weather_screen.dart';
// // import 'package:kisaansetu/screens/market_prices.dart';
// // import 'package:kisaansetu/widgets/custom_button.dart';
// // import 'package:kisaansetu/screens/crop_recommendation.dart';
// // import 'package:kisaansetu/services/api_service.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:permission_handler/permission_handler.dart';

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({Key? key}) : super(key: key);

// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   String selectedLanguage = 'English';
// //   final List<String> languageOptions = [
// //     'English',
// //     'Hindi',
// //     'Punjabi',
// //     'Gujarati',
// //     'Bengali',
// //     'Marathi',
// //   ];

// //   // Weather data variables
// //   bool isLoading = true;
// //   String temperature = '--';
// //   String weatherCondition = '--';
// //   String humidity = '--';
// //   String windSpeed = '--';
// //   String rainChance = '--';
// //   IconData weatherIcon = Icons.cloud;
// //   Color weatherIconColor = Colors.grey;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadWeatherData();
// //   }

// //   // Method to get user's location and fetch weather data
// //   Future<void> _loadWeatherData() async {
// //     setState(() {
// //       isLoading = true;
// //     });

// //     try {
// //       // First check and request location permission
// //       var status = await Permission.location.status;
// //       if (!status.isGranted) {
// //         status = await Permission.location.request();
// //         if (!status.isGranted) {
// //           // Handle permission denied case
// //           setState(() {
// //             isLoading = false;
// //             weatherCondition = 'Location access denied';
// //           });
// //           return;
// //         }
// //       }

// //       // Get current position
// //       Position position = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.low,
// //       );

// //       // Fetch weather data using your existing ApiService
// //       final apiService = ApiService();
// //       final weatherData = await apiService.getCurrentWeather(
// //         latitude: position.latitude,
// //         longitude: position.longitude,
// //       );

// //       // Update UI with weather data
// //       setState(() {
// //         isLoading = false;

// //         // Extract and format temperature
// //         temperature = '${weatherData['main']['temp'].round()}°C';

// //         // Extract weather condition
// //         weatherCondition = weatherData['weather'][0]['main'];

// //         // Extract humidity
// //         humidity = '${weatherData['main']['humidity']}%';

// //         // Extract wind speed and convert from m/s to km/h
// //         final windSpeedMps = weatherData['wind']['speed'];
// //         windSpeed = '${(windSpeedMps * 3.6).round()} km/h';

// //         // Set rain chance - not directly available in current weather API
// //         // Could be extracted from forecast data if needed
// //         rainChance = weatherData['rain'] != null ? 'Likely' : 'Low';

// //         // Set appropriate weather icon based on condition
// //         _setWeatherIcon(weatherData['weather'][0]['id']);
// //       });
// //     } catch (e) {
// //       print('Error loading weather data: $e');
// //       setState(() {
// //         isLoading = false;
// //         weatherCondition = 'Error loading weather';
// //       });
// //     }
// //   }

// //   // Helper method to set the appropriate weather icon
// //   void _setWeatherIcon(int weatherId) {
// //     // Weather condition codes: https://openweathermap.org/weather-conditions
// //     if (weatherId >= 200 && weatherId < 300) {
// //       // Thunderstorm
// //       weatherIcon = Icons.flash_on;
// //       weatherIconColor = Colors.amber;
// //     } else if (weatherId >= 300 && weatherId < 400) {
// //       // Drizzle
// //       weatherIcon = Icons.grain;
// //       weatherIconColor = Colors.blue.shade300;
// //     } else if (weatherId >= 500 && weatherId < 600) {
// //       // Rain
// //       weatherIcon = Icons.beach_access;
// //       weatherIconColor = Colors.blue;
// //     } else if (weatherId >= 600 && weatherId < 700) {
// //       // Snow
// //       weatherIcon = Icons.ac_unit;
// //       weatherIconColor = Colors.blue.shade100;
// //     } else if (weatherId >= 700 && weatherId < 800) {
// //       // Atmosphere (fog, mist, etc.)
// //       weatherIcon = Icons.cloud;
// //       weatherIconColor = Colors.blueGrey;
// //     } else if (weatherId == 800) {
// //       // Clear
// //       weatherIcon = Icons.wb_sunny;
// //       weatherIconColor = Colors.orange;
// //     } else if (weatherId > 800) {
// //       // Clouds
// //       weatherIcon = Icons.cloud;
// //       weatherIconColor = Colors.grey;
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'KisaanSetu',
// //           style: TextStyle(fontWeight: FontWeight.bold),
// //         ),
// //         backgroundColor: Colors.green.shade600,
// //         actions: [
// //           DropdownButton<String>(
// //             value: selectedLanguage,
// //             icon: const Icon(Icons.language, color: Colors.white),
// //             dropdownColor: Colors.green.shade700,
// //             underline: Container(),
// //             onChanged: (String? newValue) {
// //               setState(() {
// //                 selectedLanguage = newValue!;
// //                 // In a real app, you would call a language change method here
// //               });
// //             },
// //             items:
// //                 languageOptions.map<DropdownMenuItem<String>>((String value) {
// //                   return DropdownMenuItem<String>(
// //                     value: value,
// //                     child: Text(
// //                       value,
// //                       style: const TextStyle(color: Colors.white),
// //                     ),
// //                   );
// //                 }).toList(),
// //           ),
// //           const SizedBox(width: 10),
// //         ],
// //       ),
// //       body: Container(
// //         decoration: BoxDecoration(
// //           image: DecorationImage(
// //             image: AssetImage('assets/farm_background.jpg'),
// //             fit: BoxFit.cover,
// //             colorFilter: ColorFilter.mode(
// //               Colors.white.withOpacity(0.8),
// //               BlendMode.lighten,
// //             ),
// //           ),
// //         ),
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               // Weather Summary Card
// //               Card(
// //                 elevation: 4,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(15),
// //                 ),
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(16.0),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           const Text(
// //                             'Today\'s Weather',
// //                             style: TextStyle(
// //                               fontSize: 18,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                           IconButton(
// //                             icon: const Icon(Icons.refresh),
// //                             onPressed: _loadWeatherData,
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 10),
// //                       isLoading
// //                           ? Center(child: CircularProgressIndicator())
// //                           : Row(
// //                               mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                               children: [
// //                                 Column(
// //                                   children: [
// //                                     Icon(
// //                                       weatherIcon,
// //                                       size: 40,
// //                                       color: weatherIconColor,
// //                                     ),
// //                                     Text(temperature, style: TextStyle(fontSize: 24)),
// //                                     Text(weatherCondition),
// //                                   ],
// //                                 ),
// //                                 Column(
// //                                   crossAxisAlignment: CrossAxisAlignment.start,
// //                                   children: [
// //                                     Text('Humidity: $humidity'),
// //                                     Text('Wind: $windSpeed'),
// //                                     Text('Rain chance: $rainChance'),
// //                                   ],
// //                                 ),
// //                               ],
// //                             ),
// //                       const SizedBox(height: 10),
// //                       CustomButton(
// //                         text: 'Detailed Weather',
// //                         onPressed: () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (context) => WeatherScreen(),
// //                             ),
// //                           );
// //                         },
// //                         color: Colors.blue.shade700,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),

// //               const SizedBox(height: 20),

// //               // Main Features Grid
// //               Expanded(
// //                 child: GridView.count(
// //                   crossAxisCount: 2,
// //                   crossAxisSpacing: 16,
// //                   mainAxisSpacing: 16,
// //                   children: [
// //                     _buildFeatureCard(
// //                       context,
// //                       'AI Assistant',
// //                       Icons.chat,
// //                       Colors.green.shade700,
// //                       () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => ChatbotScreen(),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                     _buildFeatureCard(
// //                       context,
// //                       'Disease Detection',
// //                       Icons.camera_alt,
// //                       Colors.red.shade700,
// //                       () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => const DiseaseScreen(),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                     _buildFeatureCard(
// //                       context,
// //                       'Crop Recommendations',
// //                       Icons.eco,
// //                       Colors.teal.shade700,
// //                       () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder:
// //                                 (context) => CropRecommendationScreen(),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                     _buildFeatureCard(
// //                       context,
// //                       'Market Prices',
// //                       Icons.bar_chart,
// //                       Colors.purple.shade700,
// //                       () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => const MarketScreen(),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                     _buildFeatureCard(
// //                       context,
// //                       'Government Schemes',
// //                       Icons.assignment,
// //                       Colors.indigo.shade700,
// //                       () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => const GovernmentSchemesScreen(),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildFeatureCard(
// //     BuildContext context,
// //     String title,
// //     IconData iconData,
// //     Color color,
// //     VoidCallback onTap,
// //   ) {
// //     return Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //       child: InkWell(
// //         onTap: onTap,
// //         borderRadius: BorderRadius.circular(15),
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Icon(iconData, size: 50, color: color),
// //               const SizedBox(height: 12),
// //               Text(
// //                 title,
// //                 textAlign: TextAlign.center,
// //                 style: const TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:kisaansetu/main.dart';
// import 'package:kisaansetu/screens/agristore_screen.dart';
// import 'package:kisaansetu/screens/chatbot_screen.dart';
// import 'package:kisaansetu/screens/disease_screen.dart';
// import 'package:kisaansetu/screens/government_schemes.dart';
// import 'package:kisaansetu/screens/soil_moisture_screen.dart';
// import 'package:kisaansetu/screens/weather_screen.dart';
// import 'package:kisaansetu/screens/market_prices.dart';
// import 'package:kisaansetu/widgets/custom_button.dart';
// import 'package:kisaansetu/screens/crop_recommendation.dart';
// import 'package:kisaansetu/services/api_service.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:kisaansetu/l10n/app_localizations.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   // Language selection variables
//   late String selectedLanguage;
//   final List<String> languageOptions = [
//     'English',
//     'Hindi',
//     'Punjabi',
//     'Gujarati',
//     'Bengali',
//     'Marathi',
//   ];

//   // Language to locale mapping
//   final Map<String, Locale> languageToLocaleMap = {
//     'English': Locale('en'),
//     'Hindi': Locale('hi'),
//     'Punjabi': Locale('pa'),
//     'Gujarati': Locale('gu'),
//     'Bengali': Locale('bn'),
//     'Marathi': Locale('mr'),
//   };

//   // Weather data variables
//   bool isLoading = true;
//   String temperature = '--';
//   String weatherCondition = '--';
//   String humidity = '--';
//   String windSpeed = '--';
//   String rainChance = '--';
//   IconData weatherIcon = Icons.cloud;
//   Color weatherIconColor = Colors.grey;

//   @override
//   void initState() {
//     super.initState();
//     _loadInitialLanguage();
//     _loadWeatherData();
//   }

//   // Load initial language from SharedPreferences
//   Future<void> _loadInitialLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
//     });
//   }

//   // Save selected language to SharedPreferences
//   Future<void> _saveLanguage(String language) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('selectedLanguage', language);
//   }

//   // Method to get user's location and fetch weather data
//   Future<void> _loadWeatherData() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       // First check and request location permission
//       var status = await Permission.location.status;
//       if (!status.isGranted) {
//         status = await Permission.location.request();
//         if (!status.isGranted) {
//           // Handle permission denied case
//           setState(() {
//             isLoading = false;
//             weatherCondition = 'Location access denied';
//           });
//           return;
//         }
//       }

//       // Get current position
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.low,
//       );

//       // Fetch weather data using your existing ApiService
//       final apiService = ApiService();
//       final weatherData = await apiService.getCurrentWeather(
//         latitude: position.latitude,
//         longitude: position.longitude,
//       );

//       // Update UI with weather data
//       setState(() {
//         isLoading = false;

//         // Extract and format temperature
//         temperature = '${weatherData['main']['temp'].round()}°C';

//         // Extract weather condition
//         weatherCondition = weatherData['weather'][0]['main'];

//         // Extract humidity
//         humidity = '${weatherData['main']['humidity']}%';

//         // Extract wind speed and convert from m/s to km/h
//         final windSpeedMps = weatherData['wind']['speed'];
//         windSpeed = '${(windSpeedMps * 3.6).round()} km/h';

//         // Set rain chance - not directly available in current weather API
//         // Could be extracted from forecast data if needed
//         rainChance = weatherData['rain'] != null ? 'Likely' : 'Low';

//         // Set appropriate weather icon based on condition
//         _setWeatherIcon(weatherData['weather'][0]['id']);
//       });
//     } catch (e) {
//       print('Error loading weather data: $e');
//       setState(() {
//         isLoading = false;
//         weatherCondition = 'Error loading weather';
//       });
//     }
//   }

//   // Helper method to set the appropriate weather icon
//   void _setWeatherIcon(int weatherId) {
//     // Weather condition codes: https://openweathermap.org/weather-conditions
//     if (weatherId >= 200 && weatherId < 300) {
//       // Thunderstorm
//       weatherIcon = Icons.flash_on;
//       weatherIconColor = Colors.amber;
//     } else if (weatherId >= 300 && weatherId < 400) {
//       // Drizzle
//       weatherIcon = Icons.grain;
//       weatherIconColor = Colors.blue.shade300;
//     } else if (weatherId >= 500 && weatherId < 600) {
//       // Rain
//       weatherIcon = Icons.beach_access;
//       weatherIconColor = Colors.blue;
//     } else if (weatherId >= 600 && weatherId < 700) {
//       // Snow
//       weatherIcon = Icons.ac_unit;
//       weatherIconColor = Colors.blue.shade100;
//     } else if (weatherId >= 700 && weatherId < 800) {
//       // Atmosphere (fog, mist, etc.)
//       weatherIcon = Icons.cloud;
//       weatherIconColor = Colors.blueGrey;
//     } else if (weatherId == 800) {
//       // Clear
//       weatherIcon = Icons.wb_sunny;
//       weatherIconColor = Colors.orange;
//     } else if (weatherId > 800) {
//       // Clouds
//       weatherIcon = Icons.cloud;
//       weatherIconColor = Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Get localization instance
//     final localizations = AppLocalizations.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'KisaanSetu',
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.green.shade600,
//         actions: [
//           DropdownButton<String>(
//             value: selectedLanguage,
//             icon: const Icon(Icons.language, color: Colors.white),
//             dropdownColor: Colors.green.shade700,
//             underline: Container(),
//             onChanged: (String? newValue) {
//               if (newValue != null) {
//                 setState(() {
//                   selectedLanguage = newValue;
//                 });

//                 // Save selected language
//                 _saveLanguage(newValue);

//                 // Change app locale
//                 final locale = languageToLocaleMap[newValue] ?? Locale('en');
//                 KisaanSetuApp.of(context).setLocale(locale);
//               }
//             },
//             items:
//                 languageOptions.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(
//                       value,
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   );
//                 }).toList(),
//           ),
//           const SizedBox(width: 10),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/farm_background.jpg'),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//               Colors.white.withOpacity(0.8),
//               BlendMode.lighten,
//             ),
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Weather Summary Card
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             localizations
//                                 .todaysWeather, // Replace with localized key when available
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.refresh),
//                             onPressed: _loadWeatherData,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       isLoading
//                           ? const Center(child: CircularProgressIndicator())
//                           : Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Column(
//                                 children: [
//                                   Icon(
//                                     weatherIcon,
//                                     size: 40,
//                                     color: weatherIconColor,
//                                   ),
//                                   Text(
//                                     temperature,
//                                     style: const TextStyle(fontSize: 24),
//                                   ),
//                                   Text(weatherCondition),
//                                 ],
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Humidity: $humidity'),
//                                   Text('Wind: $windSpeed'),
//                                   Text('Rain chance: $rainChance'),
//                                 ],
//                               ),
//                             ],
//                           ),
//                       const SizedBox(height: 10),
//                       CustomButton(
//                         text:
//                             localizations
//                                 .detailedWeather, // Replace with localized key when available
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => WeatherScreen(),
//                             ),
//                           );
//                         },
//                         color: Colors.blue.shade700,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // Main Features Grid
//               Expanded(
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                   children: [
//                     _buildFeatureCard(
//                       context,
//                       localizations.aiAssistant, // Localization placeholder
//                       Icons.chat,
//                       Colors.green.shade700,
//                       () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ChatbotScreen(),
//                           ),
//                         );
//                       },
//                     ),
//                     _buildFeatureCard(
//                       context,
//                       localizations
//                           .diseaseDetection, // Localization placeholder
//                       Icons.camera_alt,
//                       Colors.red.shade700,
//                       () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => DiseaseDetectionScreen(),
//                           ),
//                         );
//                       },
//                     ),
//                     _buildFeatureCard(
//                       context,
//                       localizations
//                           .cropRecommendations, // Localization placeholder
//                       Icons.eco,
//                       Colors.teal.shade700,
//                       () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => CropRecommendationScreen(),
//                           ),
//                         );
//                       },
//                     ),
//                     _buildFeatureCard(
//                       context,
//                       localizations.marketPrices, // Localization placeholder
//                       Icons.bar_chart,
//                       Colors.purple.shade700,
//                       () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const MarketScreen(),
//                           ),
//                         );
//                       },
//                     ),
//                     _buildFeatureCard(
//                       context,
//                       localizations
//                           .governmentSchemes, // Localization placeholder
//                       Icons.assignment,
//                       Colors.indigo.shade700,
//                       () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder:
//                                 (context) => const GovernmentSchemesScreen(),
//                           ),
//                         );
//                       },
//                     ),
//                     _buildFeatureCard(
//                       context,
//                       'AgriStore', // Direct text instead of localized string
//                       Icons.store,
//                       Colors.orange.shade700,
//                       () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const AgriStoreScreen(),
//                           ),
//                         );
//                       },
//                     ),
//                     // _buildFeatureCard(
//                     //   context,
//                     //   'Soil Tracker',
//                     //   Icons
//                     //       .grass, // Best option - directly represents soil/plants
//                     //   Colors.orange.shade700,
//                     //   () {
//                     //     Navigator.push(
//                     //       context,
//                     //       MaterialPageRoute(
//                     //         builder: (context) => const SoilMoistureScreen(),
//                     //       ),
//                     //     );
//                     //   },
//                     // ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFeatureCard(
//     BuildContext context,
//     String title,
//     IconData iconData,
//     Color color,
//     VoidCallback onTap,
//   ) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(15),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(iconData, size: 50, color: color),
//               const SizedBox(height: 12),
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Extension to get current locale easily
// extension LocaleExtension on BuildContext {
//   Locale get locale => Localizations.localeOf(this);
// }

import 'package:flutter/material.dart';
import 'package:kisaansetu/main.dart';
import 'package:kisaansetu/screens/agristore_screen.dart';
import 'package:kisaansetu/screens/chatbot_screen.dart';
import 'package:kisaansetu/screens/dealercontactscreen.dart';
import 'package:kisaansetu/screens/disease_screen.dart';
import 'package:kisaansetu/screens/fertilizer_recommendation.dart';
import 'package:kisaansetu/screens/government_schemes.dart';
import 'package:kisaansetu/screens/nearby_store_screen.dart';
import 'package:kisaansetu/screens/news_screen.dart';
// import 'package:kisaansetu/screens/soil_moisture_screen.dart';
import 'package:kisaansetu/screens/weather_screen.dart';
import 'package:kisaansetu/screens/market_prices.dart';
import 'package:kisaansetu/widgets/custom_button.dart';
import 'package:kisaansetu/screens/crop_recommendation.dart';
import 'package:kisaansetu/services/api_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kisaansetu/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Language selection variables
  late String selectedLanguage;
  final List<String> languageOptions = [
    'English',
    'Hindi',
    'Punjabi',
    'Gujarati',
    'Bengali',
    'Marathi',
  ];

  // Language to locale mapping
  final Map<String, Locale> languageToLocaleMap = {
    'English': Locale('en'),
    'Hindi': Locale('hi'),
    'Punjabi': Locale('pa'),
    'Gujarati': Locale('gu'),
    'Bengali': Locale('bn'),
    'Marathi': Locale('mr'),
  };

  // Weather data variables
  bool isLoading = true;
  String temperature = '--';
  String weatherCondition = '--';
  String humidity = '--';
  String windSpeed = '--';
  String rainChance = '--';
  IconData weatherIcon = Icons.cloud;
  Color weatherIconColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _loadInitialLanguage();
    _loadWeatherData();
  }

  // Load initial language from SharedPreferences
  Future<void> _loadInitialLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  // Save selected language to SharedPreferences
  Future<void> _saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
  }

  // Method to get user's location and fetch weather data
  Future<void> _loadWeatherData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // First check and request location permission
      var status = await Permission.location.status;
      if (!status.isGranted) {
        status = await Permission.location.request();
        if (!status.isGranted) {
          // Handle permission denied case
          setState(() {
            isLoading = false;
            weatherCondition = 'Location access denied';
          });
          return;
        }
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      // Fetch weather data using your existing ApiService
      final apiService = ApiService();
      final weatherData = await apiService.getCurrentWeather(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      // Update UI with weather data
      setState(() {
        isLoading = false;

        // Extract and format temperature
        temperature = '${weatherData['main']['temp'].round()}°C';

        // Extract weather condition
        weatherCondition = weatherData['weather'][0]['main'];

        // Extract humidity
        humidity = '${weatherData['main']['humidity']}%';

        // Extract wind speed and convert from m/s to km/h
        final windSpeedMps = weatherData['wind']['speed'];
        windSpeed = '${(windSpeedMps * 3.6).round()} km/h';

        // Set rain chance - not directly available in current weather API
        // Could be extracted from forecast data if needed
        rainChance = weatherData['rain'] != null ? 'Likely' : 'Low';

        // Set appropriate weather icon based on condition
        _setWeatherIcon(weatherData['weather'][0]['id']);
      });
    } catch (e) {
      print('Error loading weather data: $e');
      setState(() {
        isLoading = false;
        weatherCondition = 'Error loading weather';
      });
    }
  }

  // Helper method to set the appropriate weather icon
  void _setWeatherIcon(int weatherId) {
    // Weather condition codes: https://openweathermap.org/weather-conditions
    if (weatherId >= 200 && weatherId < 300) {
      // Thunderstorm
      weatherIcon = Icons.flash_on;
      weatherIconColor = Colors.amber;
    } else if (weatherId >= 300 && weatherId < 400) {
      // Drizzle
      weatherIcon = Icons.grain;
      weatherIconColor = Colors.blue.shade300;
    } else if (weatherId >= 500 && weatherId < 600) {
      // Rain
      weatherIcon = Icons.beach_access;
      weatherIconColor = Colors.blue;
    } else if (weatherId >= 600 && weatherId < 700) {
      // Snow
      weatherIcon = Icons.ac_unit;
      weatherIconColor = Colors.blue.shade100;
    } else if (weatherId >= 700 && weatherId < 800) {
      // Atmosphere (fog, mist, etc.)
      weatherIcon = Icons.cloud;
      weatherIconColor = Colors.blueGrey;
    } else if (weatherId == 800) {
      // Clear
      weatherIcon = Icons.wb_sunny;
      weatherIconColor = Colors.orange;
    } else if (weatherId > 800) {
      // Clouds
      weatherIcon = Icons.cloud;
      weatherIconColor = Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get localization instance
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'KisaanSetu',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade600,
        actions: [
          DropdownButton<String>(
            value: selectedLanguage,
            icon: const Icon(Icons.language, color: Colors.white),
            dropdownColor: Colors.green.shade700,
            underline: Container(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedLanguage = newValue;
                });

                // Save selected language
                _saveLanguage(newValue);

                // Change app locale
                final locale = languageToLocaleMap[newValue] ?? Locale('en');
                KisaanSetuApp.of(context).setLocale(locale);
              }
            },
            items:
                languageOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/farm_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8),
              BlendMode.lighten,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Weather Summary Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            localizations
                                .todaysWeather, // Replace with localized key when available
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: _loadWeatherData,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    weatherIcon,
                                    size: 40,
                                    color: weatherIconColor,
                                  ),
                                  Text(
                                    temperature,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  Text(weatherCondition),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Humidity: $humidity'),
                                  Text('Wind: $windSpeed'),
                                  Text('Rain chance: $rainChance'),
                                ],
                              ),
                            ],
                          ),
                      const SizedBox(height: 10),
                      CustomButton(
                        text:
                            localizations
                                .detailedWeather, // Replace with localized key when available
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeatherScreen(),
                            ),
                          );
                        },
                        color: Colors.blue.shade700,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Main Features Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildFeatureCard(
                      context,
                      localizations.aiAssistant,
                      Icons.smart_toy, // Better icon for AI assistant
                      Colors.green.shade700,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatbotScreen(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      localizations.diseaseDetection,
                      Icons.health_and_safety, // Better for disease detection
                      Colors.red.shade700,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiseaseDetectionScreen(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      localizations.cropRecommendations,
                      Icons.spa, // Better for crops
                      Colors.teal.shade700,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CropRecommendationScreen(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      localizations.marketPrices,
                      Icons.attach_money, // Better for market prices
                      Colors.purple.shade700,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MarketScreen(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      localizations.governmentSchemes,
                      Icons.account_balance, // Better for government schemes
                      Colors.indigo.shade700,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const GovernmentSchemesScreen(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      'AgriStore',
                      Icons.shopping_cart, // Better for store
                      Colors.orange.shade700,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AgriStoreScreen(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      'Nearby Store',
                      Icons.store_mall_directory, // Better for physical stores
                      Colors.blue.shade700,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NearbyStorageScreen(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      'Nearby Traders',
                      Icons.people_alt, // Better for traders
                      Colors.brown.shade700,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NearbyTradersScreen(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      'Fertilizer Recommendation',
                      Icons.eco, // Better for fertilizer
                      Colors.lightGreen.shade700,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    const FertilizerRecommendationScreen(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      localizations.newsScreen,
                      Icons.newspaper, // Better for news
                      Colors.blueGrey.shade700,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewsScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData iconData,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, size: 50, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension to get current locale easily
extension LocaleExtension on BuildContext {
  Locale get locale => Localizations.localeOf(this);
}
