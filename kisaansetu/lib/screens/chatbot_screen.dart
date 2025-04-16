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

//   List<Map<String, dynamic>> _conversationHistory = [];
//   bool _isListening = false;
//   bool _isSpeaking = false;
//   bool _isLoading = false;
//   bool _autoSpeakEnabled = true;
//   String? _currentlySpeakingMessageId;

//   // Language settings
//   String _selectedLanguage = 'English';
//   String _languageCode = 'en-US';

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
//     _loadLanguagePreference().then((_) {
//       _initializeSpeech();
//       _initializeTts();
//       _loadConversationHistory();
//     });
//   }

//   // ================== LANGUAGE DETECTION ==================
//   String _detectInputLanguage(String text) {
//     if (text.isEmpty) return _languageCode;
    
//     // Hindi character range
//     if (text.contains(RegExp(r'[\u0900-\u097F]'))) return 'hi-IN';
//     // Punjabi character range
//     if (text.contains(RegExp(r'[\u0A00-\u0A7F]'))) return 'pa-IN';
//     // Bengali character range
//     if (text.contains(RegExp(r'[\u0980-\u09FF]'))) return 'bn-IN';
//     // Tamil character range
//     if (text.contains(RegExp(r'[\u0B80-\u0BFF]'))) return 'ta-IN';
//     // Telugu character range
//     if (text.contains(RegExp(r'[\u0C00-\u0C7F]'))) return 'te-IN';
//     // Marathi character range (shares Devanagari with Hindi)
//     if (text.contains(RegExp(r'[\u0900-\u097F]'))) return 'mr-IN';
//     // Gujarati character range
//     if (text.contains(RegExp(r'[\u0A80-\u0AFF]'))) return 'gu-IN';
    
//     return _languageCode; // Default to selected language
//   }

//   // ================== CORE FUNCTIONS ==================
//   Future<void> _loadLanguagePreference() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final savedLanguage = prefs.getString('selectedLanguage') ?? 'English';
      
//       setState(() {
//         _selectedLanguage = savedLanguage;
//         _languageCode = _languageCodes[savedLanguage] ?? 'en-US';
//       });
//     } catch (e) {
//       debugPrint('Error loading language preference: $e');
//       setState(() {
//         _selectedLanguage = 'English';
//         _languageCode = 'en-US';
//       });
//     }
//   }

//   Future<void> _initializeSpeech() async {
//     try {
//       bool available = await _speech.initialize(
//         onError: (error) => debugPrint('Speech error: $error'),
//         onStatus: (status) => debugPrint('Speech status: $status'),
//       );
//       if (!available) debugPrint('Speech recognition not available');
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

//   Future<void> _loadConversationHistory() async {
//     setState(() => _isLoading = true);

//     try {
//       final history = await ConversationHistoryService.loadConversation();
//       if (history.isEmpty) {
//         _addWelcomeMessage();
//       } else {
//         setState(() {
//           _conversationHistory = history;
//           _isLoading = false;
//         });
//       }
//       _scrollToBottom();
//     } catch (e) {
//       debugPrint('Error loading history: $e');
//       setState(() => _isLoading = false);
//       _addWelcomeMessage();
//     }
//   }

//   void _addWelcomeMessage() {
//     final welcomeMessages = {
//       'English': 'Hello! I am KisaanSetu AI Assistant. How can I help you today?',
//       'Hindi': 'नमस्ते! मैं किसानसेतु AI सहायक हूँ। आज मैं आपकी कैसे मदद कर सकता हूँ?',
//       'Punjabi': 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ! ਮੈਂ ਕਿਸਾਨ ਸੇਤੁ AI ਸਹਾਇਕ ਹਾਂ। ਅੱਜ ਮੈਂ ਤੁਹਾਡੀ ਕਿਵੇਂ ਮਦਦ ਕਰ ਸਕਦਾ ਹਾਂ?',
//       'Bengali': 'নমস্কার! আমি কিষাণসেতু AI সহকারী। আজ আমি আপনাকে কীভাবে সাহায্য করতে পারি?',
//       'Tamil': 'வணக்கம்! நான் கிசான்சேது AI உதவியாளர். இன்று நான் உங்களுக்கு எப்படி உதவ முடியும்?',
//       'Telugu': 'నమస్కారం! నేను కిసాన్సేతు AI సహాయకుడిని. నేడు నేను మీకు ఎలా సహాయం చేయగలను?',
//       'Marathi': 'नमस्कार! मी किसानसेतू AI सहाय्यक आहे. आज मी तुम्हाला कशी मदत करू शकतो?',
//       'Gujarati': 'નમસ્તે! હું કિસાનસેતુ AI સહાયક છું. આજે હું તમને કેવી રીતે મદદ કરી શકું?',
//     };

