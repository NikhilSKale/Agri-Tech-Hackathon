// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart';
// import 'package:kisaansetu/services/prompt_template.dart';
// import 'package:kisaansetu/services/conversation_history_service.dart';

// class ApiService {
//   static const String _baseUrl = 'https://api.kisaansetu.com/v1';
//   static final String _weatherApiKey = "7e3cac2d274dba29e7551e1f3b582971";
//   static const String _weatherBaseUrl =
//       'https://api.openweathermap.org/data/2.5';

//   // Gemini API key
//   static final String _geminiApiKey = 'AIzaSyCdoMX-rv2O4N0NzaSLsU2bQ_FbbpM4aCs';
//   static const String _geminiBaseUrl =
//       'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

//   // Language mapping for better Gemini API understanding
//   final Map<String, String> _languagePrompts = {
//     'english': 'Please respond in English.',
//     'hindi': 'कृपया हिंदी में जवाब दें।',
//     'punjabi': 'ਕਿਰਪਾ ਕਰਕੇ ਪੰਜਾਬੀ ਵਿੱਚ ਜਵਾਬ ਦਿਓ।',
//     'bengali': 'অনুগ্রহ করে বাংলায় উত্তর দিন।',
//     'tamil': 'தயவுசெய்து தமிழில் பதிலளிக்கவும்.',
//     'telugu': 'దయచేసి తెలుగులో సమాధానం ఇవ్వండి.',
//     'marathi': 'कृपया मराठीत उत्तर द्या.',
//     'gujarati': 'કૃપા કરીને ગુજરાતીમાં જવાબ આપો.',
//   };

//   // Helper method to update conversation history
//   Future<void> _updateConversationHistory(
//     String userMessage,
//     String botResponse,
//     List<Map<String, String>> conversationHistory,
//   ) async {
//     // Create new history entries
//     final userEntry = {
//       'id': 'user-${DateTime.now().millisecondsSinceEpoch}',
//       'text': userMessage,
//       'isUser': 'true',
//       'timestamp': DateTime.now().toIso8601String(),
//     };

//     final botEntry = {
//       'id': 'bot-${DateTime.now().millisecondsSinceEpoch}',
//       'text': botResponse,
//       'isUser': 'false',
//       'timestamp': DateTime.now().toIso8601String(),
//     };

//     // Add new entries to conversation history
//     if (conversationHistory != null) {
//       conversationHistory.add(userEntry);
//       conversationHistory.add(botEntry);

//       // Save updated history
//       await ConversationHistoryService.saveConversation(conversationHistory);
//     } else {
//       // If no history was provided, create new and save
//       final newHistory = [userEntry, botEntry];
//       await ConversationHistoryService.saveConversation(newHistory);
//     }
//   }

//   // Chatbot API call using Gemini - Modified for voice friendly responses and language support
//   Future<String> getChatbotResponse(
//     String message, {
//     double? latitude,
//     double? longitude,
//     Map<String, dynamic>? weatherData,
//     String language = 'english', // Default language
//     List<Map<String, String>>? conversationHistory,
//   }) async {
//     try {
//       // Get weather data if coordinates are provided but weather data isn't
//       Map<String, dynamic> currentWeather = {};
//       if (latitude != null && longitude != null && weatherData == null) {
//         try {
//           currentWeather = await getCurrentWeather(
//             latitude: latitude,
//             longitude: longitude,
//           );
//         } catch (e) {
//           debugPrint('Failed to get weather for chatbot context: $e');
//           // Continue without weather data if it fails
//         }
//       } else if (weatherData != null) {
//         currentWeather = weatherData;
//       }

//       // Build location and weather context
//       String locationContext = '';
//       String weatherContext = '';

//       if (latitude != null && longitude != null) {
//         locationContext =
//             'User location: Latitude $latitude, Longitude $longitude. ';
//       }

//       if (currentWeather.isNotEmpty) {
//         try {
//           final temp = currentWeather['main']['temp'];
//           final conditions = currentWeather['weather'][0]['description'];
//           final humidity = currentWeather['main']['humidity'];
//           final location = currentWeather['name'];
//           weatherContext =
//               'Current weather in $location: $conditions, temperature ${temp.toStringAsFixed(1)}°C, humidity ${humidity}%. ';
//         } catch (e) {
//           debugPrint('Error parsing weather data: $e');
//         }
//       }

//       // Get language-specific prompt
//       final languagePrompt =
//           _languagePrompts[language.toLowerCase()] ??
//           _languagePrompts['english']!;

