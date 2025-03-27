// // import 'package:flutter/material.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:kisaansetu/services/api_service.dart';
// // import 'package:speech_to_text/speech_to_text.dart' as stt;
// // import 'package:flutter_tts/flutter_tts.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class ChatbotScreen extends StatefulWidget {
// //   const ChatbotScreen({Key? key}) : super(key: key);

// //   @override
// //   _ChatbotScreenState createState() => _ChatbotScreenState();
// // }

// // class _ChatbotScreenState extends State<ChatbotScreen> {
// //   final TextEditingController _messageController = TextEditingController();
// //   final ScrollController _scrollController = ScrollController();
// //   final ApiService _apiService = ApiService();
// //   final stt.SpeechToText _speech = stt.SpeechToText();
// //   final FlutterTts _flutterTts = FlutterTts();

// //   List<Map<String, String>> _messages = [];
// //   bool _isListening = false;
// //   bool _isSpeaking = false;
// //   bool _isLoading = false;
// //   bool _autoSpeakEnabled = true;
// //   String? _currentlySpeakingMessageId;

// //   // Language settings
// //   String _selectedLanguage = 'English'; // Default
// //   String _languageCode = 'en-US'; // Default

// //   // Language code mapping
// //   final Map<String, String> _languageCodes = {
// //     'English': 'en-US',
// //     'Hindi': 'hi-IN',
// //     'Punjabi': 'pa-IN',
// //     'Bengali': 'bn-IN',
// //     'Tamil': 'ta-IN',
// //     'Telugu': 'te-IN',
// //     'Marathi': 'mr-IN',
// //     'Gujarati': 'gu-IN',
// //   };

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadLanguagePreference();
// //     _initializeSpeech();
// //     _initializeTts();
// //   }

// //   Future<void> _loadLanguagePreference() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       final savedLanguage = prefs.getString('selectedLanguage');

// //       if (savedLanguage != null) {
// //         setState(() {
// //           _selectedLanguage = savedLanguage;
// //           _languageCode = _languageCodes[savedLanguage] ?? 'en-US';
// //         });
// //       }

// //       // After loading language, add welcome message
// //       _addInitialBotMessage();
// //     } catch (e) {
// //       debugPrint('Error loading language preference: $e');
// //       // If error, still show welcome message with default language
// //       _addInitialBotMessage();
// //     }
// //   }

// //   Future<void> _initializeSpeech() async {
// //     try {
// //       bool available = await _speech.initialize(
// //         onError: (error) => debugPrint('Speech error: $error'),
// //         onStatus: (status) => debugPrint('Speech status: $status'),
// //       );
// //       if (!available) {
// //         debugPrint('Speech recognition not available');
// //       }
// //     } catch (e) {
// //       debugPrint('Error initializing speech: $e');
// //     }
// //   }

// //   Future<void> _initializeTts() async {
// //     try {
// //       await _flutterTts.setLanguage(_languageCode);
// //       await _flutterTts.setPitch(1.0);
// //       await _flutterTts.setSpeechRate(0.5);

// //       _flutterTts.setCompletionHandler(() {
// //         setState(() {
// //           _isSpeaking = false;
// //           _currentlySpeakingMessageId = null;
// //         });
// //       });

// //       _flutterTts.setErrorHandler((error) {
// //         debugPrint('TTS error: $error');
// //         setState(() {
// //           _isSpeaking = false;
// //           _currentlySpeakingMessageId = null;
// //         });
// //       });
// //     } catch (e) {
// //       debugPrint('Error initializing TTS: $e');
// //     }
// //   }

// //   void _addInitialBotMessage() {
// //     // Multilingual welcome messages
// //     final Map<String, String> welcomeMessages = {
// //       'English':
// //           'Hello! I am KisaanSetu AI Assistant. How can I help you today? I can assist with: Crop recommendations, Weather information, Pest control advice, Government schemes, Market prices, and General farming queries',
// //       'Hindi':
// //           'नमस्ते! मैं किसानसेतु AI सहायक हूँ। आज मैं आपकी कैसे मदद कर सकता हूँ? मैं इन विषयों पर सहायता कर सकता हूँ: फसल सिफारिशें, मौसम की जानकारी, कीट नियंत्रण सलाह, सरकारी योजनाएँ, बाजार मूल्य, और सामान्य कृषि प्रश्न',
// //       'Punjabi':
// //           'ਸਤ ਸ੍ਰੀ ਅਕਾਲ! ਮੈਂ ਕਿਸਾਨ ਸੇਤੁ AI ਸਹਾਇਕ ਹਾਂ। ਅੱਜ ਮੈਂ ਤੁਹਾਡੀ ਕਿਵੇਂ ਮਦਦ ਕਰ ਸਕਦਾ ਹਾਂ? ਮੈਂ ਇਹਨਾਂ ਵਿਸ਼ਿਆਂ ਵਿੱਚ ਮਦਦ ਕਰ ਸਕਦਾ ਹਾਂ: ਫਸਲ ਸਿਫਾਰਸ਼ਾਂ, ਮੌਸਮ ਦੀ ਜਾਣਕਾਰੀ, ਕੀੜੇ ਨਿਯੰਤਰਣ ਸਲਾਹ, ਸਰਕਾਰੀ ਯੋਜਨਾਵਾਂ, ਮੰਡੀ ਮੁੱਲ, ਅਤੇ ਆਮ ਖੇਤੀਬਾੜੀ ਸਵਾਲ',
// //       'Bengali':
// //           'নমস্কার! আমি কিষাণসেতু AI সহকারী। আজ আমি আপনাকে কীভাবে সাহায্য করতে পারি? আমি এই বিষয়গুলিতে সাহায্য করতে পারি: ফসলের সুপারিশ, আবহাওয়া তথ্য, কীটপতঙ্গ নিয়ন্ত্রণ পরামর্শ, সরকারি প্রকল্প, বাজার দাম, এবং সাধারণ কৃষি প্রশ্ন',
// //       'Tamil':
// //           'வணக்கம்! நான் கிசான்சேது AI உதவியாளர். இன்று நான் உங்களுக்கு எப்படி உதவ முடியும்? நான் இந்த விஷயங்களில் உதவ முடியும்: பயிர் பரிந்துரைகள், வானிலை தகவல், பூச்சி கட்டுப்பாடு ஆலோசனை, அரசு திட்டங்கள், சந்தை விலைகள், மற்றும் பொதுவான விவசாய கேள்விகள்',
// //       'Telugu':
// //           'నమస్కారం! నేను కిసాన్సేతు AI సహాయకుడిని. నేడు నేను మీకు ఎలా సహాయం చేయగలను? నేను ఈ విషయాలలో సహాయం చేయగలను: పంట సిఫార్సులు, వాతావరణ సమాచారం, పురుగు నియంత్రణ సలహా, ప్రభుత్వ పథకాలు, మార్కెట్ ధరలు, మరియు సాధారణ వ్యవసాయ ప్రశ్నలు',
// //       'Marathi':
// //           'नमस्कार! मी किसानसेतू AI सहाय्यक आहे. आज मी तुम्हाला कशी मदत करू शकतो? मी या विषयांवर मदत करू शकतो: पीक शिफारशी, हवामान माहिती, कीटक नियंत्रण सल्ला, सरकारी योजना, बाजार किंमती, आणि सामान्य शेती प्रश्न',
// //       'Gujarati':
// //           'નમસ્તે! હું કિસાનસેતુ AI સહાયક છું. આજે હું તમને કેવી રીતે મદદ કરી શકું? હું આ વિષયોમાં મદદ કરી શકું છું: પાક ભલામણો, હવામાન માહિતી, જંતુ નિયંત્રણ સલાહ, સરકારી યોજનાઓ, બજાર ભાવો, અને સામાન્ય ખેતી પ્રશ્નો',
// //     };

// //     final welcomeMessage =
// //         welcomeMessages[_selectedLanguage] ?? welcomeMessages['English']!;

// //     _messages.add({
// //       'id': 'welcome',
// //       'sender': 'bot',
// //       'message': welcomeMessage,
// //     });

// //     // Automatically speak the welcome message after a short delay
// //     Future.delayed(const Duration(milliseconds: 500), () {
// //       if (_autoSpeakEnabled) {
// //         _speak(welcomeMessage, 'welcome');
// //       }
// //     });
// //   }

// //   Future<void> _sendMessage(String message) async {
// //     if (message.trim().isEmpty) return;

// //     final messageId = DateTime.now().millisecondsSinceEpoch.toString();

// //     setState(() {
// //       _messages.add({'id': messageId, 'sender': 'user', 'message': message});
// //       _isLoading = true;
// //     });

// //     _messageController.clear();
// //     _scrollToBottom();

// //     try {
// //       // Stop speaking if there's any ongoing speech
// //       if (_isSpeaking) {
// //         await _flutterTts.stop();
// //         setState(() {
// //           _isSpeaking = false;
// //           _currentlySpeakingMessageId = null;
// //         });
// //       }

