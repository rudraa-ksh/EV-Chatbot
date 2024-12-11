import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> _messages = [];
  final String apiUrl = "http://<IP>/troubleshoot";

  void _sendMessage(String userMessage) async {
    setState(() {
      _messages.add({'user': userMessage});
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'issue': userMessage}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _messages.add({'bot': data['steps'][0]['question']});
        });
      } else {
        setState(() {
          _messages.add({'bot': "I'm sorry, I couldn't understand that."});
        });
      }
    } catch (error) {
      setState(() {
        _messages.add({'bot': "Error connecting to the server."});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EV Troubleshooting Chatbot')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (ctx, index) {
                final message = _messages[_messages.length - 1 - index];
                return MessageBubble(
                  message: message.values.first!,
                  isUserMessage: message.keys.first == 'user',
                );
              },
            ),
          ),
          MessageInput(_sendMessage),
        ],
      ),
    );
  }
}