//     final welcomeMessage = welcomeMessages[_selectedLanguage] ?? welcomeMessages['English']!;
//     final welcomeEntry = {
//       'id': 'welcome-${DateTime.now().millisecondsSinceEpoch}',
//       'text': welcomeMessage,
//       'isUser': false,
//       'timestamp': DateTime.now().toIso8601String(),
//       'language': _languageCode,
//     };

//     setState(() {
//       _conversationHistory.add(welcomeEntry);
//       _isLoading = false;
//     });

//     ConversationHistoryService.saveConversation(_conversationHistory);
//     if (_autoSpeakEnabled) _speak(welcomeMessage, welcomeEntry['id']!);
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   String _processTextForSpeech(String text) {
//     return text
//         .replaceAll(RegExp(r'[•*\-]'), '')
//         .replaceAll('\n\n', '. ')
//         .replaceAll('\n', '. ');
//   }

//   // ================== MESSAGE HANDLING ==================
//   Future<void> _sendMessage(String message) async {
//     if (message.trim().isEmpty) return;

//     final detectedLanguage = _detectInputLanguage(message);
//     final responseLanguage = detectedLanguage != _languageCode ? detectedLanguage : _languageCode;

//     final userMessage = {
//       'id': 'user-${DateTime.now().millisecondsSinceEpoch}',
//       'text': message,
//       'isUser': true,
//       'timestamp': DateTime.now().toIso8601String(),
//       'language': responseLanguage,
//     };

//     _messageController.clear();
//     setState(() {
//       _conversationHistory.add(userMessage);
//       _isLoading = true;
//     });

//     await ConversationHistoryService.saveConversation(_conversationHistory);
//     _scrollToBottom();

//     try {
//       if (_isSpeaking) await _flutterTts.stop();

//       Position? position;
//       try {
//         final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//         if (serviceEnabled) {
//           final permission = await Geolocator.checkPermission();
//           if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
//             position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//           }
//         }
//       } catch (e) {
//         debugPrint('Location error: $e');
//       }

//       Map<String, dynamic>? weatherData;
//       if (position != null) {
//         try {
//           weatherData = await _apiService.getCurrentWeather(
//             position.latitude,
//             position.longitude,
//           );
//         } catch (e) {
//           debugPrint('Weather error: $e');
//         }
//       }

//       // Add strict language instruction
//       final languageName = _languageCodes.keys.firstWhere(
//         (key) => _languageCodes[key] == responseLanguage,
//         orElse: () => 'English',
//       );
//       final languagePrompt = "[Respond in $languageName only] ";

//       final response = await _apiService.getChatbotResponse(
//         languagePrompt + message,
//         language: responseLanguage,
//         conversationHistory: _conversationHistory,
//         latitude: position?.latitude,
//         longitude: position?.longitude,
//         weatherData: weatherData,
//       );

//       final botMessage = {
//         'id': 'bot-${DateTime.now().millisecondsSinceEpoch}',
//         'text': response,
//         'isUser': false,
//         'timestamp': DateTime.now().toIso8601String(),
//         'language': responseLanguage,
//       };

//       setState(() {
//         _conversationHistory.add(botMessage);
//         _isLoading = false;
//       });

//       await ConversationHistoryService.saveConversation(_conversationHistory);
//       _scrollToBottom();

//       if (_autoSpeakEnabled) _speak(_processTextForSpeech(response), botMessage['id']!);
//     } catch (e) {
//       debugPrint('API error: $e');
//       _showErrorMessage(responseLanguage);
//     }
//   }

//   void _showErrorMessage(String language) {
//     final errorMessages = {
//       'English': 'Sorry, I encountered an error. Please try again.',
//       'Hindi': 'क्षमा करें, मुझे एक त्रुटि मिली। कृपया पुनः प्रयास करें।',
//       'Punjabi': 'ਮਾਫ਼ ਕਰਨਾ, ਮੈਨੂੰ ਇੱਕ ਗਲਤੀ ਮਿਲੀ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।',
//       'Bengali': 'দুঃখিত, আমি একটি ত্রুটি পেয়েছি। অনুগ্রহ করে আবার চেষ্টা করুন।',
//       'Tamil': 'மன்னிக்கவும், எனக்கு ஒரு பிழை ஏற்பட்டது. தயவுசெய்து மீண்டும் முயற்சிக்கவும்.',
//       'Telugu': 'క్షమించండి, నాకు ఒక లోపం ఎదురైంది. దయచేసి మళ్లీ ప్రయత్నించండి.',
//       'Marathi': 'क्षमस्व, मला एक त्रुटी आढळली. कृपया पुन्हा प्रयत्न करा.',
//       'Gujarati': 'માફ કરશો, મને એક ભૂલ મળી. કૃપા કરીને ફરી પ્રયાસ કરો.',
//     };

//     final errorMessage = errorMessages[_languageCodes.keys.firstWhere(
//       (key) => _languageCodes[key] == language,
//       orElse: () => 'English',
//     )] ?? errorMessages['English']!;

//     final errorEntry = {
//       'id': 'error-${DateTime.now().millisecondsSinceEpoch}',
//       'text': errorMessage,
//       'isUser': false,
//       'timestamp': DateTime.now().toIso8601String(),
//       'language': language,
//     };

//     setState(() {
//       _conversationHistory.add(errorEntry);
//       _isLoading = false;
//     });

//     ConversationHistoryService.saveConversation(_conversationHistory);
//     if (_autoSpeakEnabled) _speak(errorMessage, errorEntry['id']!);
//   }

//   // ================== SPEECH FUNCTIONS ==================
//   Future<void> _startListening() async {
//     if (_isSpeaking) await _flutterTts.stop();
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
//         localeId: '${_languageCode.split('-')[0]}_${_languageCode.split('-')[1]}',
//       );
//     } catch (e) {
//       setState(() => _isListening = false);
//       debugPrint('Listening error: $e');
//     }
//   }

//   Future<void> _speak(String text, String messageId) async {
//     if (!_autoSpeakEnabled) return;

//     final message = _conversationHistory.firstWhere(
//       (msg) => msg['id'] == messageId,
//       orElse: () => {'language': _languageCode},
//     );
//     final messageLanguage = message['language'] ?? _languageCode;

//     if (_isSpeaking) await _flutterTts.stop();

//     await _flutterTts.setLanguage(messageLanguage);
//     setState(() {
//       _isSpeaking = true;
//       _currentlySpeakingMessageId = messageId;
//     });
//     await _flutterTts.speak(text);
//   }

//   // ================== UI FUNCTIONS ==================
//   Future<void> _clearHistory() async {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Clear Chat History', style: TextStyle(color: Colors.green.shade800)),
//         content: const Text('Are you sure you want to clear all chat history?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700)),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await ConversationHistoryService.clearConversation();
//               setState(() => _conversationHistory = []);
//               _addWelcomeMessage();
//             },
//             child: Text('Clear', style: TextStyle(color: Colors.red.shade700)),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showLanguageSelector() async {
//     final newLanguage = await showDialog<String>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Select Language', style: TextStyle(color: Colors.green.shade800)),
//         content: SizedBox(
//           width: double.maxFinite,
//           child: ListView.builder(
//             shrinkWrap: true,
//             itemCount: _languageCodes.length,
//             itemBuilder: (context, index) {
//               final language = _languageCodes.keys.elementAt(index);
//               return ListTile(
//                 title: Text(language),
//                 trailing: language == _selectedLanguage ? const Icon(Icons.check, color: Colors.green) : null,
//                 onTap: () => Navigator.pop(context, language),
//               );
//             },
//           ),
//         ),
//         actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))],
//       ),
//     );

//     if (newLanguage != null && newLanguage != _selectedLanguage) {
//       setState(() {
//         _selectedLanguage = newLanguage;
//         _languageCode = _languageCodes[newLanguage] ?? 'en-US';
//       });

//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('selectedLanguage', newLanguage);
//       await _flutterTts.setLanguage(_languageCode);

//       final languageChangedMessages = {
//         'English': 'Language changed to English',
//         'Hindi': 'भाषा हिंदी में बदल दी गई है',
//         'Punjabi': 'ਭਾਸ਼ਾ ਪੰਜਾਬੀ ਵਿੱਚ ਬਦਲ ਦਿੱਤੀ ਗਈ ਹੈ',
//         'Bengali': 'ভাষা বাংলায় পরিবর্তন করা হয়েছে',
//         'Tamil': 'மொழி தமிழாக மாற்றப்பட்டது',
//         'Telugu': 'భాష తెలుగులోకి మార్చబడింది',
//         'Marathi': 'भाषा मराठीत बदलली आहे',
//         'Gujarati': 'ભાષા ગુજરાતીમાં બદલાઈ ગઈ છે',
//       };

//       final message = languageChangedMessages[newLanguage] ?? 'Language changed';
//       final messageId = 'lang-change-${DateTime.now().millisecondsSinceEpoch}';

//       setState(() {
//         _conversationHistory.add({
//           'id': messageId,
//           'text': message,
//           'isUser': false,
//           'timestamp': DateTime.now().toIso8601String(),
//           'language': _languageCode,
//         });
//       });

//       if (_autoSpeakEnabled) _speak(message, messageId);
//     }
//   }

//   String _formatTimestamp(String timestamp) {
//     try {
//       final dateTime = DateTime.parse(timestamp);
//       final now = DateTime.now();
//       final today = DateTime(now.year, now.month, now.day);
//       final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

//       return messageDate == today
//           ? '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}'
//           : '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
//     } catch (e) {
//       return '';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Row(
//           children: [
//             SizedBox(width: 10),
//             Text(
//               'KisaanSetu Assistant',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.green.shade700,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.language, color: Colors.white),
//             onPressed: _showLanguageSelector,
//             tooltip: 'Change language',
//           ),
//           IconButton(
//             icon: Icon(
//               _autoSpeakEnabled ? Icons.volume_up : Icons.volume_off,
//               color: Colors.white,
//             ),
//             onPressed: () => setState(() {
//               _autoSpeakEnabled = !_autoSpeakEnabled;
//               if (!_autoSpeakEnabled && _isSpeaking) _flutterTts.stop();
//             }),
//             tooltip: _autoSpeakEnabled ? 'Disable voice' : 'Enable voice',
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete_outline, color: Colors.white),
//             onPressed: _clearHistory,
//             tooltip: 'Clear Chat History',
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.green.shade50, Colors.green.shade100],
//           ),
//         ),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.green.shade100,
//                 boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 3, offset: const Offset(0, 2))],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.language, color: Colors.green.shade800, size: 18),
//                   const SizedBox(width: 4),
//                   Text(
//                     _selectedLanguage,
//                     style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w500),
//                   ),
//                   const SizedBox(width: 16),
//                   Icon(
//                     _isSpeaking ? Icons.record_voice_over : (_isListening ? Icons.mic : Icons.mic_none),
//                     color: _isSpeaking || _isListening ? Colors.green.shade800 : Colors.grey.shade600,
//                     size: 18,
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     _isSpeaking ? 'Speaking...' : (_isListening ? 'Listening...' : 'Voice Assistant'),
//                     style: TextStyle(
//                       color: _isSpeaking || _isListening ? Colors.green.shade800 : Colors.grey.shade600,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: _isLoading && _conversationHistory.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CircularProgressIndicator(color: Colors.green),
//                           const SizedBox(height: 16),
//                           Text(
//                             'Loading your farming assistant...',
//                             style: TextStyle(color: Colors.green.shade800, fontSize: 16),
//                           ),
//                         ],
//                       ),
//                     )
//                   : ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.all(16),
//                       itemCount: _conversationHistory.length + (_isLoading ? 1 : 0),
//                       itemBuilder: (context, index) {
//                         if (index == _conversationHistory.length) {
//                           return const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Center(
//                               child: Column(
//                                 children: [
//                                   CircularProgressIndicator(color: Colors.green),
//                                   SizedBox(height: 8),
//                                   Text('Thinking...', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green)),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }

//                         final message = _conversationHistory[index];
//                         final isUser = message['isUser'] == true;
//                         final isSystemMessage = message['id'].toString().startsWith('welcome-') || 
//                                               message['id'].toString().startsWith('lang-change-');
//                         final isCurrentlySpeaking = message['id'] == _currentlySpeakingMessageId;
//                         final timestamp = _formatTimestamp(message['timestamp'] ?? '');

//                         if (isSystemMessage) {
//                           return Container(
//                             margin: const EdgeInsets.symmetric(vertical: 8),
//                             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                             decoration: BoxDecoration(
//                               color: Colors.green.shade100,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(color: Colors.green.shade300),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   message['text'] ?? '',
//                                   style: TextStyle(fontSize: 14, color: Colors.green.shade900),
//                                 ),
//                                 if (timestamp.isNotEmpty)
//                                   Align(
//                                     alignment: Alignment.bottomRight,
//                                     child: Text(
//                                       timestamp,
//                                       style: TextStyle(fontSize: 10, color: Colors.green.shade700),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           );
//                         }

//                         return GestureDetector(
//                           onTap: isUser ? null : () => _speak(_processTextForSpeech(message['text'] ?? ''), message['id']!),
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 8),
//                             child: Row(
//                               mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 if (!isUser)
//                                   CircleAvatar(
//                                     backgroundColor: Colors.green.shade200,
//                                     child: Icon(Icons.agriculture, color: Colors.green.shade800, size: 20),
//                                   ),
//                                 const SizedBox(width: 8),
//                                 Flexible(
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                                     decoration: BoxDecoration(
//                                       color: isUser ? Colors.green.shade200 : Colors.white,
//                                       borderRadius: BorderRadius.circular(16),
//                                       border: Border.all(
//                                         color: isUser ? Colors.green.shade300 : Colors.grey.shade300),
//                                       ),
//                                       boxShadow: [BoxShadow(
//                                         color: Colors.black.withOpacity(0.05),
//                                         blurRadius: 5,
//                                         offset: const Offset(0, 2),
//                                       )],
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           message['text'] ?? '',
//                                           style: const TextStyle(fontSize: 15, color: Colors.black87),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           mainAxisAlignment: MainAxisAlignment.end,
//                                           children: [
//                                             if (!isUser && isCurrentlySpeaking)
//                                               Row(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   Icon(Icons.volume_up, size: 14, color: Colors.green.shade800),
//                                                   const SizedBox(width: 4),
//                                                   Text(
//                                                     'Speaking',
//                                                     style: TextStyle(
//                                                       fontSize: 10,
//                                                       color: Colors.green.shade800,
//                                                       fontStyle: FontStyle.italic,
//                                                     ),
//                                                   ),
//                                                   const SizedBox(width: 8),
//                                                 ],
//                                               ),
//                                             Text(
//                                               timestamp,
//                                               style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
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
//                                     backgroundColor: Colors.green.shade700,
//                                     child: const Icon(Icons.person, color: Colors.white, size: 20),
//                                   ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//             if (_isLoading && _conversationHistory.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: 16,
//                       height: 16,
//                       child: CircularProgressIndicator(strokeWidth: 2, color: Colors.green.shade700),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Thinking...',
//                       style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green.shade700),
//                     ),
//                   ],
//                 ),
//               ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [BoxShadow(
//                   offset: const Offset(0, -2),
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 5,
//                 )],
//               ),
//               child: SafeArea(
//                 child: Row(
//                   children: [
//                     IconButton(
//                       onPressed: _startListening,
//                       icon: Icon(
//                         _isListening ? Icons.mic : Icons.mic_none,
//                         color: _isListening ? Colors.red : Colors.green.shade700,
//                         size: 28,
//                       ),
//                       tooltip: _isListening ? 'Stop listening' : 'Start voice input',
//                     ),
//                     Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.green.shade50,
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(color: Colors.green.shade300),
//                         ),
//                         child: TextField(
//                           controller: _messageController,
//                           decoration: InputDecoration(
//                             hintText: 'Type your farming query...',
//                             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                             border: InputBorder.none,
//                             focusedBorder: InputBorder.none,
//                             enabledBorder: InputBorder.none,
//                             hintStyle: TextStyle(color: Colors.grey.shade600),
//                           ),
//                           keyboardType: TextInputType.multiline,
//                           minLines: 1,
//                           maxLines: 3,
//                           onSubmitted: (value) {
//                             if (value.trim().isNotEmpty) _sendMessage(value);
//                           },
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         if (_messageController.text.trim().isNotEmpty) {
//                           _sendMessage(_messageController.text);
//                         }
//                       },
//                       icon: Icon(Icons.send, color: Colors.green.shade700, size: 28),
//                       tooltip: 'Send message',
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
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