// //       // Get current location if permission is granted
// //       Position? currentPosition;
// //       try {
// //         bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //         if (serviceEnabled) {
// //           LocationPermission permission = await Geolocator.checkPermission();

// //           if (permission == LocationPermission.whileInUse ||
// //               permission == LocationPermission.always) {
// //             currentPosition = await Geolocator.getCurrentPosition(
// //               desiredAccuracy: LocationAccuracy.high,
// //             );
// //           }
// //         }
// //       } catch (e) {
// //         debugPrint('Error getting location: $e');
// //         // Continue without location if there's an error
// //       }

// //       // Get weather data if location is available
// //       Map<String, dynamic>? weatherData;
// //       if (currentPosition != null) {
// //         try {
// //           weatherData = await _apiService.getCurrentWeather(
// //             latitude: currentPosition.latitude,
// //             longitude: currentPosition.longitude,
// //           );
// //         } catch (e) {
// //           debugPrint('Error getting weather data: $e');
// //           // Continue without weather if there's an error
// //         }
// //       }

// //       // Call the API with location, weather data, and the selected language
// //       final response = await _apiService.getChatbotResponse(
// //         message,
// //         latitude: currentPosition?.latitude,
// //         longitude: currentPosition?.longitude,
// //         weatherData: weatherData,
// //         language:
// //             _selectedLanguage
// //                 .toLowerCase(), // Pass the selected language to the API
// //       );

// //       final processedResponse = _processTextForSpeech(response);

// //       final botMessageId = 'bot-${DateTime.now().millisecondsSinceEpoch}';

// //       setState(() {
// //         _messages.add({
// //           'id': botMessageId,
// //           'sender': 'bot',
// //           'message': response, // Keep original formatting for display
// //         });
// //         _isLoading = false;
// //       });

// //       _scrollToBottom();

// //       // Automatically speak the bot's response if auto-speak is enabled
// //       if (_autoSpeakEnabled) {
// //         _speak(processedResponse, botMessageId);
// //       }
// //     } catch (e) {
// //       debugPrint('Error in _sendMessage: $e');

// //       // Get error message in correct language
// //       final Map<String, String> errorMessages = {
// //         'English': 'Sorry, I encountered an error. Please try again.',
// //         'Hindi': 'क्षमा करें, मुझे एक त्रुटि मिली। कृपया पुनः प्रयास करें।',
// //         'Punjabi':
// //             'ਮਾਫ਼ ਕਰਨਾ, ਮੈਨੂੰ ਇੱਕ ਗਲਤੀ ਮਿਲੀ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।',
// //         'Bengali':
// //             'দুঃখিত, আমি একটি ত্রুটি পেয়েছি। অনুগ্রহ করে আবার চেষ্টা করুন।',
// //         'Tamil':
// //             'மன்னிக்கவும், எனக்கு ஒரு பிழை ஏற்பட்டது. தயவுசெய்து மீண்டும் முயற்சிக்கவும்.',
// //         'Telugu':
// //             'క్షమించండి, నాకు ఒక లోపం ఎదురైంది. దయచేసి మళ్లీ ప్రయత్నించండి.',
// //         'Marathi': 'क्षमस्व, मला एक त्रुटी आढळली. कृपया पुन्हा प्रयत्न करा.',
// //         'Gujarati': 'માફ કરશો, મને એક ભૂલ મળી. કૃપા કરીને ફરી પ્રયાસ કરો.',
// //       };

// //       final errorMessage =
// //           errorMessages[_selectedLanguage] ?? errorMessages['English']!;
// //       final errorId = 'error-${DateTime.now().millisecondsSinceEpoch}';

// //       setState(() {
// //         _messages.add({
// //           'id': errorId,
// //           'sender': 'bot',
// //           'message': errorMessage,
// //         });
// //         _isLoading = false;
// //       });

// //       // Speak the error message too if auto-speak is enabled
// //       if (_autoSpeakEnabled) {
// //         _speak(errorMessage, errorId);
// //       }
// //     }
// //   }

// //   // Process text to be more speech-friendly
// //   String _processTextForSpeech(String text) {
// //     // Remove or replace symbols that might cause issues in speech
// //     text = text.replaceAll('•', ''); // Remove bullet points
// //     text = text.replaceAll('*', ''); // Remove asterisks
// //     text = text.replaceAll('-', ''); // Remove dashes

// //     // Add pauses for better speech cadence
// //     text = text.replaceAll(
// //       '\n\n',
// //       '. ',
// //     ); // Replace double newlines with period+space
// //     text = text.replaceAll(
// //       '\n',
// //       '. ',
// //     ); // Replace single newlines with period+space

// //     return text;
// //   }

// //   Future<void> _startListening() async {
// //     // Stop any ongoing speech before starting listening
// //     if (_isSpeaking) {
// //       await _flutterTts.stop();
// //       setState(() {
// //         _isSpeaking = false;
// //         _currentlySpeakingMessageId = null;
// //       });
// //     }

// //     if (_isListening) {
// //       await _speech.stop();
// //       setState(() => _isListening = false);
// //       return;
// //     }

// //     try {
// //       setState(() => _isListening = true);
// //       await _speech.listen(
// //         onResult: (result) {
// //           setState(() {
// //             _messageController.text = result.recognizedWords;
// //             if (result.finalResult) {
// //               _isListening = false;
// //               // Auto-send if it's a final result and not empty
// //               if (_messageController.text.isNotEmpty) {
// //                 Future.delayed(const Duration(milliseconds: 500), () {
// //                   _sendMessage(_messageController.text);
// //                 });
// //               }
// //             }
// //           });
// //         },
// //         listenFor: const Duration(seconds: 30),
// //         pauseFor: const Duration(seconds: 3),
// //         localeId:
// //             _languageCode.split('-')[0] +
// //             '_' +
// //             _languageCode.split('-')[1], // Convert from 'en-US' to 'en_US'
// //       );
// //     } catch (e) {
// //       setState(() => _isListening = false);
// //       debugPrint('Error listening: $e');
// //     }
// //   }

// //   Future<void> _speak(String text, String messageId) async {
// //     // Skip speaking if auto-speak is disabled and not manually triggered
// //     if (!_autoSpeakEnabled && messageId != _currentlySpeakingMessageId) return;

// //     if (_isSpeaking) {
// //       if (_currentlySpeakingMessageId == messageId) {
// //         // Stop current speech if tapping the same message
// //         await _flutterTts.stop();
// //         setState(() {
// //           _isSpeaking = false;
// //           _currentlySpeakingMessageId = null;
// //         });
// //       } else {
// //         // Switch to new message if tapping a different one
// //         await _flutterTts.stop();
// //         await Future.delayed(const Duration(milliseconds: 300));

// //         // Make sure language is set correctly before speaking
// //         await _flutterTts.setLanguage(_languageCode);

// //         setState(() {
// //           _currentlySpeakingMessageId = messageId;
// //         });
// //         await _flutterTts.speak(text);
// //       }
// //       return;
// //     }

// //     // Set language before speaking
// //     await _flutterTts.setLanguage(_languageCode);

// //     setState(() {
// //       _isSpeaking = true;
// //       _currentlySpeakingMessageId = messageId;
// //     });
// //     await _flutterTts.speak(text);
// //   }

// //   // Show dialog to change language
// //   void _showLanguageSelector() async {
// //     String? newLanguage = await showDialog<String>(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text('Select Language'),
// //           content: Container(
// //             width: double.maxFinite,
// //             child: ListView.builder(
// //               shrinkWrap: true,
// //               itemCount: _languageCodes.length,
// //               itemBuilder: (context, index) {
// //                 String language = _languageCodes.keys.elementAt(index);
// //                 return ListTile(
// //                   title: Text(language),
// //                   trailing:
// //                       language == _selectedLanguage
// //                           ? Icon(Icons.check, color: Colors.green)
// //                           : null,
// //                   onTap: () {
// //                     Navigator.of(context).pop(language);
// //                   },
// //                 );
// //               },
// //             ),
// //           ),
// //           actions: <Widget>[
// //             TextButton(
// //               child: Text('Cancel'),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );

// //     if (newLanguage != null && newLanguage != _selectedLanguage) {
// //       setState(() {
// //         _selectedLanguage = newLanguage;
// //         _languageCode = _languageCodes[newLanguage] ?? 'en-US';
// //       });

// //       // Save the new language preference
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setString('selectedLanguage', newLanguage);

// //       // Update TTS language
// //       await _flutterTts.setLanguage(_languageCode);

// //       // Add a message about language change
// //       final Map<String, String> languageChangedMessages = {
// //         'English': 'Language changed to English',
// //         'Hindi': 'भाषा हिंदी में बदल दी गई है',
// //         'Punjabi': 'ਭਾਸ਼ਾ ਪੰਜਾਬੀ ਵਿੱਚ ਬਦਲ ਦਿੱਤੀ ਗਈ ਹੈ',
// //         'Bengali': 'ভাষা বাংলায় পরিবর্তন করা হয়েছে',
// //         'Tamil': 'மொழி தமிழாக மாற்றப்பட்டது',
// //         'Telugu': 'భాష తెలుగులోకి మార్చబడింది',
// //         'Marathi': 'भाषा मराठीत बदलली आहे',
// //         'Gujarati': 'ભાષા ગુજરાતીમાં બદલાઈ ગઈ છે',
// //       };

