import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  final Function(String) onSendMessage;

  const MessageInput(this.onSendMessage);

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _controller = TextEditingController();

  void _submitMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Type your message'),
              onSubmitted: (_) => _submitMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _submitMessage,
          ),
        ],
      ),
    );
  }
}