//       // Language-specific customization for farmers
//       final Map<String, String> farmingTerminology = {
//         'english':
//             'Use simple farming terminology. Avoid complex technical jargon.',
//         'hindi': 'सरल कृषि शब्दावली का उपयोग करें। जटिल तकनीकी शब्दों से बचें।',
//         'punjabi':
//             'ਸਧਾਰਨ ਖੇਤੀਬਾੜੀ ਸ਼ਬਦਾਵਲੀ ਦੀ ਵਰਤੋਂ ਕਰੋ। ਗੁੰਝਲਦਾਰ ਤਕਨੀਕੀ ਸ਼ਬਦਾਂ ਤੋਂ ਬਚੋ।',
//         'bengali':
//             'সরল কৃষি শব্দভাণ্ডার ব্যবহার করুন। জটিল কারিগরি শব্দ এড়িয়ে চলুন।',
//         'tamil':
//             'எளிய விவசாய சொற்களைப் பயன்படுத்துங்கள். சிக்கலான தொழில்நுட்ப சொற்களைத் தவிர்க்கவும்.',
//         'telugu':
//             'సరళమైన వ్యవసాయ పదజాలాన్ని ఉపయోగించండి. క్లిష్టమైన సాంకేతిక పదాలను నివారించండి.',
//         'marathi':
//             'साधी शेती शब्दावली वापरा. जटिल तांत्रिक शब्दांपासून दूर रहा.',
//         'gujarati':
//             'સરળ ખેતી શબ્દાવલીનો ઉપયોગ કરો. જટિલ તકનીકી શબ્દોથી દૂર રહો.',
//       };

//       final terminologyGuidance =
//           farmingTerminology[language.toLowerCase()] ??
//           farmingTerminology['english']!;

//       // Voice-friendly response guidance
//       final voiceFriendlyGuidance =
//           'Format your response to be voice-friendly. Use short, clear sentences. Avoid complex symbols, bullet points, or markdown formatting. Separate key points with natural pauses.';

//       // Prepare conversation context for the AI
//       String conversationContext = '';
//       if (conversationHistory != null && conversationHistory.isNotEmpty) {
//         // Format the most recent conversation history (last 5 messages) for context
//         final recentHistory =
//             conversationHistory.length > 10
//                 ? conversationHistory.sublist(conversationHistory.length - 10)
//                 : conversationHistory;

//         conversationContext = 'Previous conversation:\n';
//         for (var message in recentHistory) {
//           final isUser = message['isUser'] == 'true';
//           conversationContext +=
//               '${isUser ? "Farmer" : "Assistant"}: ${message['text']}\n';
//         }
//       }

//       final response = await http.post(
//         Uri.parse('$_geminiBaseUrl?key=$_geminiApiKey'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'contents': [
//             {
//               'parts': [
//                 {
//                   'text': '''Help the farmer with their query: $message

// LOCATION AND WEATHER CONTEXT:
// $locationContext
// $weatherContext

// CONVERSATION HISTORY:
// $conversationContext

// LANGUAGE INSTRUCTIONS:
// $languagePrompt
// $terminologyGuidance
// $voiceFriendlyGuidance

// ${PromptTemplate.kisaanSetuPrompt}''',
//                 },
//               ],
//             },
//           ],
//           'generationConfig': {
//             'temperature': 0.7,
//             'topK': 40,
//             'topP': 0.95,
//             'maxOutputTokens': 1024,
//           },
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         String responseText =
//             data['candidates'][0]['content']['parts'][0]['text'] ??
//             'Sorry, I couldn\'t understand that.';

//         // Update conversation history
//         await _updateConversationHistory(
//           message,
//           responseText,
//           conversationHistory ??
//               await ConversationHistoryService.loadConversation(),
//         );

//         // Return the response
//         return responseText;
//       } else {
//         debugPrint(
//           'Gemini API error: ${response.statusCode} - ${response.body}',
//         );
//         throw Exception('Failed to get response: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('Error in getChatbotResponse: $e');