// //       final message =
// //           languageChangedMessages[newLanguage] ??
// //           'Language changed to $newLanguage';
// //       final messageId = 'lang-change-${DateTime.now().millisecondsSinceEpoch}';

// //       setState(() {
// //         _messages.add({'id': messageId, 'sender': 'bot', 'message': message});
// //       });

// //       if (_autoSpeakEnabled) {
// //         _speak(message, messageId);
// //       }
// //     }
// //   }

// //   void _scrollToBottom() {
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       if (_scrollController.hasClients) {
// //         _scrollController.animateTo(
// //           _scrollController.position.maxScrollExtent,
// //           duration: const Duration(milliseconds: 300),
// //           curve: Curves.easeOut,
// //         );
// //       }
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Voice Assistant'),
// //         backgroundColor: Colors.green.shade600,
// //         actions: [
// //           // Language selector button
// //           IconButton(
// //             icon: Icon(Icons.language),
// //             onPressed: _showLanguageSelector,
// //             tooltip: 'Change language',
// //           ),
// //           // Voice toggle button
// //           IconButton(
// //             icon: Icon(_autoSpeakEnabled ? Icons.volume_up : Icons.volume_off),
// //             onPressed: () {
// //               setState(() {
// //                 _autoSpeakEnabled = !_autoSpeakEnabled;
// //                 if (!_autoSpeakEnabled && _isSpeaking) {
// //                   _flutterTts.stop();
// //                   _isSpeaking = false;
// //                   _currentlySpeakingMessageId = null;
// //                 }
// //               });
// //             },
// //             tooltip: _autoSpeakEnabled ? 'Disable voice' : 'Enable voice',
// //           ),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           // Language and voice assistant status
// //           // Voice assistant status indicator
// //           Container(
// //             padding: const EdgeInsets.symmetric(vertical: 8),
// //             color: Colors.green.shade50,
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(Icons.language, color: Colors.green.shade700, size: 18),
// //                 const SizedBox(width: 4),
// //                 Text(
// //                   _selectedLanguage,
// //                   style: TextStyle(
// //                     color: Colors.green.shade700,
// //                     fontWeight: FontWeight.w500,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 16),
// //                 Icon(
// //                   _isSpeaking ? Icons.record_voice_over : Icons.mic,
// //                   color:
// //                       _isSpeaking
// //                           ? Colors.green.shade700
// //                           : Colors.grey.shade600,
// //                   size: 18,
// //                 ),
// //                 const SizedBox(width: 4),
// //                 Text(
// //                   _isSpeaking ? 'Speaking...' : 'Voice Assistant Active',
// //                   style: TextStyle(
// //                     color:
// //                         _isSpeaking
// //                             ? Colors.green.shade700
// //                             : Colors.grey.shade600,
// //                     fontWeight: FontWeight.w500,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),

// //           Expanded(
// //             child: ListView.builder(
// //               controller: _scrollController,
// //               padding: const EdgeInsets.all(16),
// //               itemCount: _messages.length + (_isLoading ? 1 : 0),
// //               itemBuilder: (context, index) {
// //                 if (index == _messages.length) {
// //                   return const Padding(
// //                     padding: EdgeInsets.all(8.0),
// //                     child: Center(
// //                       child: Column(
// //                         children: [
// //                           CircularProgressIndicator(color: Colors.green),
// //                           SizedBox(height: 8),
// //                           Text(
// //                             'Thinking...',
// //                             style: TextStyle(fontStyle: FontStyle.italic),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   );
// //                 }

// //                 final message = _messages[index];
// //                 final isBot = message['sender'] == 'bot';
// //                 final messageId = message['id'] ?? 'msg-$index';
// //                 final isCurrentlySpeaking =
// //                     _currentlySpeakingMessageId == messageId;

// //                 return Align(
// //                   alignment:
// //                       isBot ? Alignment.centerLeft : Alignment.centerRight,
// //                   child: ConstrainedBox(
// //                     constraints: BoxConstraints(
// //                       maxWidth: MediaQuery.of(context).size.width * 0.8,
// //                     ),
// //                     child: Card(
// //                       color: isBot ? Colors.green.shade50 : Colors.blue.shade50,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       margin: const EdgeInsets.symmetric(vertical: 5),
// //                       child: Padding(
// //                         padding: const EdgeInsets.all(12),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               message['message']!,
// //                               style: const TextStyle(fontSize: 16),
// //                             ),
// //                             if (isBot) ...[
// //                               const SizedBox(height: 8),
// //                               GestureDetector(
// //                                 onTap:
// //                                     () => _speak(
// //                                       _processTextForSpeech(
// //                                         message['message']!,
// //                                       ),
// //                                       messageId,
// //                                     ),
// //                                 child: Row(
// //                                   mainAxisSize: MainAxisSize.min,
// //                                   children: [
// //                                     Icon(
// //                                       isCurrentlySpeaking
// //                                           ? Icons.stop
// //                                           : Icons.volume_up,
// //                                       size: 20,
// //                                       color:
// //                                           isCurrentlySpeaking
// //                                               ? Colors.red.shade700
// //                                               : Colors.green.shade700,
// //                                     ),
// //                                     const SizedBox(width: 4),
// //                                     Text(
// //                                       isCurrentlySpeaking ? 'Stop' : 'Listen',
// //                                       style: TextStyle(
// //                                         color:
// //                                             isCurrentlySpeaking
// //                                                 ? Colors.red.shade700
// //                                                 : Colors.green.shade700,
// //                                         fontSize: 12,
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ],
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.grey.withOpacity(0.2),
// //                   spreadRadius: 1,
// //                   blurRadius: 5,
// //                 ),
// //               ],
// //             ),
// //             child: Row(
// //               children: [
// //                 IconButton(
// //                   icon: Icon(
// //                     _isListening ? Icons.mic : Icons.mic_none,
// //                     color: _isListening ? Colors.red : Colors.grey,
// //                   ),
// //                   onPressed: _startListening,
// //                 ),
// //                 Expanded(
// //                   child: TextField(
// //                     controller: _messageController,
// //                     decoration: InputDecoration(
// //                       hintText: 'Type your message...',
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(20),
// //                         borderSide: BorderSide.none,
// //                       ),
// //                       filled: true,
// //                       fillColor: Colors.grey.shade100,
// //                       contentPadding: const EdgeInsets.symmetric(
// //                         horizontal: 16,
// //                         vertical: 8,
// //                       ),
// //                     ),
// //                     textInputAction: TextInputAction.send,
// //                     onSubmitted: (value) => _sendMessage(value),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 4),
// //                 IconButton(
// //                   icon: const Icon(Icons.send),
// //                   color: Colors.green,
// //                   onPressed: () => _sendMessage(_messageController.text),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _messageController.dispose();
// //     _scrollController.dispose();
// //     _flutterTts.stop();
// //     super.dispose();
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:kisaansetu/services/api_service.dart';
// import 'package:kisaansetu/services/conversation_history_service.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ChatbotScreen extends StatefulWidget {
//   const ChatbotScreen({Key? key}) : super(key: key);

//   @override
//   _ChatbotScreenState createState() => _ChatbotScreenState();
// }

// class _ChatbotScreenState extends State<ChatbotScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final ApiService _apiService = ApiService();
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   final FlutterTts _flutterTts = FlutterTts();

//   List<Map<String, String>> _conversationHistory = [];
//   bool _isListening = false;
//   bool _isSpeaking = false;
//   bool _isLoading = false;
//   bool _autoSpeakEnabled = true;
//   String? _currentlySpeakingMessageId;

//   // Language settings
//   String _selectedLanguage = 'English'; // Default
//   String _languageCode = 'en-US'; // Default

//   // Language code mapping
//   final Map<String, String> _languageCodes = {
//     'English': 'en-US',
//     'Hindi': 'hi-IN',
//     'Punjabi': 'pa-IN',
//     'Bengali': 'bn-IN',
//     'Tamil': 'ta-IN',
//     'Telugu': 'te-IN',
//     'Marathi': 'mr-IN',
//     'Gujarati': 'gu-IN',
//   };

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguagePreference();
//     _initializeSpeech();
//     _initializeTts();
//     _loadConversationHistory();
//   }

//   Future<void> _loadLanguagePreference() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final savedLanguage = prefs.getString('selectedLanguage');

//       if (savedLanguage != null) {
//         setState(() {
//           _selectedLanguage = savedLanguage;
//           _languageCode = _languageCodes[savedLanguage] ?? 'en-US';
//         });
//       }
//     } catch (e) {
//       debugPrint('Error loading language preference: $e');
//     }
//   }

//   Future<void> _initializeSpeech() async {
//     try {
//       bool available = await _speech.initialize(
//         onError: (error) => debugPrint('Speech error: $error'),
//         onStatus: (status) => debugPrint('Speech status: $status'),
//       );
//       if (!available) {
//         debugPrint('Speech recognition not available');
//       }
//     } catch (e) {
//       debugPrint('Error initializing speech: $e');
//     }
//   }

