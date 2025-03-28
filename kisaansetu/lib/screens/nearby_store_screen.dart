// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:url_launcher/url_launcher.dart';

// class NearbyStoresScreen extends StatefulWidget {
//   @override
//   _NearbyStoresScreenState createState() => _NearbyStoresScreenState();
// }

// class _NearbyStoresScreenState extends State<NearbyStoresScreen> {
//   bool _isLoading = false;
//   String _statusMessage = 'Ready to find nearby agro stores!';
//   double _searchRadius = 5.0;
//   final List<String> _featureCards = [
//     '🌱 Nearest Fertilizer Shops',
//     '🚜 Farm Equipment Dealers',
//     '💧 Irrigation Suppliers',
//     '🌾 Seed & Crop Protection',
//   ];

//   Future<void> _findStores() async {
//     setState(() {
//       _isLoading = true;
//       _statusMessage = 'Locating your farm...';
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

//       setState(() => _statusMessage = 'Pinpointing your fields...');
//       Position position = await Geolocator.getCurrentPosition();

//       final searchTerms = ['fertilizer', 'agro', 'krishi', 'kisan', 'farm'];
//       final randomTerm =
//           searchTerms[DateTime.now().millisecond % searchTerms.length];

//       // Create both maps URL and fallback URL
//       final mapsUrl =
//           'geo:${position.latitude},${position.longitude}?q=$randomTerm+stores';
//       final webUrl =
//           'https://www.google.com/maps/search/$randomTerm+stores/@${position.latitude},${position.longitude},${_searchRadius}km';

//       // Try launching native maps app first
//       if (await canLaunchUrl(Uri.parse(mapsUrl))) {
//         await launchUrl(
//           Uri.parse(mapsUrl),
//           mode: LaunchMode.externalApplication,
//         );
//         _statusMessage = 'Showing stores within ${_searchRadius.round()} km';
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
//           'Kisan Mitra',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
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
//             ), // Add farm background
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
//                 // Farmer Card
//                 Card(
//                   elevation: 10,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Column(
//                       children: [
//                         const Icon(
//                           Icons.agriculture,
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
//                             min: 1,
//                             max: 50,
//                             divisions: 49,
//                             label: '${_searchRadius.round()} km',
//                             onChanged:
//                                 (value) =>
//                                     setState(() => _searchRadius = value),
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
//                             icon: const Icon(Icons.map),
//                             label: const Text(
//                               'FIND STORES',
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
//                             onPressed: _isLoading ? null : _findStores,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 // Features Grid
//                 Expanded(
//                   child: GridView.count(
//                     crossAxisCount: 2,
//                     childAspectRatio: 1.3,
//                     crossAxisSpacing: 15,
//                     mainAxisSpacing: 15,
//                     children:
//                         _featureCards
//                             .map(
//                               (feature) => Card(
//                                 elevation: 8,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(15),
//                                     gradient: LinearGradient(
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomRight,
//                                       colors: [
//                                         Colors.green[700]!.withOpacity(0.8),
//                                         Colors.green[500]!.withOpacity(0.9),
//                                       ],
//                                     ),
//                                   ),
//                                   child: Center(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(10),
//                                       child: Text(
//                                         feature,
//                                         textAlign: TextAlign.center,
//                                         style: const TextStyle(
//                                           fontSize: 16,
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             )
//                             .toList(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.amber[700],
//         onPressed: _findStores,
//         child: const Icon(Icons.search, color: Colors.white),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyStorageScreen extends StatefulWidget {
  @override
  _NearbyStorageScreenState createState() => _NearbyStorageScreenState();
}

class _NearbyStorageScreenState extends State<NearbyStorageScreen> {
  bool _isLoading = false;
  String _statusMessage = 'Find nearby storage facilities!';
  double _searchRadius = 5.0;
  String _selectedStorageType = 'Cold Storage'; // Default selection
  final List<String> _storageTypes = [
    'Cold Storage',
    'Warehouse',
    'Refrigerated Storage',
    'Agricultural Storage'
  ];

  Future<void> _findStorageFacilities() async {
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

      setState(() => _statusMessage = 'Getting your location...');
      Position position = await Geolocator.getCurrentPosition();

      // Map storage types to search terms
      final searchTermMap = {
        'Cold Storage': 'cold storage',
        'Warehouse': 'agricultural warehouse',
        'Refrigerated Storage': 'refrigerated storage',
        'Agricultural Storage': 'agricultural storage facility',
      };

      final searchTerm = searchTermMap[_selectedStorageType] ?? 'cold storage';

      // Create both maps URL and fallback URL
      final mapsUrl =
          'geo:${position.latitude},${position.longitude}?q=$searchTerm';
      final webUrl =
          'https://www.google.com/maps/search/$searchTerm/@${position.latitude},${position.longitude},${_searchRadius}km';

      // Try launching native maps app first
      if (await canLaunchUrl(Uri.parse(mapsUrl))) {
        await launchUrl(
          Uri.parse(mapsUrl),
          mode: LaunchMode.externalApplication,
        );
        _statusMessage = 'Showing $_selectedStorageType within ${_searchRadius.round()} km';
      }
      // Fallback to web URL
      else if (await canLaunchUrl(Uri.parse(webUrl))) {
        await launchUrl(
          Uri.parse(webUrl),
          mode: LaunchMode.externalApplication,
        );
      }
      // Final fallback to generic Google Maps
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
          'Storage Locator',
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
          image: DecorationImage(
            image: AssetImage(
              'assets/storage_background.jpg',
            ), // Change to a relevant background
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ColorFilter.mode(
            Colors.black.withOpacity(0.2),
            BlendMode.darken,
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
                          Icons.warehouse,
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
                        // Storage Type Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedStorageType,
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                            underline: Container(),
                            isExpanded: true,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedStorageType = newValue!;
                              });
                            },
                            items: _storageTypes.map<DropdownMenuItem<String>>((String value) {
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
                            min: 1,
                            max: 50,
                            divisions: 49,
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
                            icon: const Icon(Icons.map),
                            label: const Text(
                              'FIND STORAGE',
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
                            onPressed: _isLoading ? null : _findStorageFacilities,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Features Grid
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: _storageTypes.map((type) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedStorageType = type;
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
                                  _selectedStorageType == type 
                                    ? Colors.blue[700]!.withOpacity(0.9)
                                    : Colors.blue[700]!.withOpacity(0.7),
                                  _selectedStorageType == type
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
                                      _getIconForStorageType(type),
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[700],
        onPressed: _findStorageFacilities,
        child: const Icon(Icons.search, color: Colors.white),
      ),
    );
  }

  IconData _getIconForStorageType(String type) {
    switch (type) {
      case 'Cold Storage':
        return Icons.ac_unit;
      case 'Warehouse':
        return Icons.warehouse;
      case 'Refrigerated Storage':
        return Icons.kitchen;
      case 'Agricultural Storage':
        return Icons.grass;
      default:
        return Icons.storage;
    }
  }
}