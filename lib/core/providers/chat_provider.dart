import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  ChatService _chatService = ChatService();
  final SharedPreferences _prefs;
  List<ChatMessage> _messages = [];
  bool _isLoading = false;

  ChatProvider(this._prefs) {
    _loadMessages();
  }

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  void _loadMessages() {
    final messagesJson = _prefs.getStringList('chat_messages') ?? [];
    _messages = messagesJson
        .map((json) => ChatMessage.fromJson(jsonDecode(json)))
        .toList();
    notifyListeners();
  }

  void _saveMessages() {
    final messagesJson = _messages
        .map((message) => jsonEncode(message.toJson()))
        .toList();
    _prefs.setStringList('chat_messages', messagesJson);
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      content: content,
      timestamp: DateTime.now(),
      isUser: true,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();

    try {
      // Get AI response
      final response = await _chatService.sendMessage(content);
      
      final aiMessage = ChatMessage(
        content: response,
        timestamp: DateTime.now(),
        isUser: false,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      _messages.add(aiMessage);
      _saveMessages();
    } catch (e) {
      // Handle error
      print('Error sending message: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    _saveMessages();
    _chatService = ChatService(); // Reset chat context
    notifyListeners();
  }
} 