//   Future<void> _initializeTts() async {
//     try {
//       await _flutterTts.setLanguage(_languageCode);
//       await _flutterTts.setPitch(1.0);
//       await _flutterTts.setSpeechRate(0.5);

//       _flutterTts.setCompletionHandler(() {
//         setState(() {
//           _isSpeaking = false;
//           _currentlySpeakingMessageId = null;
//         });
//       });

//       _flutterTts.setErrorHandler((error) {
//         debugPrint('TTS error: $error');
//         setState(() {
//           _isSpeaking = false;
//           _currentlySpeakingMessageId = null;
//         });
//       });
//     } catch (e) {
//       debugPrint('Error initializing TTS: $e');
//     }
//   }

//   // Load existing conversation history
//   Future<void> _loadConversationHistory() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final history = await ConversationHistoryService.loadConversation();

//       // If history is empty, add welcome message
//       if (history.isEmpty) {
//         _addWelcomeMessage();
//       } else {
//         setState(() {
//           _conversationHistory = history;
//           _isLoading = false;
//         });
//       }

//       // Scroll to bottom after loading history
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _scrollToBottom();
//       });
//     } catch (e) {
//       debugPrint('Error loading conversation history: $e');
//       setState(() {
//         _isLoading = false;
//       });

//       // Add welcome message if there was an error loading history
//       _addWelcomeMessage();
//     }
//   }

//   void _addWelcomeMessage() {
//     // Multilingual welcome messages
//     final Map<String, String> welcomeMessages = {
//       'English':
//           'Hello! I am KisaanSetu AI Assistant. How can I help you today? I can assist with: Crop recommendations, Weather information, Pest control advice, Government schemes, Market prices, and General farming queries',
//       'Hindi':
//           'नमस्ते! मैं किसानसेतु AI सहायक हूँ। आज मैं आपकी कैसे मदद कर सकता हूँ? मैं इन विषयों पर सहायता कर सकता हूँ: फसल सिफारिशें, मौसम की जानकारी, कीट नियंत्रण सलाह, सरकारी योजनाएँ, बाजार मूल्य, और सामान्य कृषि प्रश्न',
//       'Punjabi':
//           'ਸਤ ਸ੍ਰੀ ਅਕਾਲ! ਮੈਂ ਕਿਸਾਨ ਸੇਤੁ AI ਸਹਾਇਕ ਹਾਂ। ਅੱਜ ਮੈਂ ਤੁਹਾਡੀ ਕਿਵੇਂ ਮਦਦ ਕਰ ਸਕਦਾ ਹਾਂ? ਮੈਂ ਇਹਨਾਂ ਵਿਸ਼ਿਆਂ ਵਿੱਚ ਮਦਦ ਕਰ ਸਕਦਾ ਹਾਂ: ਫਸਲ ਸਿਫਾਰਸ਼ਾਂ, ਮੌਸਮ ਦੀ ਜਾਣਕਾਰੀ, ਕੀੜੇ ਨਿਯੰਤਰਣ ਸਲਾਹ, ਸਰਕਾਰੀ ਯੋਜਨਾਵਾਂ, ਮੰਡੀ ਮੁੱਲ, ਅਤੇ ਆਮ ਖੇਤੀਬਾੜੀ ਸਵਾਲ',
//       'Bengali':
//           'নমস্কার! আমি কিষাণসেতু AI সহকারী। আজ আমি আপনাকে কীভাবে সাহায্য করতে পারি? আমি এই বিষয়গুলিতে সাহায্য করতে পারি: ফসলের সুপারিশ, আবহাওয়া তথ্য, কীটপতঙ্গ নিয়ন্ত্রণ পরামর্শ, সরকারি প্রকল্প, বাজার দাম, এবং সাধারণ কৃষি প্রশ্ন',
//       'Tamil':
//           'வணக்கம்! நான் கிசான்சேது AI உதவியாளர். இன்று நான் உங்களுக்கு எப்படி உதவ முடியும்? நான் இந்த விஷயங்களில் உதவ முடியும்: பயிர் பரிந்துரைகள், வானிலை தகவல், பூச்சி கட்டுப்பாடு ஆலோசனை, அரசு திட்டங்கள், சந்தை விலைகள், மற்றும் பொதுவான விவசாய கேள்விகள்',
//       'Telugu':
//           'నమస్కారం! నేను కిసాన్సేతు AI సహాయకుడిని. నేడు నేను మీకు ఎలా సహాయం చేయగలను? నేను ఈ విషయాలలో సహాయం చేయగలను: పంట సిఫార్సులు, వాతావరణ సమాచారం, పురుగు నియంత్రణ సలహా, ప్రభుత్వ పథకాలు, మార్కెట్ ధరలు, మరియు సాధారణ వ్యవసాయ ప్రశ్నలు',
//       'Marathi':
//           'नमस्कार! मी किसानसेतू AI सहाय्यक आहे. आज मी तुम्हाला कशी मदत करू शकतो? मी या विषयांवर मदत करू शकतो: पीक शिफारशी, हवामान माहिती, कीटक नियंत्रण सल्ला, सरकारी योजना, बाजार किंमती, आणि सामान्य शेती प्रश्न',
//       'Gujarati':
//           'નમસ્તે! હું કિસાનસેતુ AI સહાયક છું. આજે હું તમને કેવી રીતે મદદ કરી શકું? હું આ વિષયોમાં મદદ કરી શકું છું: પાક ભલામણો, હવામાન માહિતી, જંતુ નિયંત્રણ સલાહ, સરકારી યોજનાઓ, બજાર ભાવો, અને સામાન્ય ખેતી પ્રશ્નો',
//     };

//     final welcomeMessage =
//         welcomeMessages[_selectedLanguage] ?? welcomeMessages['English']!;

//     final welcomeEntry = {
//       'id': 'welcome-${DateTime.now().millisecondsSinceEpoch}',
//       'text': welcomeMessage,
//       'isUser': 'false',
//       'timestamp': DateTime.now().toIso8601String(),
//     };

//     setState(() {
//       _conversationHistory.add(welcomeEntry);
//       _isLoading = false;
//     });

//     // Save welcome message to history
//     ConversationHistoryService.saveConversation(_conversationHistory);

//     // Automatically speak the welcome message after a short delay
//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (_autoSpeakEnabled) {
//         _speak(welcomeMessage, welcomeEntry['id']!);
//       }
//     });
//   }

//   // Scroll to bottom of chat
//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   // Process text to be more speech-friendly
//   String _processTextForSpeech(String text) {
//     // Remove or replace symbols that might cause issues in speech
//     text = text.replaceAll('•', ''); // Remove bullet points
//     text = text.replaceAll('*', ''); // Remove asterisks
//     text = text.replaceAll('-', ''); // Remove dashes

//     // Add pauses for better speech cadence
//     text = text.replaceAll(
//       '\n\n',
//       '. ',
//     ); // Replace double newlines with period+space
//     text = text.replaceAll(
//       '\n',
//       '. ',
//     ); // Replace single newlines with period+space

//     return text;
//   }

//   // Send message to chatbot and handle response
//   Future<void> _sendMessage(String message) async {
//     if (message.trim().isEmpty) return;

//     // Create user message entry
//     final userMessage = {
//       'id': 'user-${DateTime.now().millisecondsSinceEpoch}',
//       'text': message,
//       'isUser': 'true',
//       'timestamp': DateTime.now().toIso8601String(),
//     };

//     // Clear text input
//     _messageController.clear();

//     // Update UI immediately with user message
//     setState(() {
//       _conversationHistory.add(userMessage);
//       _isLoading = true;
//     });

//     // Save conversation with new user message
//     await ConversationHistoryService.saveConversation(_conversationHistory);

//     // Scroll to show the new message
//     _scrollToBottom();

//     try {
//       // Stop any ongoing speech
//       if (_isSpeaking) {
//         await _flutterTts.stop();
//         setState(() {
//           _isSpeaking = false;
//           _currentlySpeakingMessageId = null;
//         });
//       }

//       // Get current location if permission is granted
//       Position? currentPosition;
//       try {
//         bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//         if (serviceEnabled) {
//           LocationPermission permission = await Geolocator.checkPermission();

//           if (permission == LocationPermission.whileInUse ||
//               permission == LocationPermission.always) {
//             currentPosition = await Geolocator.getCurrentPosition(
//               desiredAccuracy: LocationAccuracy.high,
//             );
//           }
//         }
//       } catch (e) {
//         debugPrint('Error getting location: $e');
//         // Continue without location if there's an error
//       }

//       // Get weather data if location is available
//       Map<String, dynamic>? weatherData;
//       if (currentPosition != null) {
//         try {
//           weatherData = await _apiService.getCurrentWeather(
//             latitude: currentPosition.latitude,
//             longitude: currentPosition.longitude,
//           );
//         } catch (e) {
//           debugPrint('Error getting weather data: $e');
//           // Continue without weather if there's an error
//         }
//       }