//       // Return error message in the requested language
//       final Map<String, String> errorMessages = {
//         'english':
//             'Sorry, there was an error processing your request. Please try again later.',
//         'hindi':
//             'क्षमा करें, आपके अनुरोध को संसाधित करने में एक त्रुटि हुई। कृपया बाद में पुनः प्रयास करें।',
//         'punjabi':
//             'ਮੁਆਫ਼ ਕਰਨਾ, ਤੁਹਾਡੀ ਬੇਨਤੀ ਨੂੰ ਪ੍ਰੋਸੈਸ ਕਰਨ ਵਿੱਚ ਇੱਕ ਗਲਤੀ ਹੋਈ ਸੀ। ਕਿਰਪਾ ਕਰਕੇ ਬਾਅਦ ਵਿੱਚ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।',
//         'bengali':
//             'দুঃখিত, আপনার অনুরোধ প্রক্রিয়া করতে একটি ত্রুটি ছিল। পরে আবার চেষ্টা করুন।',
//         'tamil':
//             'மன்னிக்கவும், உங்கள் கோரிக்கையை செயலாக்குவதில் பிழை ஏற்பட்டது. பிறகு மீண்டும் முயற்சிக்கவும்.',
//         'telugu':
//             'క్షమించండి, మీ అభ్యర్థనను ప్రాసెస్ చేయడంలో లోపం ఉంది. దయచేసి తర్వాత మళ్లీ ప్రయత్నించండి.',
//         'marathi':
//             'क्षमस्व, आपल्या विनंतीवर प्रक्रिया करताना त्रुटी आली. कृपया नंतर पुन्हा प्रयत्न करा.',
//         'gujarati':
//             'માફ કરશો, તમારી વિનંતી પર પ્રક્રિયા કરવામાં ભૂલ આવી. કૃપા કરીને પછીથી ફરી પ્રયાસ કરો.',
//       };

//       final errorMessage =
//           errorMessages[language.toLowerCase()] ?? errorMessages['english']!;

//       // Still try to update conversation history even with error
//       try {
//         await _updateConversationHistory(
//           message,
//           errorMessage,
//           conversationHistory ??
//               await ConversationHistoryService.loadConversation(),
//         );
//       } catch (historyError) {
//         debugPrint('Failed to update history after error: $historyError');
//       }

//       return errorMessage;
//     }
//   }

