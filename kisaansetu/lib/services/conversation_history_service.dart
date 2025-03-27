import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConversationHistoryService {
  static const String _historyKey = 'conversation_history';
  static const int _maxHistoryMessages = 20; // Limit history size

  // Save conversation history to SharedPreferences
  static Future<void> saveConversation(List<Map<String, String>> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Filter out system messages like language changes
      final filteredMessages = messages.where((message) {
        final id = message['id'] ?? '';
        return !id.startsWith('lang-change-') && !id.startsWith('welcome');
      }).toList();

      // Limit the number of messages to prevent excessive storage usage
      final messagesToSave = filteredMessages.length > _maxHistoryMessages 
          ? filteredMessages.sublist(filteredMessages.length - _maxHistoryMessages) 
          : filteredMessages;

      // Convert messages to JSON string and save
      final jsonData = jsonEncode(messagesToSave);
      await prefs.setString(_historyKey, jsonData);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving conversation history: $e');
      }
    }
  }

  // Load conversation history from SharedPreferences
  static Future<List<Map<String, String>>> loadConversation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = prefs.getString(_historyKey);

      if (jsonData == null || jsonData.isEmpty) {
        return [];
      }

      // Decode JSON string to list of messages
      final List<dynamic> decodedData = jsonDecode(jsonData);
      return decodedData.map<Map<String, String>>((item) {
        return Map<String, String>.from(item);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading conversation history: $e');
      }
      return [];
    }
  }

  // Clear conversation history
  static Future<void> clearConversation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing conversation history: $e');
      }
    }
  }
}