//       // Get bot response
//       final response = await _apiService.getChatbotResponse(
//         message,
//         language: _selectedLanguage.toLowerCase(),
//         conversationHistory: _conversationHistory,
//         latitude: currentPosition?.latitude,
//         longitude: currentPosition?.longitude,
//         weatherData: weatherData,
//       );

//       final botMessageId = 'bot-${DateTime.now().millisecondsSinceEpoch}';

//       // Create bot response entry
//       final botMessage = {
//         'id': botMessageId,
//         'text': response,
//         'isUser': 'false',
//         'timestamp': DateTime.now().toIso8601String(),
//       };

//       setState(() {
//         _conversationHistory.add(botMessage);
//         _isLoading = false;
//       });

//       // Save conversation with bot response
//       await ConversationHistoryService.saveConversation(_conversationHistory);

//       // Scroll to show the new message
//       _scrollToBottom();

//       // Automatically speak the bot's response if auto-speak is enabled
//       if (_autoSpeakEnabled) {
//         _speak(_processTextForSpeech(response), botMessageId);
//       }
//     } catch (e) {
//       debugPrint('Error sending message: $e');

//       // Get error message in correct language
//       final Map<String, String> errorMessages = {
//         'English': 'Sorry, I encountered an error. Please try again.',
//         'Hindi': 'क्षमा करें, मुझे एक त्रुटि मिली। कृपया पुनः प्रयास करें।',
//         'Punjabi':
//             'ਮਾਫ਼ ਕਰਨਾ, ਮੈਨੂੰ ਇੱਕ ਗਲਤੀ ਮਿਲੀ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।',
//         'Bengali':
//             'দুঃখিত, আমি একটি ত্রুটি পেয়েছি। অনুগ্রহ করে আবার চেষ্টা করুন।',
//         'Tamil':
//             'மன்னிக்கவும், எனக்கு ஒரு பிழை ஏற்பட்டது. தயவுசெய்து மீண்டும் முயற்சிக்கவும்.',
//         'Telugu':
//             'క్షమించండి, నాకు ఒక లోపం ఎదురైంది. దయచేసి మళ్లీ ప్రయత్నించండి.',
//         'Marathi': 'क्षमस्व, मला एक त्रुटी आढळली. कृपया पुन्हा प्रयत्न करा.',
//         'Gujarati': 'માફ કરશો, મને એક ભૂલ મળી. કૃપા કરીને ફરી પ્રયાસ કરો.',
//       };

//       final errorMessage =
//           errorMessages[_selectedLanguage] ?? errorMessages['English']!;
//       final errorId = 'error-${DateTime.now().millisecondsSinceEpoch}';

//       // Create error message entry
//       final errorEntry = {
//         'id': errorId,
//         'text': errorMessage,
//         'isUser': 'false',
//         'timestamp': DateTime.now().toIso8601String(),
//       };

//       setState(() {
//         _conversationHistory.add(errorEntry);
//         _isLoading = false;
//       });

//       // Save conversation with error message
//       await ConversationHistoryService.saveConversation(_conversationHistory);

//       // Speak the error message too if auto-speak is enabled
//       if (_autoSpeakEnabled) {
//         _speak(errorMessage, errorId);
//       }
//     }
//   }
//   Future<void> _startListening() async {
//     // Stop any ongoing speech before starting listening
//     if (_isSpeaking) {
//       await _flutterTts.stop();
//       setState(() {
//         _isSpeaking = false;
//         _currentlySpeakingMessageId = null;
//       });
//     }

//     if (_isListening) {
//       await _speech.stop();
//       setState(() => _isListening = false);
//       return;
//     }

//     try {
//       setState(() => _isListening = true);
//       await _speech.listen(
//         onResult: (result) {
//           setState(() {
//             _messageController.text = result.recognizedWords;
//             if (result.finalResult) {
//               _isListening = false;
//               // Auto-send if it's a final result and not empty
//               if (_messageController.text.isNotEmpty) {
//                 Future.delayed(const Duration(milliseconds: 500), () {
//                   _sendMessage(_messageController.text);
//                 });
//               }
//             }
//           });
//         },
//         listenFor: const Duration(seconds: 30),
//         pauseFor: const Duration(seconds: 3),
//         localeId:
//             '${_languageCode.split('-')[0]}_${_languageCode.split('-')[1]}', // Convert from 'en-US' to 'en_US'
//       );
//     } catch (e) {
//       setState(() => _isListening = false);
//       debugPrint('Error listening: $e');
//     }
//   }

//   Future<void> _speak(String text, String messageId) async {
//     // Skip speaking if auto-speak is disabled and not manually triggered
//     if (!_autoSpeakEnabled && messageId != _currentlySpeakingMessageId) return;

//     if (_isSpeaking) {
//       if (_currentlySpeakingMessageId == messageId) {
//         // Stop current speech if tapping the same message
//         await _flutterTts.stop();
//         setState(() {
//           _isSpeaking = false;
//           _currentlySpeakingMessageId = null;
//         });
//       } else {
//         // Switch to new message if tapping a different one
//         await _flutterTts.stop();
//         await Future.delayed(const Duration(milliseconds: 300));

//         // Make sure language is set correctly before speaking
//         await _flutterTts.setLanguage(_languageCode);

//         setState(() {
//           _currentlySpeakingMessageId = messageId;
//         });
//         await _flutterTts.speak(text);
//       }
//       return;
//     }

//     // Set language before speaking
//     await _flutterTts.setLanguage(_languageCode);

//     setState(() {
//       _isSpeaking = true;
//       _currentlySpeakingMessageId = messageId;
//     });
//     await _flutterTts.speak(text);
//   }

//   // Clear chat history
//   Future<void> _clearHistory() async {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: Text('Clear Chat History'),
//             content: Text('Are you sure you want to clear all chat history?'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   await ConversationHistoryService.clearConversation();
//                   setState(() {
//                     _conversationHistory = [];
//                   });
//                   // Add welcome message after clearing
//                   _addWelcomeMessage();
//                 },
//                 child: Text('Clear'),
//               ),
//             ],
//           ),
//     );
//   }

//   // Show dialog to change language
//   void _showLanguageSelector() async {
//     String? newLanguage = await showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Select Language'),
//           content: SizedBox(
//             width: double.maxFinite,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: _languageCodes.length,
//               itemBuilder: (context, index) {
//                 String language = _languageCodes.keys.elementAt(index);
//                 return ListTile(
//                   title: Text(language),
//                   trailing:
//                       language == _selectedLanguage
//                           ? Icon(Icons.check, color: Colors.green)
//                           : null,
//                   onTap: () {
//                     Navigator.of(context).pop(language);
//                   },
//                 );
//               },
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );

//     if (newLanguage != null && newLanguage != _selectedLanguage) {
//       setState(() {
//         _selectedLanguage = newLanguage;
//         _languageCode = _languageCodes[newLanguage] ?? 'en-US';
//       });

//       // Save the new language preference
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('selectedLanguage', newLanguage);

//       // Update TTS language
//       await _flutterTts.setLanguage(_languageCode);

//       // Add a message about language change
//       final Map<String, String> languageChangedMessages = {
//         'English': 'Language changed to English',
//         'Hindi': 'भाषा हिंदी में बदल दी गई है',
//         'Punjabi': 'ਭਾਸ਼ਾ ਪੰਜਾਬੀ ਵਿੱਚ ਬਦਲ ਦਿੱਤੀ ਗਈ ਹੈ',
//         'Bengali': 'ভাষা বাংলায় পরিবর্তন করা হয়েছে',
//         'Tamil': 'மொழி தமிழாக மாற்றப்பட்டது',
//         'Telugu': 'భాష తెలుగులోకి మార్చబడింది',
//         'Marathi': 'भाषा मराठीत बदलली आहे',
//         'Gujarati': 'ભાષા ગુજરાતીમાં બદલાઈ ગઈ છે',
//       };

//       final message =
//           languageChangedMessages[newLanguage] ??
//           'Language changed to $newLanguage';
//       final messageId = 'lang-change-${DateTime.now().millisecondsSinceEpoch}';

//       final languageChangeEntry = {
//         'id': messageId,
//         'text': message,
//         'isUser': 'false',
//         'timestamp': DateTime.now().toIso8601String(),
//       };

//       setState(() {
//         _conversationHistory.add(languageChangeEntry);
//       });

//       // Don't save language change message to history

//       if (_autoSpeakEnabled) {
//         _speak(message, messageId);
//       }
//     }
//   }

//   // Format timestamp for display
//   String _formatTimestamp(String timestamp) {
//     try {
//       final dateTime = DateTime.parse(timestamp);
//       final now = DateTime.now();
//       final today = DateTime(now.year, now.month, now.day);
//       final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

