import 'package:google_generative_ai/google_generative_ai.dart';

class ChatService {
  static const apiKey = 'AIzaSyBlw1diQUuWp75-7xJMsPeGSwIpYVJ5C7o';
  late ChatSession chat;
  
  ChatService() {
    _initChat();
  }

  void _initChat() {
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
    chat = model.startChat(
      history: [
        Content.text('''You are an empathetic addiction recovery support AI assistant. Your role is to:
1. Provide supportive, non-judgmental responses focused on addiction recovery
2. Recognize triggers and offer specific coping strategies for substance abuse
3. Celebrate recovery milestones and encourage continued sobriety
4. Share evidence-based techniques for managing cravings
5. Always maintain a recovery-focused perspective
6. Remind users to seek professional help for serious concerns
7. Never give medical advice or suggest medications
8. Be understanding but firm about the importance of staying clean

Remember:
- The user is in recovery from substance abuse
- Every interaction should support their sobriety journey
- Focus on practical coping strategies and emotional support
- Acknowledge the difficulty of recovery while maintaining hope
- If user mentions relapse thoughts, emphasize reaching out to their support system

Current context: The user is working on their recovery and using this app to maintain sobriety.'''),
        Content.text('Understood. I will act as a supportive recovery companion, focusing on addiction-specific support and coping strategies while maintaining appropriate boundaries.'),
      ],
    );
  }

  Future<String> sendMessage(String message) async {
    try {
      final response = await chat.sendMessage(Content.text(message));
      final text = response.text;
      if (text == null) {
        return 'I apologize, but I was unable to generate a response. Please try rephrasing your message.';
      }
      return text;
    } catch (e) {
      return 'I encountered an error. Remember, I\'m here to support your recovery journey, but please reach out to your counselor or support group for critical concerns.';
    }
  }
} 