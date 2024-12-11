import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const EVChatbotApp());
}

class EVChatbotApp extends StatelessWidget {
  const EVChatbotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EV Troubleshooting Chatbot',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChatScreen(),
    );
  }
}