//       if (messageDate == today) {
//         // Today - show only time
//         return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
//       } else {
//         // Other day - show date and time
//         return '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
//       }
//     } catch (e) {
//       return '';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('KisaanSetu Assistant'),
//         backgroundColor: Colors.green.shade600,
//         actions: [
//           // Language selector
//           IconButton(
//             icon: Icon(Icons.language),
//             onPressed: _showLanguageSelector,
//             tooltip: 'Change language',
//           ),
//           // Voice toggle button
//           IconButton(
//             icon: Icon(_autoSpeakEnabled ? Icons.volume_up : Icons.volume_off),
//             onPressed: () {
//               setState(() {
//                 _autoSpeakEnabled = !_autoSpeakEnabled;
//                 if (!_autoSpeakEnabled && _isSpeaking) {
//                   _flutterTts.stop();
//                   _isSpeaking = false;
//                   _currentlySpeakingMessageId = null;
//                 }
//               });
//             },
//             tooltip: _autoSpeakEnabled ? 'Disable voice' : 'Enable voice',
//           ),
//           // Clear history button
//           IconButton(
//             icon: Icon(Icons.delete_outline),
//             onPressed: _clearHistory,
//             tooltip: 'Clear Chat History',
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Language and voice assistant status indicator
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             color: Colors.green.shade50,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.language, color: Colors.green.shade700, size: 18),
//                 const SizedBox(width: 4),
//                 Text(
//                   _selectedLanguage,
//                   style: TextStyle(
//                     color: Colors.green.shade700,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Icon(
//                   _isSpeaking
//                       ? Icons.record_voice_over
//                       : (_isListening ? Icons.mic : Icons.mic_none),
//                   color:
//                       _isSpeaking || _isListening
//                           ? Colors.green.shade700
//                           : Colors.grey.shade600,
//                   size: 18,
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   _isSpeaking
//                       ? 'Speaking...'
//                       : (_isListening
//                           ? 'Listening...'
//                           : 'Voice Assistant Active'),
//                   style: TextStyle(
//                     color:
//                         _isSpeaking || _isListening
//                             ? Colors.green.shade700
//                             : Colors.grey.shade600,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Chat messages list
//           Expanded(
//             child:
//                 _isLoading && _conversationHistory.isEmpty
//                     ? Center(
//                       child: CircularProgressIndicator(color: Colors.green),
//                     )
//                     : ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.all(16),
//                       itemCount:
//                           _conversationHistory.length + (_isLoading ? 1 : 0),
//                       itemBuilder: (context, index) {
//                         if (index == _conversationHistory.length) {
//                           return const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Center(
//                               child: Column(
//                                 children: [
//                                   CircularProgressIndicator(
//                                     color: Colors.green,
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     'Thinking...',
//                                     style: TextStyle(
//                                       fontStyle: FontStyle.italic,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }

//                         final message = _conversationHistory[index];
//                         final isUser = message['isUser'] == 'true';
//                         final messageId = message['id'] ?? 'msg-$index';
//                         final isSystemMessage =
//                             messageId.startsWith('lang-change-') ||
//                             messageId.startsWith('welcome');
//                         final isCurrentlySpeaking =
//                             messageId == _currentlySpeakingMessageId;

//                         // Format timestamp
//                         final timestamp =
//                             message['timestamp'] != null
//                                 ? _formatTimestamp(message['timestamp']!)
//                                 : '';

//                         if (isSystemMessage) {
//                           // System message style (language change, welcome)
//                           return Container(
//                             margin: const EdgeInsets.symmetric(vertical: 8),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 12,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.green.shade50,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(color: Colors.green.shade200),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   message['text'] ?? '',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.green.shade800,
//                                   ),
//                                 ),
//                                 if (timestamp.isNotEmpty)
//                                   Align(
//                                     alignment: Alignment.bottomRight,
//                                     child: Text(
//                                       timestamp,
//                                       style: TextStyle(
//                                         fontSize: 10,
//                                         color: Colors.grey.shade600,
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           );
//                         }

//                         // Regular user or bot message
//                         return GestureDetector(
//                           onTap:
//                               isUser
//                                   ? null
//                                   : () => _speak(
//                                     _processTextForSpeech(
//                                       message['text'] ?? '',
//                                     ),
//                                     messageId,
//                                   ),
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 8),
//                             child: Row(
//                               mainAxisAlignment:
//                                   isUser
//                                       ? MainAxisAlignment.end
//                                       : MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 if (!isUser)
//                                   CircleAvatar(
//                                     backgroundColor: Colors.green.shade100,
//                                     child: Icon(
//                                       Icons.agriculture,
//                                       color: Colors.green.shade700,
//                                       size: 20,
//                                     ),
//                                   ),
//                                 const SizedBox(width: 8),
//                                 Flexible(
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 16,
//                                       vertical: 12,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color:
//                                           isUser
//                                               ? Colors.green.shade100
//                                               : Colors.white,
//                                       borderRadius: BorderRadius.circular(16),
//                                       border: Border.all(
//                                         color:
//                                             isUser
//                                                 ? Colors.green.shade200
//                                                 : Colors.grey.shade300,
//                                       ),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black.withOpacity(0.05),
//                                           blurRadius: 5,
//                                           offset: const Offset(0, 2),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           message['text'] ?? '',
//                                           style: TextStyle(
//                                             fontSize: 15,
//                                             color: Colors.black87,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.end,
//                                           children: [
//                                             if (!isUser && isCurrentlySpeaking)
//                                               Row(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   Icon(
//                                                     Icons.volume_up,
//                                                     size: 14,
//                                                     color:
//                                                         Colors.green.shade700,
//                                                   ),
//                                                   const SizedBox(width: 4),
//                                                   Text(
//                                                     'Speaking',
//                                                     style: TextStyle(
//                                                       fontSize: 10,
//                                                       color:
//                                                           Colors.green.shade700,
//                                                       fontStyle:
//                                                           FontStyle.italic,
//                                                     ),
//                                                   ),
//                                                   const SizedBox(width: 8),
//                                                 ],
//                                               ),
//                                             Text(
//                                               timestamp,
//                                               style: TextStyle(
//                                                 fontSize: 10,
//                                                 color: Colors.grey.shade600,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 if (isUser)
//                                   CircleAvatar(
//                                     backgroundColor: Colors.green.shade600,
//                                     child: const Icon(
//                                       Icons.person,
//                                       color: Colors.white,
//                                       size: 20,
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//           ),

