// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:url_launcher/url_launcher.dart';

// class NearbyTradersScreen extends StatefulWidget {
//   @override
//   _NearbyTradersScreenState createState() => _NearbyTradersScreenState();
// }

// class _NearbyTradersScreenState extends State<NearbyTradersScreen> {
//   bool _isLoading = false;
//   String _statusMessage = 'Find nearby crop traders!';
//   double _searchRadius = 10.0; // Increased default radius for traders
//   String _selectedTraderType = 'Commission Agent'; // Default selection
//   final List<String> _traderTypes = [
//     'Commission Agent',
//     'Mandi Trader',
//     'Bulk Buyer',
//     'Export Trader',
//     'Processing Unit',
//     'Cooperative Society'
//   ];

//   Future<void> _findTraders() async {
//     setState(() {
//       _isLoading = true;
//       _statusMessage = 'Locating your position...';
//     });

//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         bool enabled = await Geolocator.openLocationSettings();
//         if (!enabled) throw 'Please enable location services';
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.deniedForever) {
//         throw 'Location permissions permanently denied. Please enable in app settings.';
//       }

//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission != LocationPermission.whileInUse &&
//             permission != LocationPermission.always) {
//           throw 'Location permissions required';
//         }
//       }

//       setState(() => _statusMessage = 'Finding nearby traders...');
//       Position position = await Geolocator.getCurrentPosition();

//       // Map trader types to search terms
//       final searchTermMap = {
//         'Commission Agent': 'commission agent agriculture',
//         'Mandi Trader': 'APMC mandi trader',
//         'Bulk Buyer': 'agricultural produce buyer',
//         'Export Trader': 'agricultural export trader',
//         'Processing Unit': 'crop processing unit',
//         'Cooperative Society': 'farmer cooperative society'
//       };

//       final searchTerm = searchTermMap[_selectedTraderType] ?? 'crop buyer';

//       // Create both maps URL and fallback URL
//       final mapsUrl =
//           'geo:${position.latitude},${position.longitude}?q=$searchTerm';
//       final webUrl =
//           'https://www.google.com/maps/search/$searchTerm/@${position.latitude},${position.longitude},${_searchRadius}km';

//       // Try launching native maps app first
//       if (await canLaunchUrl(Uri.parse(mapsUrl))) {
//         await launchUrl(
//           Uri.parse(mapsUrl),
//           mode: LaunchMode.externalApplication,
//         );
//         _statusMessage = 'Showing $_selectedTraderType within ${_searchRadius.round()} km';
//       }
//       // Fallback to web URL
//       else if (await canLaunchUrl(Uri.parse(webUrl))) {
//         await launchUrl(
//           Uri.parse(webUrl),
//           mode: LaunchMode.externalApplication,
//         );
//       }
//       // Final fallback to generic Google Maps
//       else if (await canLaunchUrl(Uri.parse('https://maps.google.com'))) {
//         await launchUrl(
//           Uri.parse('https://maps.google.com'),
//           mode: LaunchMode.externalApplication,
//         );
//       } else {
//         throw 'Could not launch maps application';
//       }
//     } catch (e) {
//       setState(
//         () =>
//             _statusMessage =
//                 'Error: ${e.toString().replaceAll('Exception:', '')}',
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(_statusMessage),
//           backgroundColor: Colors.red[800],
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: const Text(
//           'Crop Trader Finder',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(
//               'assets/farm_background.jpg',
//             ),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: BackdropFilter(
//           filter: ColorFilter.mode(
//             Colors.black.withOpacity(0.2),
//             BlendMode.darken,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
//             child: Column(
//               children: [
//                 // Main Card
//                 Card(
//                   elevation: 10,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Column(
//                       children: [
//                         const Icon(
//                           Icons.people_alt,
//                           size: 50,
//                           color: Colors.white,
//                         ),
//                         const SizedBox(height: 15),
//                         Text(
//                           _statusMessage,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         // Trader Type Dropdown
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: DropdownButton<String>(
//                             value: _selectedTraderType,
//                             icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
//                             iconSize: 24,
//                             elevation: 16,
//                             style: const TextStyle(color: Colors.white, fontSize: 16),
//                             underline: Container(),
//                             isExpanded: true,
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 _selectedTraderType = newValue!;
//                               });
//                             },
//                             items: _traderTypes.map<DropdownMenuItem<String>>((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                             dropdownColor: const Color(0xFF2E7D32),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         SliderTheme(
//                           data: SliderTheme.of(context).copyWith(
//                             activeTrackColor: Colors.amber[700],
//                             inactiveTrackColor: Colors.grey[300],
//                             thumbColor: Colors.amber,
//                             valueIndicatorColor: Colors.amber,
//                             overlayColor: Colors.amber.withAlpha(32),
//                           ),
//                           child: Slider(
//                             value: _searchRadius,
//                             min: 5,
//                             max: 100,
//                             divisions: 19,
//                             label: '${_searchRadius.round()} km',
//                             onChanged: (value) => setState(() => _searchRadius = value),
//                           ),
//                         ),
//                         const Text(
//                           'Search Radius',
//                           style: TextStyle(color: Colors.white70),
//                         ),
//                         const SizedBox(height: 15),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton.icon(
//                             icon: const Icon(Icons.search),
//                             label: const Text(
//                               'FIND TRADERS',
//                               style: TextStyle(fontSize: 18),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.amber[700],
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 15),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             onPressed: _isLoading ? null : _findTraders,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 // Trader Types Grid
//                 Expanded(
//                   child: GridView.count(
//                     crossAxisCount: 2,
//                     childAspectRatio: 1.3,
//                     crossAxisSpacing: 15,
//                     mainAxisSpacing: 15,
//                     children: _traderTypes.map((type) {
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _selectedTraderType = type;
//                           });
//                         },
//                         child: Card(
//                           elevation: 8,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               gradient: LinearGradient(
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                                 colors: [
//                                   _selectedTraderType == type 
//                                     ? Colors.green[700]!.withOpacity(0.9)
//                                     : Colors.green[700]!.withOpacity(0.7),
//                                   _selectedTraderType == type
//                                     ? Colors.lightGreen[500]!.withOpacity(0.9)
//                                     : Colors.lightGreen[500]!.withOpacity(0.7),
//                                 ],
//                               ),
//                             ),
//                             child: Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(10),
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(
//                                       _getIconForTraderType(type),
//                                       size: 30,
//                                       color: Colors.white,
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       type,
//                                       textAlign: TextAlign.center,
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.amber[700],
//         onPressed: _findTraders,
//         child: const Icon(Icons.search, color: Colors.white),
//       ),
//     );
//   }

//   IconData _getIconForTraderType(String type) {
//     switch (type) {
//       case 'Commission Agent':
//         return Icons.account_balance;
//       case 'Mandi Trader':
//         return Icons.store;
//       case 'Bulk Buyer':
//         return Icons.shopping_cart;
//       case 'Export Trader':
//         return Icons.airport_shuttle;
//       case 'Processing Unit':
//         return Icons.factory;
//       case 'Cooperative Society':
//         return Icons.people;
//       default:
//         return Icons.business;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyTradersScreen extends StatefulWidget {
  @override
  _NearbyTradersScreenState createState() => _NearbyTradersScreenState();
}

class _NearbyTradersScreenState extends State<NearbyTradersScreen> {
  bool _isLoading = false;
  String _statusMessage = 'Find nearby crop traders!';
  double _searchRadius = 10.0;
  String _selectedTraderType = 'Commission Agent';
  final List<String> _traderTypes = [
    'Commission Agent',
    'Mandi Trader',
    'Bulk Buyer',
    'Export Trader',
    'Processing Unit',
    'Cooperative Society'
  ];

  Future<void> _findTraders() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Locating your position...';
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        bool enabled = await Geolocator.openLocationSettings();
        if (!enabled) throw 'Please enable location services';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions permanently denied. Please enable in app settings.';
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          throw 'Location permissions required';
        }
      }

      setState(() => _statusMessage = 'Finding nearby traders...');
      Position position = await Geolocator.getCurrentPosition();

      final searchTermMap = {
        'Commission Agent': 'commission agent agriculture',
        'Mandi Trader': 'APMC mandi trader',
        'Bulk Buyer': 'agricultural produce buyer',
        'Export Trader': 'agricultural export trader',
        'Processing Unit': 'crop processing unit',
        'Cooperative Society': 'farmer cooperative society'
      };

      final searchTerm = searchTermMap[_selectedTraderType] ?? 'crop buyer';

      final mapsUrl =
          'geo:${position.latitude},${position.longitude}?q=$searchTerm';
      final webUrl =
          'https://www.google.com/maps/search/$searchTerm/@${position.latitude},${position.longitude},${_searchRadius}km';

      if (await canLaunchUrl(Uri.parse(mapsUrl))) {
        await launchUrl(
          Uri.parse(mapsUrl),
          mode: LaunchMode.externalApplication,
        );
        _statusMessage = 'Showing $_selectedTraderType within ${_searchRadius.round()} km';
      }
      else if (await canLaunchUrl(Uri.parse(webUrl))) {
        await launchUrl(
          Uri.parse(webUrl),
          mode: LaunchMode.externalApplication,
        );
      }
      else if (await canLaunchUrl(Uri.parse('https://maps.google.com'))) {
        await launchUrl(
          Uri.parse('https://maps.google.com'),
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch maps application';
      }
    } catch (e) {
      setState(
        () =>
            _statusMessage =
                'Error: ${e.toString().replaceAll('Exception:', '')}',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_statusMessage),
          backgroundColor: Colors.red[800],
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Crop Trader Finder',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
          child: Column(
            children: [
              // Main Card
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.people_alt,
                        size: 50,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        _statusMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Trader Type Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedTraderType,
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          underline: Container(),
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedTraderType = newValue!;
                            });
                          },
                          items: _traderTypes.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          dropdownColor: const Color(0xFF1976D2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.amber[700],
                          inactiveTrackColor: Colors.grey[300],
                          thumbColor: Colors.amber,
                          valueIndicatorColor: Colors.amber,
                          overlayColor: Colors.amber.withAlpha(32),
                        ),
                        child: Slider(
                          value: _searchRadius,
                          min: 5,
                          max: 100,
                          divisions: 19,
                          label: '${_searchRadius.round()} km',
                          onChanged: (value) => setState(() => _searchRadius = value),
                        ),
                      ),
                      const Text(
                        'Search Radius',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.search),
                          label: const Text(
                            'FIND TRADERS',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading ? null : _findTraders,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Trader Types Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: _traderTypes.map((type) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTraderType = type;
                        });
                      },
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                _selectedTraderType == type 
                                  ? Colors.blue[700]!.withOpacity(0.9)
                                  : Colors.blue[700]!.withOpacity(0.7),
                                _selectedTraderType == type
                                  ? Colors.lightBlue[500]!.withOpacity(0.9)
                                  : Colors.lightBlue[500]!.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getIconForTraderType(type),
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    type,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[700],
        onPressed: _findTraders,
        child: const Icon(Icons.search, color: Colors.white),
      ),
    );
  }

  IconData _getIconForTraderType(String type) {
    switch (type) {
      case 'Commission Agent':
        return Icons.account_balance;
      case 'Mandi Trader':
        return Icons.store;
      case 'Bulk Buyer':
        return Icons.shopping_cart;
      case 'Export Trader':
        return Icons.airport_shuttle;
      case 'Processing Unit':
        return Icons.factory;
      case 'Cooperative Society':
        return Icons.people;
      default:
        return Icons.business;
    }
  }
}