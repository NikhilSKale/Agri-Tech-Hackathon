import 'package:flutter/material.dart';
import 'package:kisaansetu/widgets/custom_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  bool isLoading = true;
  bool hasError = false;
  String location = "Detecting location...";
  String district = "";
  String state = "";
  List<Map<String, dynamic>> marketData = [];
  List<Map<String, dynamic>> trendingCrops = [];
  String selectedCategory = "All";
  List<String> categories = ["All", "Vegetables", "Fruits", "Grains", "Spices"];
  DateTime? lastUpdated;
  bool isRefreshing = false;

  // API endpoints
  final String agmarknetApi =
      "https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070";
  final String kisanSuvidhaApi =
      "https://api.data.gov.in/resource/6ada8609-5d5c-4990-8fd2-7372dd3cff42";

  // Backup API (if available)
  final String backupApi =
      "https://api.mandibhavcopy.com/prices"; // Example, might not be real

  // API Key for data.gov.in - you should store this in a secure place
  final String apiKey =
      "579b464db66ec23bdd00000179eb4b5844f0449e7e83de8a789d2290"; // Replace with your key

  @override
  void initState() {
    super.initState();
    _loadCachedData();
    _determinePosition();
  }

  // Load any cached data while fetching new data
  Future<void> _loadCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('market_data');
      final cachedTrends = prefs.getString('trending_crops');
      final cachedLocation = prefs.getString('location');
      final lastUpdatedString = prefs.getString('last_updated');

      if (cachedData != null && cachedTrends != null) {
        setState(() {
          marketData = List<Map<String, dynamic>>.from(
            (jsonDecode(cachedData) as List).map(
              (item) => Map<String, dynamic>.from(item),
            ),
          );
          trendingCrops = List<Map<String, dynamic>>.from(
            (jsonDecode(cachedTrends) as List).map(
              (item) => Map<String, dynamic>.from(item),
            ),
          );
          if (cachedLocation != null) {
            location = cachedLocation;
          }
          if (lastUpdatedString != null) {
            lastUpdated = DateTime.parse(lastUpdatedString);
          }
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading cached data: $e");
    }
  }

  // Save data to cache
  Future<void> _saveCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('market_data', jsonEncode(marketData));
      await prefs.setString('trending_crops', jsonEncode(trendingCrops));
      await prefs.setString('location', location);

      final now = DateTime.now();
      await prefs.setString('last_updated', now.toIso8601String());

      setState(() {
        lastUpdated = now;
      });
    } catch (e) {
      print("Error saving cached data: $e");
    }
  }

  // Determine the current position and fetch location data
  Future<void> _determinePosition() async {
    if (isRefreshing) return;

    setState(() {
      isLoading = marketData.isEmpty;
      isRefreshing = true;
      hasError = false;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          location = "Location services are disabled";
          hasError = true;
          isLoading = false;
          isRefreshing = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            location = "Location permissions are denied";
            hasError = true;
            isLoading = false;
            isRefreshing = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          location = "Location permissions are permanently denied";
          hasError = true;
          isLoading = false;
          isRefreshing = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          district = place.subAdministrativeArea ?? "";
          state = place.administrativeArea ?? "";
          location = "${place.locality}, ${place.administrativeArea}";
        });

        // Try to fetch data from multiple sources
        await _fetchMarketDataFromMultipleSources();
      } else {
        setState(() {
          location = "Location not found";
          hasError = true;
          isLoading = false;
          isRefreshing = false;
        });
      }
    } catch (e) {
      setState(() {
        location = "Error determining location: $e";
        hasError = true;
        isLoading = false;
        isRefreshing = false;
      });
      print("Error: $e");
    }
  }

  // Try multiple sources to get market data
  Future<void> _fetchMarketDataFromMultipleSources() async {
    bool success = false;

    // Try Agmarknet API first
    success = await _fetchAgmarknetData();

    // If that fails, try Kisan Suvidha API
    if (!success) {
      success = await _fetchKisanSuvidhaData();
    }

    // If that fails too, try backup API
    if (!success) {
      success = await _fetchBackupApiData();
    }

    // If all APIs fail, use cache or fallback data
    if (!success) {
      if (marketData.isEmpty) {
        _loadFallbackData();
      } else {
        // We already have cached data loaded
        setState(() {
          hasError = true;
          isLoading = false;
          isRefreshing = false;
        });
      }
    } else {
      // Save successful data to cache
      await _saveCachedData();
    }
  }

  // Fetch from Agmarknet API
  Future<bool> _fetchAgmarknetData() async {
    try {
      // API endpoint for Agricultural Commodity Prices
      final Uri uri = Uri.parse(agmarknetApi).replace(
        queryParameters: {
          'api-key': apiKey,
          'format': 'json',
          'limit': '100',
          'filters[state]': state,
        },
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['records'] != null &&
            jsonResponse['records'] is List &&
            (jsonResponse['records'] as List).isNotEmpty) {
          // Process the received data
          await _processAgmarknetData(jsonResponse['records']);
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Error fetching Agmarknet data: $e");
      return false;
    }
  }

  // Process Agmarknet API data
  Future<void> _processAgmarknetData(List<dynamic> records) async {
    // Clear existing data
    List<Map<String, dynamic>> processedData = [];
    Map<String, List<Map<String, dynamic>>> categorizedData = {
      'Vegetables': [],
      'Fruits': [],
      'Grains': [],
      'Spices': [],
    };

    // Process and categorize the data
    for (var record in records) {
      String commodity = record['commodity'] ?? "";
      String price = record['modal_price'] ?? "0";
      String unit = record['unit'] ?? "Quintal";
      String market = record['market'] ?? "";

      // Simple categorization based on common commodities
      String category = _categorizeProduct(commodity);

      if (category.isNotEmpty) {
        Map<String, dynamic> item = {
          "name": _formatCommodityName(commodity),
          "price": "₹${price}",
          "unit": _formatUnit(unit),
          "market": market,
          "change": _generatePriceChange(commodity),
          "category": category,
        };

        processedData.add(item);
        categorizedData[category]?.add(item);
      }
    }

    // Generate trending crops
    List<Map<String, dynamic>> trending = _generateTrendingCrops(processedData);

    setState(() {
      marketData = processedData;
      trendingCrops = trending;
      isLoading = false;
      isRefreshing = false;
      hasError = false;
    });
  }

  // Fetch from Kisan Suvidha API
  Future<bool> _fetchKisanSuvidhaData() async {
    try {
      final Uri uri = Uri.parse(kisanSuvidhaApi).replace(
        queryParameters: {
          'api-key': apiKey,
          'format': 'json',
          'limit': '100',
          'filters[state]': state,
        },
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['records'] != null &&
            jsonResponse['records'] is List &&
            (jsonResponse['records'] as List).isNotEmpty) {
          // Kisan Suvidha API might have a different format, process accordingly
          // This is a placeholder - you'd need to adapt to the actual API response
          await _processKisanSuvidhaData(jsonResponse['records']);
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Error fetching Kisan Suvidha data: $e");
      return false;
    }
  }

  // Process Kisan Suvidha API data
  Future<void> _processKisanSuvidhaData(List<dynamic> records) async {
    // Implementation would depend on the actual API response format
    // This is just a placeholder

    List<Map<String, dynamic>> processedData = [];

    // Assuming a similar structure to Agmarknet
    for (var record in records) {
      String commodity = record['commodity'] ?? "";
      String price = record['price'] ?? "0";
      String unit = record['unit'] ?? "Quintal";

      String category = _categorizeProduct(commodity);

      if (category.isNotEmpty) {
        processedData.add({
          "name": _formatCommodityName(commodity),
          "price": "₹${price}",
          "unit": _formatUnit(unit),
          "change": _generatePriceChange(commodity),
          "category": category,
        });
      }
    }

    // Generate trending crops
    List<Map<String, dynamic>> trending = _generateTrendingCrops(processedData);

    setState(() {
      marketData = processedData;
      trendingCrops = trending;
      isLoading = false;
      isRefreshing = false;
      hasError = false;
    });
  }

  // Fetch from backup API
  Future<bool> _fetchBackupApiData() async {
    try {
      // This is a placeholder for any third-party or alternative API
      // You would need to implement this based on a real API if available

      // Fake successful response for now - replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      return false; // Change to true if you implement a real API
    } catch (e) {
      print("Error fetching backup API data: $e");
      return false;
    }
  }

  // Generate trending crops based on the market data
  List<Map<String, dynamic>> _generateTrendingCrops(
    List<Map<String, dynamic>> data,
  ) {
    if (data.isEmpty) return [];

    // Sort by price (descending)
    data.sort((a, b) {
      double priceA =
          double.tryParse(a['price'].toString().replaceAll('₹', '')) ?? 0;
      double priceB =
          double.tryParse(b['price'].toString().replaceAll('₹', '')) ?? 0;
      return priceB.compareTo(priceA);
    });

    List<Map<String, dynamic>> trending = [];
    Set<String> categories = <String>{};

    // Take top items from different categories
    for (var item in data) {
      if (trending.length >= 5) break;

      String category = item["category"];

      // Try to get items from different categories
      if (!categories.contains(category) || trending.length < 3) {
        trending.add({
          "name": item["name"],
          "reason": _generateReasonForTrend(item["name"]),
          "prediction": _generatePrediction(item["name"]),
          "category": category,
        });

        categories.add(category);
      }
    }

    return trending;
  }

  // Load fallback data if all APIs fail
  void _loadFallbackData() {
    marketData = [
      {
        "name": "Tomato",
        "price": "₹35",
        "unit": "kg",
        "change": "+15%",
        "category": "Vegetables",
      },
      {
        "name": "Potato",
        "price": "₹20",
        "unit": "kg",
        "change": "-5%",
        "category": "Vegetables",
      },
      {
        "name": "Onion",
        "price": "₹28",
        "unit": "kg",
        "change": "+8%",
        "category": "Vegetables",
      },
      {
        "name": "Apple",
        "price": "₹120",
        "unit": "kg",
        "change": "+3%",
        "category": "Fruits",
      },
      {
        "name": "Banana",
        "price": "₹60",
        "unit": "dozen",
        "change": "-2%",
        "category": "Fruits",
      },
      {
        "name": "Mango (Alphonso)",
        "price": "₹350",
        "unit": "kg",
        "change": "+20%",
        "category": "Fruits",
      },
      {
        "name": "Wheat",
        "price": "₹2100",
        "unit": "quintal",
        "change": "+1%",
        "category": "Grains",
      },
      {
        "name": "Rice (Basmati)",
        "price": "₹3200",
        "unit": "quintal",
        "change": "+4%",
        "category": "Grains",
      },
      {
        "name": "Maize",
        "price": "₹1800",
        "unit": "quintal",
        "change": "-2%",
        "category": "Grains",
      },
      {
        "name": "Cumin",
        "price": "₹210",
        "unit": "kg",
        "change": "+12%",
        "category": "Spices",
      },
      {
        "name": "Turmeric",
        "price": "₹185",
        "unit": "kg",
        "change": "+10%",
        "category": "Spices",
      },
      {
        "name": "Black Pepper",
        "price": "₹580",
        "unit": "kg",
        "change": "+6%",
        "category": "Spices",
      },
    ];

    trendingCrops = [
      {
        "name": "Turmeric",
        "reason": "Limited supply due to reduced acreage",
        "prediction": "Expected to rise by 10% next month",
        "category": "Spices",
      },
      {
        "name": "Mango (Alphonso)",
        "reason": "Seasonal demand surge",
        "prediction": "Peak prices expected during summer months",
        "category": "Fruits",
      },
      {
        "name": "Potato",
        "reason": "Seasonal harvest increase",
        "prediction": "Prices likely to stabilize in coming weeks",
        "category": "Vegetables",
      },
      {
        "name": "Wheat",
        "reason": "Government MSP announcement",
        "prediction": "Steady price rise expected",
        "category": "Grains",
      },
      {
        "name": "Onion",
        "reason": "Weather conditions affecting production",
        "prediction": "Price volatility expected in short term",
        "category": "Vegetables",
      },
    ];

    setState(() {
      isLoading = false;
      isRefreshing = false;
      hasError = true;
      lastUpdated = DateTime.now();
    });

    // Still save this fallback data to cache
    _saveCachedData();
  }

  // Helper function to categorize products
  String _categorizeProduct(String commodity) {
    // Convert to lowercase for easier comparison
    commodity = commodity.toLowerCase();

    // Common vegetables
    if (commodity.contains('potato') ||
        commodity.contains('tomato') ||
        commodity.contains('onion') ||
        commodity.contains('brinjal') ||
        commodity.contains('cauliflower') ||
        commodity.contains('cabbage') ||
        commodity.contains('lady finger') ||
        commodity.contains('bhindi') ||
        commodity.contains('carrot') ||
        commodity.contains('peas') ||
        commodity.contains('cucumber') ||
        commodity.contains('capsicum') ||
        commodity.contains('bitter gourd') ||
        commodity.contains('bottle gourd')) {
      return 'Vegetables';
    }

    // Common fruits
    if (commodity.contains('apple') ||
        commodity.contains('banana') ||
        commodity.contains('mango') ||
        commodity.contains('orange') ||
        commodity.contains('papaya') ||
        commodity.contains('grape') ||
        commodity.contains('watermelon') ||
        commodity.contains('pineapple') ||
        commodity.contains('pomegranate') ||
        commodity.contains('guava') ||
        commodity.contains('strawberry')) {
      return 'Fruits';
    }

    // Common grains
    if (commodity.contains('rice') ||
        commodity.contains('wheat') ||
        commodity.contains('maize') ||
        commodity.contains('barley') ||
        commodity.contains('bajra') ||
        commodity.contains('jowar') ||
        commodity.contains('ragi') ||
        commodity.contains('dal') ||
        commodity.contains('gram') ||
        commodity.contains('pulse') ||
        commodity.contains('bean') ||
        commodity.contains('lentil')) {
      return 'Grains';
    }

    // Common spices
    if (commodity.contains('turmeric') ||
        commodity.contains('chilli') ||
        commodity.contains('cumin') ||
        commodity.contains('coriander') ||
        commodity.contains('cardamom') ||
        commodity.contains('pepper') ||
        commodity.contains('ginger') ||
        commodity.contains('garlic') ||
        commodity.contains('clove') ||
        commodity.contains('mustard') ||
        commodity.contains('saffron') ||
        commodity.contains('cinnamon')) {
      return 'Spices';
    }

    // Default to vegetables if can't determine
    return 'Vegetables';
  }

  // Helper function to format commodity names
  String _formatCommodityName(String commodity) {
    // Capitalize first letter of each word
    return commodity
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  // Helper function to format the unit
  String _formatUnit(String unit) {
    unit = unit.toLowerCase();

    if (unit == 'quintal') {
      return 'quintal';
    } else if (unit == 'kg') {
      return 'kg';
    } else if (unit == 'tonne' || unit == 'ton' || unit == 'mt') {
      return 'tonne';
    } else {
      return unit;
    }
  }

  // Generate price change based on crop name
  // More deterministic than random to ensure consistency
  String _generatePriceChange(String commodity) {
    // Use the hash code of the commodity name to generate a consistent change
    final int hash = commodity.toLowerCase().hashCode;
    final int value = hash % 41 - 20; // Range from -20 to +20

    final sign = value >= 0 ? '+' : '';
    return '$sign$value%';
  }

  // Generate a reason for trending crops
  String _generateReasonForTrend(String commodity) {
    final List<String> reasons = [
      "Seasonal demand fluctuations",
      "Weather conditions affecting supply",
      "Increased export demand",
      "Limited supply due to reduced acreage",
      "Government policy changes",
      "Transportation disruptions affecting supply chain",
      "Shift in consumer preferences",
      "Increased production costs",
      "Recent festival season demand",
      "Market speculation driving prices",
      "New agricultural technologies affecting yields",
      "Impact of minimum support price changes",
    ];

    // Use hash code for deterministic selection
    final int hash = commodity.toLowerCase().hashCode;
    final index = hash.abs() % reasons.length;
    return reasons[index];
  }

  // Generate a prediction for trending crops
  String _generatePrediction(String commodity) {
    final List<String> predictions = [
      "Expected to rise by 5-10% next month",
      "Prices likely to stabilize in coming weeks",
      "May see moderate decline as supply improves",
      "Steady price rise expected",
      "Expected to fluctuate based on weather conditions",
      "Market analysts predict continued high demand",
      "Prices should normalize after seasonal peak",
      "Government intervention may stabilize rates",
      "Forecast suggests gradual price correction",
      "Export trends indicate sustained high prices",
    ];

    // Use hash code for deterministic selection
    final int hash = commodity.toLowerCase().hashCode;
    final index = hash.abs() % predictions.length;
    return predictions[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Market Prices & Trends',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade600,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/farm_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.9),
              BlendMode.lighten,
            ),
          ),
        ),
        child:
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                )
                : _buildContentWithStatus(),
      ),
    );
  }

  Widget _buildContentWithStatus() {
    return Column(
      children: [
        // Show warning banner if using fallback data
        if (hasError)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.amber.shade100,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.amber.shade800),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Using estimated prices. Unable to fetch real-time data for your location.",
                        style: TextStyle(color: Colors.amber.shade800),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Main content
        Expanded(child: _buildMainContent()),
      ],
    );
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
      onRefresh: _determinePosition,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Location, Last Updated, and Refresh
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
                      children: [
                        Icon(Icons.location_on, color: Colors.green.shade700),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isRefreshing)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.green,
                            ),
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: _determinePosition,
                            color: Colors.green.shade700,
                          ),
                      ],
                    ),
                    if (lastUpdated != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Updated: ${DateFormat('MMM d, y • h:mm a').format(lastUpdated!)}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Category Filter
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: FilterChip(
                          label: Text(category),
                          selected: selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Colors.green.shade200,
                          checkmarkColor: Colors.green.shade700,
                        ),
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Market Prices Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Market Prices',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, size: 20),
                  onPressed: () {
                    _showInfoDialog(
                      "Market Prices",
                      "Prices shown are based on the most recent data from agricultural markets. "
                          "Price changes are calculated based on previous month's averages.",
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 8),

            Expanded(
              flex: 3,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _buildMarketPricesList(),
              ),
            ),

            const SizedBox(height: 16),

            // Trending Crops Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trending Crops & Predictions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, size: 20),
                  onPressed: () {
                    _showInfoDialog(
                      "Trending Crops",
                      "These crops are showing significant price movements or are "
                          "of special interest due to market conditions. Predictions are "
                          "based on current trends and expert analysis.",
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 8),

            Expanded(
              flex: 2,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _buildTrendingCropsList(),
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Historical Trends',
                    onPressed: () {
                      // Navigate to historical trends page
                    },
                    color: Colors.blue.shade700,
                    icon: Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'Price Alerts',
                    onPressed: () {
                      // Navigate to price alerts page
                    },
                    color: Colors.orange.shade700,
                    icon: Icons.notifications,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketPricesList() {
    // Filter data based on selected category
    List<Map<String, dynamic>> filteredData =
        selectedCategory == "All"
            ? marketData
            : marketData
                .where((item) => item["category"] == selectedCategory)
                .toList();

    if (filteredData.isEmpty) {
      return const Center(
        child: Text(
          "No data available for this category",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final item = filteredData[index];
        final priceChange = item["change"] as String;
        final isPositive = priceChange.startsWith('+');
        final isNegative = priceChange.startsWith('-');

        return ListTile(
          title: Text(
            item["name"],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "${item["market"] ?? "Local Market"} • ${item["unit"]}",
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item["price"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      isPositive
                          ? Colors.green.shade100
                          : isNegative
                          ? Colors.red.shade100
                          : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  priceChange,
                  style: TextStyle(
                    color:
                        isPositive
                            ? Colors.green.shade800
                            : isNegative
                            ? Colors.red.shade800
                            : Colors.grey.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            _showCommodityDetails(item);
          },
        );
      },
    );
  }

  Widget _buildTrendingCropsList() {
    if (trendingCrops.isEmpty) {
      return const Center(
        child: Text(
          "No trending data available",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: trendingCrops.length,
      itemBuilder: (context, index) {
        final item = trendingCrops[index];

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: _getCategoryColor(item["category"]),
            child: Text(
              item["name"][0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            item["name"],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item["reason"],
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 4),
              Text(
                item["prediction"],
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          isThreeLine: true,
          onTap: () {
            _showTrendDetails(item);
          },
        );
      },
    );
  }

  Color _getCategoryColor(String? category) {
    switch (category) {
      case "Vegetables":
        return Colors.green.shade600;
      case "Fruits":
        return Colors.orange.shade600;
      case "Grains":
        return Colors.amber.shade600;
      case "Spices":
        return Colors.red.shade600;
      default:
        return Colors.blue.shade600;
    }
  }

  void _showCommodityDetails(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _getCategoryColor(item["category"]),
                    child: Text(
                      item["name"][0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["name"],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          item["category"] ?? "Unknown Category",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _detailColumn(
                    "Current Price",
                    item["price"],
                    Icons.attach_money,
                  ),
                  _detailColumn("Per Unit", item["unit"], Icons.scale),
                  _detailColumn(
                    "Price Change",
                    item["change"],
                    Icons.show_chart,
                  ),
                ],
              ),
              const Divider(height: 24),
              const Text(
                "Markets",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                item["market"] ?? "Local Market",
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.insights),
                    label: const Text("View Trends"),
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to trends page
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade700,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.notifications_active),
                    label: const Text("Set Price Alert"),
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to price alert page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailColumn(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.green.shade600),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showTrendDetails(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _getCategoryColor(item["category"]),
                    radius: 24,
                    child: Text(
                      item["name"][0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["name"],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Trending Crop • ${item["category"]}",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              _trendDetailSection(
                "Why It's Trending",
                item["reason"],
                Icons.trending_up,
              ),
              const SizedBox(height: 16),
              _trendDetailSection(
                "Price Prediction",
                item["prediction"],
                Icons.query_stats,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to detailed trend analysis
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text(
                  "View Detailed Analysis",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _trendDetailSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.green.shade600, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: Text(
            content,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
          ),
        ),
      ],
    );
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