//           // Loading indicator at the bottom of the chat
//           if (_isLoading && _conversationHistory.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: 16,
//                     height: 16,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: Colors.green.shade600,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Thinking...',
//                     style: TextStyle(
//                       fontStyle: FontStyle.italic,
//                       color: Colors.green.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//           // Input area
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   offset: const Offset(0, -2),
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 5,
//                 ),
//               ],
//             ),
//             child: SafeArea(
//               child: Row(
//                 children: [
//                   // Voice input button
//                   IconButton(
//                     onPressed: _startListening,
//                     icon: Icon(
//                       _isListening ? Icons.mic : Icons.mic_none,
//                       color: _isListening ? Colors.red : Colors.green.shade600,
//                     ),
//                     tooltip:
//                         _isListening ? 'Stop listening' : 'Start voice input',
//                   ),
//                   // Text input field
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       decoration: InputDecoration(
//                         hintText: 'Type your message...',
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: BorderSide(color: Colors.grey.shade300),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: BorderSide(color: Colors.grey.shade300),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: BorderSide(
//                             color: Colors.green.shade600,
//                             width: 1.5,
//                           ),
//                         ),
//                         fillColor: Colors.grey.shade50,
//                         filled: true,
//                       ),
//                       keyboardType: TextInputType.multiline,
//                       minLines: 1,
//                       maxLines: 3,
//                       onSubmitted: (value) {
//                         if (value.trim().isNotEmpty) {
//                           _sendMessage(value);
//                         }
//                       },
//                     ),
//                   ),
//                   // Send button
//                   IconButton(
//                     onPressed: () {
//                       if (_messageController.text.trim().isNotEmpty) {
//                         _sendMessage(_messageController.text);
//                       }
//                     },
//                     icon: Icon(Icons.send, color: Colors.green.shade600),
//                     tooltip: 'Send message',
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     _speech.cancel();
//     _flutterTts.stop();
//     super.dispose();
//   }
// }


import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kisaansetu/services/api_service.dart';
import 'package:kisaansetu/services/conversation_history_service.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  List<Map<String, String>> _conversationHistory = [];
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _isLoading = false;
  bool _autoSpeakEnabled = true;
  String? _currentlySpeakingMessageId;

  // Language settings
  String _selectedLanguage = 'English';
  String _languageCode = 'en-US';

  // Language code mapping
  final Map<String, String> _languageCodes = {
    'English': 'en-US',
    'Hindi': 'hi-IN',
    'Punjabi': 'pa-IN',
    'Bengali': 'bn-IN',
    'Tamil': 'ta-IN',
    'Telugu': 'te-IN',
    'Marathi': 'mr-IN',
    'Gujarati': 'gu-IN',
  };

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference().then((_) {
      _initializeSpeech();
      _initializeTts();
      _loadConversationHistory();
    });
  }

  Future<void> _loadLanguagePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('selectedLanguage') ?? 'English';
      
      setState(() {
        _selectedLanguage = savedLanguage;
        _languageCode = _languageCodes[savedLanguage] ?? 'en-US';
      });
    } catch (e) {
      debugPrint('Error loading language preference: $e');
      setState(() {
        _selectedLanguage = 'English';
        _languageCode = 'en-US';
      });
    }
  }

  Future<void> _initializeSpeech() async {
    try {
      bool available = await _speech.initialize(
        onError: (error) => debugPrint('Speech error: $error'),
        onStatus: (status) => debugPrint('Speech status: $status'),
      );
      if (!available) {
        debugPrint('Speech recognition not available');
      }
    } catch (e) {
      debugPrint('Error initializing speech: $e');
    }
  }

  Future<void> _initializeTts() async {
    try {
      await _flutterTts.setLanguage(_languageCode);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5);

      _flutterTts.setCompletionHandler(() {
        setState(() {
          _isSpeaking = false;
          _currentlySpeakingMessageId = null;
        });
      });

      _flutterTts.setErrorHandler((error) {
        debugPrint('TTS error: $error');
        setState(() {
          _isSpeaking = false;
          _currentlySpeakingMessageId = null;
        });
      });
    } catch (e) {
      debugPrint('Error initializing TTS: $e');
    }
  }

  Future<void> _loadConversationHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final history = await ConversationHistoryService.loadConversation();

      if (history.isEmpty) {
        _addWelcomeMessage();
      } else {
        setState(() {
          _conversationHistory = history;
          _isLoading = false;
        });
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      debugPrint('Error loading conversation history: $e');
      setState(() {
        _isLoading = false;
      });
      _addWelcomeMessage();
    }
  }

  void _addWelcomeMessage() {
    final Map<String, String> welcomeMessages = {
      'English':
          'Hello! I am KisaanSetu AI Assistant. How can I help you today? I can assist with: Crop recommendations, Weather information, Pest control advice, Government schemes, Market prices, and General farming queries',
      'Hindi':
          'नमस्ते! मैं किसानसेतु AI सहायक हूँ। आज मैं आपकी कैसे मदद कर सकता हूँ? मैं इन विषयों पर सहायता कर सकता हूँ: फसल सिफारिशें, मौसम की जानकारी, कीट नियंत्रण सलाह, सरकारी योजनाएँ, बाजार मूल्य, और सामान्य कृषि प्रश्न',
      'Punjabi':
          'ਸਤ ਸ੍ਰੀ ਅਕਾਲ! ਮੈਂ ਕਿਸਾਨ ਸੇਤੁ AI ਸਹਾਇਕ ਹਾਂ। ਅੱਜ ਮੈਂ ਤੁਹਾਡੀ ਕਿਵੇਂ ਮਦਦ ਕਰ ਸਕਦਾ ਹਾਂ? ਮੈਂ ਇਹਨਾਂ ਵਿਸ਼ਿਆਂ ਵਿੱਚ ਮਦਦ ਕਰ ਸਕਦਾ ਹਾਂ: ਫਸਲ ਸਿਫਾਰਸ਼ਾਂ, ਮੌਸਮ ਦੀ ਜਾਣਕਾਰੀ, ਕੀੜੇ ਨਿਯੰਤਰਣ ਸਲਾਹ, ਸਰਕਾਰੀ ਯੋਜਨਾਵਾਂ, ਮੰਡੀ ਮੁੱਲ, ਅਤੇ ਆਮ ਖੇਤੀਬਾੜੀ ਸਵਾਲ',
      'Bengali':
          'নমস্কার! আমি কিষাণসেতু AI সহকারী। আজ আমি আপনাকে কীভাবে সাহায্য করতে পারি? আমি এই বিষয়গুলিতে সাহায্য করতে পারি: ফসলের সুপারিশ, আবহাওয়া তথ্য, কীটপতঙ্গ নিয়ন্ত্রণ পরামর্শ, সরকারি প্রকল্প, বাজার দাম, এবং সাধারণ কৃষি প্রশ্ন',
      'Tamil':
          'வணக்கம்! நான் கிசான்சேது AI உதவியாளர். இன்று நான் உங்களுக்கு எப்படி உதவ முடியும்? நான் இந்த விஷயங்களில் உதவ முடியும்: பயிர் பரிந்துரைகள், வானிலை தகவல், பூச்சி கட்டுப்பாடு ஆலோசனை, அரசு திட்டங்கள், சந்தை விலைகள், மற்றும் பொதுவான விவசாய கேள்விகள்',
      'Telugu':
          'నమస్కారం! నేను కిసాన్సేతు AI సహాయకుడిని. నేడు నేను మీకు ఎలా సహాయం చేయగలను? నేను ఈ విషయాలలో సహాయం చేయగలను: పంట సిఫార్సులు, వాతావరణ సమాచారం, పురుగు నియంత్రణ సలహా, ప్రభుత్వ పథకాలు, మార్కెట్ ధరలు, మరియు సాధారణ వ్యవసాయ ప్రశ్నలు',
      'Marathi':
          'नमस्कार! मी किसानसेतू AI सहाय्यक आहे. आज मी तुम्हाला कशी मदत करू शकतो? मी या विषयांवर मदत करू शकतो: पीक शिफारशी, हवामान माहिती, कीटक नियंत्रण सल्ला, सरकारी योजना, बाजार किंमती, आणि सामान्य शेती प्रश्न',
      'Gujarati':
          'નમસ્તે! હું કિસાનસેતુ AI સહાયક છું. આજે હું તમને કેવી રીતે મદદ કરી શકું? હું આ વિષયોમાં મદદ કરી શકું છું: પાક ભલામણો, હવામાન માહિતી, જંતુ નિયંત્રણ સલાહ, સરકારી યોજનાઓ, બજાર ભાવો, અને સામાન્ય ખેતી પ્રશ્નો',
    };

    final welcomeMessage = welcomeMessages[_selectedLanguage] ?? welcomeMessages['English']!;

    final welcomeEntry = {
      'id': 'welcome-${DateTime.now().millisecondsSinceEpoch}',
      'text': welcomeMessage,
      'isUser': 'false',
      'timestamp': DateTime.now().toIso8601String(),
    };

    setState(() {
      _conversationHistory.add(welcomeEntry);
      _isLoading = false;
    });

    ConversationHistoryService.saveConversation(_conversationHistory);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (_autoSpeakEnabled) {
        _speak(welcomeMessage, welcomeEntry['id']!);
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _processTextForSpeech(String text) {
    text = text.replaceAll('•', '');
    text = text.replaceAll('*', '');
    text = text.replaceAll('-', '');
    text = text.replaceAll('\n\n', '. ');
    text = text.replaceAll('\n', '. ');
    return text;
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final userMessage = {
      'id': 'user-${DateTime.now().millisecondsSinceEpoch}',
      'text': message,
      'isUser': 'true',
      'timestamp': DateTime.now().toIso8601String(),
    };

    _messageController.clear();

    setState(() {
      _conversationHistory.add(userMessage);
      _isLoading = true;
    });

    await ConversationHistoryService.saveConversation(_conversationHistory);
    _scrollToBottom();

    try {
      if (_isSpeaking) {
        await _flutterTts.stop();
        setState(() {
          _isSpeaking = false;
          _currentlySpeakingMessageId = null;
        });
      }

      Position? currentPosition;
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always) {
            currentPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            );
          }
        }
      } catch (e) {
        debugPrint('Error getting location: $e');
      }

      Map<String, dynamic>? weatherData;
      if (currentPosition != null) {
        try {
          weatherData = await _apiService.getCurrentWeather(
            latitude: currentPosition.latitude,
            longitude: currentPosition.longitude,
          );
        } catch (e) {
          debugPrint('Error getting weather data: $e');
        }
      }

      final response = await _apiService.getChatbotResponse(
        message,
        language: _selectedLanguage.toLowerCase(),
        conversationHistory: _conversationHistory,
        latitude: currentPosition?.latitude,
        longitude: currentPosition?.longitude,
        weatherData: weatherData,
      );

      final botMessageId = 'bot-${DateTime.now().millisecondsSinceEpoch}';
      final botMessage = {
        'id': botMessageId,
        'text': response,
        'isUser': 'false',
        'timestamp': DateTime.now().toIso8601String(),
      };

      setState(() {
        _conversationHistory.add(botMessage);
        _isLoading = false;
      });

      await ConversationHistoryService.saveConversation(_conversationHistory);
      _scrollToBottom();

      if (_autoSpeakEnabled) {
        _speak(_processTextForSpeech(response), botMessageId);
      }
    } catch (e) {
      debugPrint('Error sending message: $e');

      final Map<String, String> errorMessages = {
        'English': 'Sorry, I encountered an error. Please try again.',
        'Hindi': 'क्षमा करें, मुझे एक त्रुटि मिली। कृपया पुनः प्रयास करें।',
        'Punjabi': 'ਮਾਫ਼ ਕਰਨਾ, ਮੈਨੂੰ ਇੱਕ ਗਲਤੀ ਮਿਲੀ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।',
        'Bengali': 'দুঃখিত, আমি একটি ত্রুটি পেয়েছি। অনুগ্রহ করে আবার চেষ্টা করুন।',
        'Tamil': 'மன்னிக்கவும், எனக்கு ஒரு பிழை ஏற்பட்டது. தயவுசெய்து மீண்டும் முயற்சிக்கவும்.',
        'Telugu': 'క్షమించండి, నాకు ఒక లోపం ఎదురైంది. దయచేసి మళ్లీ ప్రయత్నించండి.',
        'Marathi': 'क्षमस्व, मला एक त्रुटी आढळली. कृपया पुन्हा प्रयत्न करा.',
        'Gujarati': 'માફ કરશો, મને એક ભૂલ મળી. કૃપા કરીને ફરી પ્રયાસ કરો.',
      };

      final errorMessage = errorMessages[_selectedLanguage] ?? errorMessages['English']!;
      final errorId = 'error-${DateTime.now().millisecondsSinceEpoch}';

      final errorEntry = {
        'id': errorId,
        'text': errorMessage,
        'isUser': 'false',
        'timestamp': DateTime.now().toIso8601String(),
      };

      setState(() {
        _conversationHistory.add(errorEntry);
        _isLoading = false;
      });

      await ConversationHistoryService.saveConversation(_conversationHistory);

      if (_autoSpeakEnabled) {
        _speak(errorMessage, errorId);
      }
    }
  }

  Future<void> _startListening() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
        _currentlySpeakingMessageId = null;
      });
    }

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      return;
    }

    try {
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _messageController.text = result.recognizedWords;
            if (result.finalResult) {
              _isListening = false;
              if (_messageController.text.isNotEmpty) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  _sendMessage(_messageController.text);
                });
              }
            }
          });
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        localeId: '${_languageCode.split('-')[0]}_${_languageCode.split('-')[1]}',
      );
    } catch (e) {
      setState(() => _isListening = false);
      debugPrint('Error listening: $e');
    }
  }

  Future<void> _speak(String text, String messageId) async {
    if (!_autoSpeakEnabled && messageId != _currentlySpeakingMessageId) return;

    if (_isSpeaking) {
      if (_currentlySpeakingMessageId == messageId) {
        await _flutterTts.stop();
        setState(() {
          _isSpeaking = false;
          _currentlySpeakingMessageId = null;
        });
      } else {
        await _flutterTts.stop();
        await Future.delayed(const Duration(milliseconds: 300));
        await _flutterTts.setLanguage(_languageCode);
        setState(() {
          _currentlySpeakingMessageId = messageId;
        });
        await _flutterTts.speak(text);
      }
      return;
    }

    await _flutterTts.setLanguage(_languageCode);
    setState(() {
      _isSpeaking = true;
      _currentlySpeakingMessageId = messageId;
    });
    await _flutterTts.speak(text);
  }

  Future<void> _clearHistory() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Clear Chat History',
          style: TextStyle(color: Colors.green.shade800),
        ),
        content: Text('Are you sure you want to clear all chat history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ConversationHistoryService.clearConversation();
              setState(() {
                _conversationHistory = [];
              });
              _addWelcomeMessage();
            },
            child: Text('Clear', style: TextStyle(color: Colors.red.shade700)),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector() async {
    String? newLanguage = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Language',
            style: TextStyle(color: Colors.green.shade800),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _languageCodes.length,
              itemBuilder: (context, index) {
                String language = _languageCodes.keys.elementAt(index);
                return ListTile(
                  title: Text(language),
                  trailing: language == _selectedLanguage
                      ? Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    Navigator.of(context).pop(language);
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    if (newLanguage != null && newLanguage != _selectedLanguage) {
      setState(() {
        _selectedLanguage = newLanguage;
        _languageCode = _languageCodes[newLanguage] ?? 'en-US';
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedLanguage', newLanguage);
      await _flutterTts.setLanguage(_languageCode);

      final Map<String, String> languageChangedMessages = {
        'English': 'Language changed to English',
        'Hindi': 'भाषा हिंदी में बदल दी गई है',
        'Punjabi': 'ਭਾਸ਼ਾ ਪੰਜਾਬੀ ਵਿੱਚ ਬਦਲ ਦਿੱਤੀ ਗਈ ਹੈ',
        'Bengali': 'ভাষা বাংলায় পরিবর্তন করা হয়েছে',
        'Tamil': 'மொழி தமிழாக மாற்றப்பட்டது',
        'Telugu': 'భాష తెలుగులోకి మార్చబడింది',
        'Marathi': 'भाषा मराठीत बदलली आहे',
        'Gujarati': 'ભાષા ગુજરાતીમાં બદલાઈ ગઈ છે',
      };

      final message = languageChangedMessages[newLanguage] ?? 'Language changed to $newLanguage';
      final messageId = 'lang-change-${DateTime.now().millisecondsSinceEpoch}';

      final languageChangeEntry = {
        'id': messageId,
        'text': message,
        'isUser': 'false',
        'timestamp': DateTime.now().toIso8601String(),
      };

      setState(() {
        _conversationHistory.add(languageChangeEntry);
      });

      if (_autoSpeakEnabled) {
        _speak(message, messageId);
      }
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (messageDate == today) {
        return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else {
        return '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Image.asset('assets/logo.jpg', height: 30),
            SizedBox(width: 10),
            Text(
              'KisaanSetu Assistant',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.language, color: Colors.white),
            onPressed: _showLanguageSelector,
            tooltip: 'Change language',
          ),
          IconButton(
            icon: Icon(
              _autoSpeakEnabled ? Icons.volume_up : Icons.volume_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _autoSpeakEnabled = !_autoSpeakEnabled;
                if (!_autoSpeakEnabled && _isSpeaking) {
                  _flutterTts.stop();
                  _isSpeaking = false;
                  _currentlySpeakingMessageId = null;
                }
              });
            },
            tooltip: _autoSpeakEnabled ? 'Disable voice' : 'Enable voice',
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.white),
            onPressed: _clearHistory,
            tooltip: 'Clear Chat History',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50,
              Colors.green.shade100,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.language, color: Colors.green.shade800, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    _selectedLanguage,
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    _isSpeaking
                        ? Icons.record_voice_over
                        : (_isListening ? Icons.mic : Icons.mic_none),
                    color: _isSpeaking || _isListening
                        ? Colors.green.shade800
                        : Colors.grey.shade600,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isSpeaking
                        ? 'Speaking...'
                        : (_isListening
                            ? 'Listening...'
                            : 'Voice Assistant'),
                    style: TextStyle(
                      color: _isSpeaking || _isListening
                          ? Colors.green.shade800
                          : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading && _conversationHistory.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.green),
                          SizedBox(height: 16),
                          Text(
                            'Loading your farming assistant...',
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _conversationHistory.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _conversationHistory.length) {
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(color: Colors.green),
                                  SizedBox(height: 8),
                                  Text(
                                    'Thinking...',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final message = _conversationHistory[index];
                        final isUser = message['isUser'] == 'true';
                        final messageId = message['id'] ?? 'msg-$index';
                        final isSystemMessage =
                            messageId.startsWith('lang-change-') ||
                                messageId.startsWith('welcome');
                        final isCurrentlySpeaking =
                            messageId == _currentlySpeakingMessageId;
                        final timestamp = message['timestamp'] != null
                            ? _formatTimestamp(message['timestamp']!)
                            : '';

                        if (isSystemMessage) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['text'] ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green.shade900,
                                  ),
                                ),
                                if (timestamp.isNotEmpty)
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      timestamp,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }

                        return GestureDetector(
                          onTap: isUser
                              ? null
                              : () => _speak(
                                    _processTextForSpeech(message['text'] ?? ''),
                                    messageId,
                                  ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment:
                                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isUser)
                                  CircleAvatar(
                                    backgroundColor: Colors.green.shade200,
                                    child: Icon(
                                      Icons.agriculture,
                                      color: Colors.green.shade800,
                                      size: 20,
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isUser
                                          ? Colors.green.shade200
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isUser
                                            ? Colors.green.shade300
                                            : Colors.grey.shade300,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message['text'] ?? '',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            if (!isUser && isCurrentlySpeaking)
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.volume_up,
                                                    size: 14,
                                                    color: Colors.green.shade800,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'Speaking',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.green.shade800,
                                                      fontStyle: FontStyle.italic,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                ],
                                              ),
                                            Text(
                                              timestamp,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (isUser)
                                  CircleAvatar(
                                    backgroundColor: Colors.green.shade700,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (_isLoading && _conversationHistory.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.green.shade700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Thinking...',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -2),
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _startListening,
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening ? Colors.red : Colors.green.shade700,
                        size: 28,
                      ),
                      tooltip:
                          _isListening ? 'Stop listening' : 'Start voice input',
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.shade300),
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type your farming query...',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey.shade600),
                          ),
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 3,
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              _sendMessage(value);
                            }
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_messageController.text.trim().isNotEmpty) {
                          _sendMessage(_messageController.text);
                        }
                      },
                      icon: Icon(Icons.send, color: Colors.green.shade700, size: 28),
                      tooltip: 'Send message',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _speech.cancel();
    _flutterTts.stop();
    super.dispose();
  }
}