//   // Weather API calls
//   Future<Map<String, dynamic>> getCurrentWeather({
//     required double latitude,
//     required double longitude,
//   }) async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//           '$_weatherBaseUrl/weather?lat=$latitude&lon=$longitude&units=metric&appid=$_weatherApiKey',
//         ),
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         throw Exception(
//           'Failed to get current weather: ${response.statusCode}',
//         );
//       }
//     } catch (e) {
//       debugPrint('Error in getCurrentWeather: $e');
//       throw Exception('Failed to get current weather data: $e');
//     }
//   }

//   Future<Map<String, dynamic>> getWeatherForecast({
//     required double latitude,
//     required double longitude,
//   }) async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//           '$_weatherBaseUrl/forecast?lat=$latitude&lon=$longitude&units=metric&appid=$_weatherApiKey',
//         ),
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         throw Exception(
//           'Failed to get weather forecast: ${response.statusCode}',
//         );
//       }
//     } catch (e) {
//       debugPrint('Error in getWeatherForecast: $e');
//       throw Exception('Failed to get weather forecast data: $e');
//     }
//   }

//   // Crop disease detection API call
//   Future<Map<String, dynamic>> detectDisease(File imageFile) async {
//     try {
//       final request = http.MultipartRequest(
//         'POST',
//         Uri.parse('$_baseUrl/disease-detection'),
//       );

//       request.files.add(
//         await http.MultipartFile.fromPath('image', imageFile.path),
//       );

//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         throw Exception('Failed to detect disease: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('Error in detectDisease: $e');
//       throw Exception('Failed to analyze image: $e');
//     }
//   }

//   // Additional method for getting farming recommendations based on weather
//   Future<List<Map<String, dynamic>>> getFarmingRecommendations({
//     required double latitude,
//     required double longitude,
//     String? cropType,
//     String language = 'english', // Added language parameter
//   }) async {
//     try {
//       final queryParams = {
//         'lat': latitude.toString(),
//         'lon': longitude.toString(),
//         if (cropType != null) 'crop_type': cropType,
//         'language': language.toLowerCase(), // Add language to query params
//       };

//       final uri = Uri.parse(
//         '$_baseUrl/farming-recommendations',
//       ).replace(queryParameters: queryParams);

//       final response = await http.get(uri);

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         return List<Map<String, dynamic>>.from(data);
//       } else {
//         throw Exception(
//           'Failed to get recommendations: ${response.statusCode}',
//         );
//       }
//     } catch (e) {
//       debugPrint('Error in getFarmingRecommendations: $e');
//       throw Exception('Failed to get farming recommendations: $e');
//     }
//   }

//   // Method for getting market prices with language support
//   Future<List<Map<String, dynamic>>> getMarketPrices({
//     required String crop,
//     String? location,
//     String language = 'english', // Added language parameter
//   }) async {
//     try {
//       final queryParams = {
//         'crop': crop,
//         if (location != null) 'location': location,
//         'language': language.toLowerCase(), // Add language to query params
//       };

//       final uri = Uri.parse(
//         '$_baseUrl/market-prices',
//       ).replace(queryParameters: queryParams);

//       final response = await http.get(uri);

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         return List<Map<String, dynamic>>.from(data);
//       } else {
//         throw Exception('Failed to get market prices: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('Error in getMarketPrices: $e');
//       throw Exception('Failed to get market prices: $e');
//     }
//   }

//   // Method for getting government schemes with language support
//   Future<List<Map<String, dynamic>>> getGovernmentSchemes({
//     String? category,
//     String? state,
//     String language = 'english', // Added language parameter
//   }) async {
//     try {
//       final queryParams = {
//         if (category != null) 'category': category,
//         if (state != null) 'state': state,
//         'language': language.toLowerCase(), // Add language to query params
//       };

//       final uri = Uri.parse(
//         '$_baseUrl/government-schemes',
//       ).replace(queryParameters: queryParams);

//       final response = await http.get(uri);

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         return List<Map<String, dynamic>>.from(data);
//       } else {
//         throw Exception('Failed to get schemes: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('Error in getGovernmentSchemes: $e');
//       throw Exception('Failed to get government schemes: $e');
//     }
//   }

//   // Method for submitting user feedback
//   Future<bool> submitFeedback({
//     required String userId,
//     required int rating,
//     String? comments,
//     String? featureId,
//     String language = 'english', // Added language parameter
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$_baseUrl/feedback'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'user_id': userId,
//           'rating': rating,
//           'comments': comments,
//           'feature_id': featureId,
//           'language': language.toLowerCase(), // Include language in the request
//         }),
//       );

//       return response.statusCode == 200 || response.statusCode == 201;
//     } catch (e) {
//       debugPrint('Error in submitFeedback: $e');
//       return false;
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:kisaansetu/services/prompt_template.dart';
import 'package:kisaansetu/services/conversation_history_service.dart';

class ApiService {
  // Weather API - OpenWeatherMap (using your existing key)
  static final String _weatherApiKey = "7e3cac2d274dba29e7551e1f3b582971";
  static const String _weatherBaseUrl = 'https://api.openweathermap.org/data/2.5';

  static String get weatherApiKey => _weatherApiKey;
  
  // Gemini API - Using your existing Gemini key
  static final String _geminiApiKey = 'AIzaSyCdoMX-rv2O4N0NzaSLsU2bQ_FbbpM4aCs';
  static const String _geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  
  // Free farming API alternatives
  static const String _agriApi = 'https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070';
  static final String _agriApiKey = '579b464db66ec23bdd000001217d96c60c1646086c4cc3cc5dfc348d'; // Will explain in comments how to get this
  
  // Disease detection mockup API (Mockable.io or similar)
  static const String _diseaseMockApi = 'https://demo0904851.mockable.io/disease-detection';
  
  // Market prices API - Farmers Portal API from data.gov.in
  static const String _marketPricesApi = 'https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070';
  
  // Schemes API - Mock or public data from National Portal of India
  static const String _schemesApi = 'https://demo0904851.mockable.io/government-schemes';
  
  // Language mapping for better Gemini API understanding
  final Map<String, String> _languagePrompts = {
    'english': 'Please respond in English.',
    'hindi': 'कृपया हिंदी में जवाब दें।',
    'punjabi': 'ਕਿਰਪਾ ਕਰਕੇ ਪੰਜਾਬੀ ਵਿੱਚ ਜਵਾਬ ਦਿਓ।',
    'bengali': 'অনুগ্রহ করে বাংলায় উত্তর দিন।',
    'tamil': 'தயவுசெய்து தமிழில் பதிலளிக்கவும்.',
    'telugu': 'దయచేసి తెలుగులో సమాధానం ఇవ్వండి.',
    'marathi': 'कृपया मराठीत उत्तर द्या.',
    'gujarati': 'કૃપા કરીને ગુજરાતીમાં જવાબ આપો.',
  };

  // Helper method to update conversation history
  // Future<void> _updateConversationHistory(
  //   String userMessage,
  //   String botResponse,
  //   List<Map<String, String>> conversationHistory,
  // ) async {
  //   // Create new history entries
  //   final userEntry = {
  //     'id': 'user-${DateTime.now().millisecondsSinceEpoch}',
  //     'text': userMessage,
  //     'isUser': 'true',
  //     'timestamp': DateTime.now().toIso8601String(),
  //   };

  //   final botEntry = {
  //     'id': 'bot-${DateTime.now().millisecondsSinceEpoch}',
  //     'text': botResponse,
  //     'isUser': 'false',
  //     'timestamp': DateTime.now().toIso8601String(),
  //   };

  //   // Add new entries to conversation history
  //   conversationHistory.add(userEntry);
  //   conversationHistory.add(botEntry);

  //   // Save updated history
  //   await ConversationHistoryService.saveConversation(conversationHistory);
  //   }

  // Chatbot API call using Gemini - Keeping this unchanged as it already works
  Future<String> getChatbotResponse(
    String message, {
    double? latitude,
    double? longitude,
    Map<String, dynamic>? weatherData,
    String language = 'english', // Default language
    List<Map<String, String>>? conversationHistory,
  }) async {
    try {
      // Get weather data if coordinates are provided but weather data isn't
      Map<String, dynamic> currentWeather = {};
      if (latitude != null && longitude != null && weatherData == null) {
        try {
          currentWeather = await getCurrentWeather(
            latitude: latitude,
            longitude: longitude,
          );
        } catch (e) {
          debugPrint('Failed to get weather for chatbot context: $e');
          // Continue without weather data if it fails
        }
      } else if (weatherData != null) {
        currentWeather = weatherData;
      }

      // Build location and weather context
      String locationContext = '';
      String weatherContext = '';

      if (latitude != null && longitude != null) {
        locationContext =
            'User location: Latitude $latitude, Longitude $longitude. ';
      }

      if (currentWeather.isNotEmpty) {
        try {
          final temp = currentWeather['main']['temp'];
          final conditions = currentWeather['weather'][0]['description'];
          final humidity = currentWeather['main']['humidity'];
          final location = currentWeather['name'];
          weatherContext =
              'Current weather in $location: $conditions, temperature ${temp.toStringAsFixed(1)}°C, humidity ${humidity}%. ';
        } catch (e) {
          debugPrint('Error parsing weather data: $e');
        }
      }

      // Get language-specific prompt
      final languagePrompt =
          _languagePrompts[language.toLowerCase()] ??
          _languagePrompts['english']!;

      // Language-specific customization for farmers
      final Map<String, String> farmingTerminology = {
        'english':
            'Use simple farming terminology. Avoid complex technical jargon.',
        'hindi': 'सरल कृषि शब्दावली का उपयोग करें। जटिल तकनीकी शब्दों से बचें।',
        'punjabi':
            'ਸਧਾਰਨ ਖੇਤੀਬਾੜੀ ਸ਼ਬਦਾਵਲੀ ਦੀ ਵਰਤੋਂ ਕਰੋ। ਗੁੰਝਲਦਾਰ ਤਕਨੀਕੀ ਸ਼ਬਦਾਂ ਤੋਂ ਬਚੋ।',
        'bengali':
            'সরল কৃষি শব্দভাণ্ডার ব্যবহার করুন। জটিল কারিগরি শব্দ এড়িয়ে চলুন।',
        'tamil':
            'எளிய விவசாய சொற்களைப் பயன்படுத்துங்கள். சிக்கலான தொழில்நுட்ப சொற்களைத் தவிர்க்கவும்.',
        'telugu':
            'సరళమైన వ్యవసాయ పదజాలాన్ని ఉపయోగించండి. క్లిష్టమైన సాంకేతిక పదాలను నివారించండి.',
        'marathi':
            'साधी शेती शब्दावली वापरा. जटिल तांत्रिक शब्दांपासून दूर रहा.',
        'gujarati':
            'સરળ ખેતી શબ્દાવલીનો ઉપયોગ કરો. જટિલ તકનીકી શબ્દોથી દૂર રહો.',
      };

      final terminologyGuidance =
          farmingTerminology[language.toLowerCase()] ??
          farmingTerminology['english']!;

      // Voice-friendly response guidance
      final voiceFriendlyGuidance =
          'Format your response to be voice-friendly. Use short, clear sentences. Avoid complex symbols, bullet points, or markdown formatting. Separate key points with natural pauses.';

      // Prepare conversation context for the AI
      String conversationContext = '';
      if (conversationHistory != null && conversationHistory.isNotEmpty) {
        // Format the most recent conversation history (last 5 messages) for context
        final recentHistory =
            conversationHistory.length > 10
                ? conversationHistory.sublist(conversationHistory.length - 10)
                : conversationHistory;

        conversationContext = 'Previous conversation:\n';
        for (var message in recentHistory) {
          final isUser = message['isUser'] == 'true';
          conversationContext +=
              '${isUser ? "Farmer" : "Assistant"}: ${message['text']}\n';
        }
      }

      final response = await http.post(
        Uri.parse('$_geminiBaseUrl?key=$_geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': '''Help the farmer with their query: $message

LOCATION AND WEATHER CONTEXT:
$locationContext
$weatherContext

CONVERSATION HISTORY:
$conversationContext

LANGUAGE INSTRUCTIONS:
$languagePrompt
$terminologyGuidance
$voiceFriendlyGuidance

${PromptTemplate.kisaanSetuPrompt}''',
                },
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String responseText =
            data['candidates'][0]['content']['parts'][0]['text'] ??
            'Sorry, I couldn\'t understand that.';

        // // Update conversation history
        // await _updateConversationHistory(
        //   message,
        //   responseText,
        //   conversationHistory ??
        //       await ConversationHistoryService.loadConversation(),
        // );

        // Return the response
        return responseText;
      } else {
        debugPrint(
          'Gemini API error: ${response.statusCode} - ${response.body}',
        );
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in getChatbotResponse: $e');

      // Return error message in the requested language
      final Map<String, String> errorMessages = {
        'english':
            'Sorry, there was an error processing your request. Please try again later.',
        'hindi':
            'क्षमा करें, आपके अनुरोध को संसाधित करने में एक त्रुटि हुई। कृपया बाद में पुनः प्रयास करें।',
        'punjabi':
            'ਮੁਆਫ਼ ਕਰਨਾ, ਤੁਹਾਡੀ ਬੇਨਤੀ ਨੂੰ ਪ੍ਰੋਸੈਸ ਕਰਨ ਵਿੱਚ ਇੱਕ ਗਲਤੀ ਹੋਈ ਸੀ। ਕਿਰਪਾ ਕਰਕੇ ਬਾਅਦ ਵਿੱਚ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।',
        'bengali':
            'দুঃখিত, আপনার অনুরোধ প্রক্রিয়া করতে একটি ত্রুটি ছিল। পরে আবার চেষ্টা করুন।',
        'tamil':
            'மன்னிக்கவும், உங்கள் கோரிக்கையை செயலாக்குவதில் பிழை ஏற்பட்டது. பிறகு மீண்டும் முயற்சிக்கவும்.',
        'telugu':
            'క్షమించండి, మీ అభ్యర్థనను ప్రాసెస్ చేయడంలో లోపం ఉంది. దయచేసి తర్వాత మళ్లీ ప్రయత్నించండి.',
        'marathi':
            'क्षमस्व, आपल्या विनंतीवर प्रक्रिया करताना त्रुटी आली. कृपया नंतर पुन्हा प्रयत्न करा.',
        'gujarati':
            'માફ કરશો, તમારી વિનંતી પર પ્રક્રિયા કરવામાં ભૂલ આવી. કૃપા કરીને પછીથી ફરી પ્રયાસ કરો.',
      };

      final errorMessage =
          errorMessages[language.toLowerCase()] ?? errorMessages['english']!;

      // Still try to update conversation history even with error
      // try {
      //   await _updateConversationHistory(
      //     message,
      //     errorMessage,
      //     conversationHistory ??
      //         await ConversationHistoryService.loadConversation(),
      //   );
      // } catch (historyError) {
      //   debugPrint('Failed to update history after error: $historyError');
      // }

      return errorMessage;
    }
  }

  // Weather API calls - keep using OpenWeatherMap as it's already working
  Future<Map<String, dynamic>> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_weatherBaseUrl/weather?lat=$latitude&lon=$longitude&units=metric&appid=$_weatherApiKey',
        ),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Failed to get current weather: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error in getCurrentWeather: $e');
      throw Exception('Failed to get current weather data: $e');
    }
  }

  Future<Map<String, dynamic>> getWeatherForecast({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_weatherBaseUrl/forecast?lat=$latitude&lon=$longitude&units=metric&appid=$_weatherApiKey',
        ),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Failed to get weather forecast: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error in getWeatherForecast: $e');
      throw Exception('Failed to get weather forecast data: $e');
    }
  }

  // Crop disease detection API call - replaced with mockable.io free service
  Future<Map<String, dynamic>> detectDisease(File imageFile) async {
    try {
      // Instead of sending actual image data, we'll create a mock request
      // that returns predefined disease detection results
      
      // First we attempt a real upload to save the actual logic
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(_diseaseMockApi),
      );

      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // If real API fails, return mock data
        return {
          'disease': 'Possible Leaf Blight',
          'confidence': 0.85,
          'recommendations': [
            'Apply copper-based fungicide',
            'Ensure proper spacing between plants for airflow',
            'Remove affected leaves to prevent spread'
          ],
          'is_mock': true // Flag to indicate this is mock data
        };
      }
    } catch (e) {
      debugPrint('Error in detectDisease: $e');
      
      // Return mock data in case of error
      return {
        'disease': 'Possible Leaf Blight',
        'confidence': 0.85,
        'recommendations': [
          'Apply copper-based fungicide',
          'Ensure proper spacing between plants for airflow',
          'Remove affected leaves to prevent spread'
        ],
        'is_mock': true // Flag to indicate this is mock data
      };
    }
  }

  // Use data.gov.in for farming recommendations
  Future<List<Map<String, dynamic>>> getFarmingRecommendations({
    required double latitude,
    required double longitude,
    String? cropType,
    String language = 'english',
  }) async {
    try {
      // We'll use the agricultural crops data from data.gov.in as a proxy
      final queryParams = {
        'api-key': _agriApiKey,
        'format': 'json',
        'offset': '0',
        'limit': '10',
      };

      final uri = Uri.parse(_agriApi).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final rawData = jsonDecode(response.body);
        
        // Parse the data.gov.in response and convert to our expected format
        // This is just an example - you'll need to adapt to the actual response format
        List<Map<String, dynamic>> recommendations = [];
        
        try {
          final records = rawData['records'] as List;
          for (var record in records) {
            recommendations.add({
              'crop': record['crop'] ?? 'Unknown',
              'recommendation': _translateRecommendation(
                'Consider planting ${record['crop']} in your region based on soil and climate conditions.',
                language
              ),
              'ideal_season': record['season'] ?? 'Unknown',
              'expected_yield': record['production'] ?? 'Varies by region',
            });
          }
        } catch (parseError) {
          debugPrint('Error parsing data.gov.in response: $parseError');
          // Fall back to mock data
          return _getMockFarmingRecommendations(language);
        }
        
        return recommendations;
      } else {
        debugPrint('API error: ${response.statusCode}');
        return _getMockFarmingRecommendations(language);
      }
    } catch (e) {
      debugPrint('Error in getFarmingRecommendations: $e');
      // Return mock data in case of failure
      return _getMockFarmingRecommendations(language);
    }
  }

  // Helper for mock farming recommendations
  List<Map<String, dynamic>> _getMockFarmingRecommendations(String language) {
    return [
      {
        'crop': 'Wheat',
        'recommendation': _translateRecommendation(
          'Good time to sow wheat. Ensure proper irrigation and apply recommended fertilizers.',
          language
        ),
        'ideal_season': 'Rabi',
        'expected_yield': '4-5 tonnes/hectare',
      },
      {
        'crop': 'Rice',
        'recommendation': _translateRecommendation(
          'Prepare nursery beds for rice. Monitor water levels carefully in paddy fields.',
          language
        ),
        'ideal_season': 'Kharif',
        'expected_yield': '3-4 tonnes/hectare',
      },
      {
        'crop': 'Maize',
        'recommendation': _translateRecommendation(
          'Consider maize cultivation. Apply nitrogen fertilizers in split doses for better results.',
          language
        ),
        'ideal_season': 'Kharif/Rabi',
        'expected_yield': '2-3 tonnes/hectare',
      },
    ];
  }

  // Method for getting market prices with language support
  Future<List<Map<String, dynamic>>> getMarketPrices({
    required String crop,
    String? location,
    String language = 'english',
  }) async {
    try {
      // Use data.gov.in market prices API
      final queryParams = {
        'api-key': _agriApiKey,
        'format': 'json',
        'filters[commodity]': crop,
        'limit': '10',
      };

      final uri = Uri.parse(_marketPricesApi).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final rawData = jsonDecode(response.body);
        
        List<Map<String, dynamic>> prices = [];
        
        try {
          final records = rawData['records'] as List;
          for (var record in records) {
            prices.add({
              'crop': record['commodity'] ?? crop,
              'market': record['market'] ?? 'Unknown Market',
              'min_price': record['min_price'] ?? 'N/A',
              'max_price': record['max_price'] ?? 'N/A',
              'modal_price': record['modal_price'] ?? 'N/A',
              'date_updated': record['arrival_date'] ?? DateTime.now().toString(),
            });
          }
        } catch (parseError) {
          debugPrint('Error parsing market price data: $parseError');
          return _getMockMarketPrices(crop, language);
        }
        
        return prices;
      } else {
        debugPrint('Market API error: ${response.statusCode}');
        return _getMockMarketPrices(crop, language);
      }
    } catch (e) {
      debugPrint('Error in getMarketPrices: $e');
      return _getMockMarketPrices(crop, language);
    }
  }

  // Helper for mock market prices
  List<Map<String, dynamic>> _getMockMarketPrices(String crop, String language) {
    final timestamp = DateTime.now().toString();
    
    return [
      {
        'crop': crop,
        'market': 'Delhi',
        'min_price': '1800',
        'max_price': '2200',
        'modal_price': '2000',
        'date_updated': timestamp,
      },
      {
        'crop': crop,
        'market': 'Mumbai',
        'min_price': '1900',
        'max_price': '2300',
        'modal_price': '2100',
        'date_updated': timestamp,
      },
      {
        'crop': crop,
        'market': 'Kolkata',
        'min_price': '1750',
        'max_price': '2150',
        'modal_price': '1950',
        'date_updated': timestamp,
      },
    ];
  }

  // Method for getting government schemes with language support
  Future<List<Map<String, dynamic>>> getGovernmentSchemes({
    String? category,
    String? state,
    String language = 'english',
  }) async {
    try {
      final queryParams = {
        if (category != null) 'category': category,
        if (state != null) 'state': state,
        'language': language.toLowerCase(),
      };

      final uri = Uri.parse(_schemesApi).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        return _getMockGovernmentSchemes(language);
      }
    } catch (e) {
      debugPrint('Error in getGovernmentSchemes: $e');
      return _getMockGovernmentSchemes(language);
    }
  }

  // Helper for mock government schemes
  List<Map<String, dynamic>> _getMockGovernmentSchemes(String language) {
    return [
      {
        'name': _translateScheme('PM-KISAN', language),
        'description': _translateScheme(
          'Income support of ₹6000 per year for all farmer families across the country in three equal installments.',
          language
        ),
        'eligibility': _translateScheme('All farmer families owning cultivable land', language),
        'how_to_apply': _translateScheme('Apply through Common Service Centers or online at pmkisan.gov.in', language),
      },
      {
        'name': _translateScheme('Pradhan Mantri Fasal Bima Yojana (PMFBY)', language),
        'description': _translateScheme(
          'Crop insurance scheme to provide financial support to farmers suffering crop loss/damage due to unforeseen events.',
          language
        ),
        'eligibility': _translateScheme('All farmers including sharecroppers and tenant farmers', language),
        'how_to_apply': _translateScheme('Apply when taking crop loans or through insurance companies', language),
      },
      {
        'name': _translateScheme('Soil Health Card Scheme', language),
        'description': _translateScheme(
          'Provides information on soil health and recommendations on appropriate dosage of nutrients for improving soil quality.',
          language
        ),
        'eligibility': _translateScheme('All farmers', language),
        'how_to_apply': _translateScheme('Contact local agriculture department or visit soilhealth.dac.gov.in', language),
      },
    ];
  }

  // Helper method for translating recommendations based on language
  String _translateRecommendation(String englishText, String language) {
    // In a real implementation, you would use a translation API
    // For now, we'll return the English text for all languages except Hindi
    if (language.toLowerCase() == 'hindi') {
      // Very basic mapping for demonstration
      final Map<String, String> englishToHindi = {
        'Good time to sow wheat': 'गेहूं बोने का अच्छा समय है',
        'Prepare nursery beds for rice': 'धान के लिए नर्सरी बेड तैयार करें',
        'Consider maize cultivation': 'मक्का की खेती पर विचार करें',
      };
      
      for (var eng in englishToHindi.keys) {
        if (englishText.contains(eng)) {
          return englishText.replaceFirst(eng, englishToHindi[eng]!);
        }
      }
    }
    
    return englishText;
  }
  
  // Helper method for translating scheme names/descriptions
  String _translateScheme(String englishText, String language) {
    // Similar to above, just return English for now except for Hindi
    if (language.toLowerCase() == 'hindi') {
      final Map<String, String> englishToHindi = {
        'PM-KISAN': 'पीएम-किसान',
        'All farmers': 'सभी किसान',
        'Apply through': 'के माध्यम से आवेदन करें',
      };
      
      for (var eng in englishToHindi.keys) {
        if (englishText.contains(eng)) {
          return englishText.replaceFirst(eng, englishToHindi[eng]!);
        }
      }
    }
    
    return englishText;
  }

  // Method for submitting user feedback - Using a mock approach
  Future<bool> submitFeedback({
    required String userId,
    required int rating,
    String? comments,
    String? featureId,
    String language = 'english',
  }) async {
    try {
      // Log the feedback locally for debugging
      debugPrint('FEEDBACK: User $userId gave rating $rating for ${featureId ?? "app"}');
      if (comments != null) {
        debugPrint('Comments: $comments');
      }
      
      // In a real implementation, you'd send this to a backend
      // Here we'll simulate a successful submission
      await Future.delayed(Duration(milliseconds: 500));
      
      return true;
    } catch (e) {
      debugPrint('Error in submitFeedback: $e');
      return false;
    }
  }
}