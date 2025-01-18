import 'package:google_generative_ai/google_generative_ai.dart';

class ChatService {
  static const apiKey = 'AIzaSyBlw1diQUuWp75-7xJMsPeGSwIpYVJ5C7o';
  final model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: apiKey,
  );
  late ChatSession chat;

  ChatService() {
    _initChat();
  }

  void _initChat() {
    chat = model.startChat(
      history: [
        Content.text(
          'You are a supportive and empathetic addiction counselor. Your role is to provide emotional support, motivation, and general guidance for people struggling with drug addiction. Do not provide medical advice. If someone is in crisis, direct them to emergency services or professional help. Always maintain a compassionate, non-judgmental tone.',
        ),
      ],
    );
  }

  Future<String> sendMessage(String message) async {
    try {
      final response = await chat.sendMessage(Content.text(message));
      final responseText = response.text ?? 'I apologize, but I cannot provide a response at this moment. Please try again.';
      return responseText;
    } catch (e) {
      return 'Error: Unable to process your message. Please try again later.';
    }
  }
} 