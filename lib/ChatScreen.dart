import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _chatMessages = [];
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatBot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: _chatMessages.map((message) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ChatBubble(
                      message: message['message'],
                      isUser: message['type'] == 'user',
                      time: message['time'],
                      sender: message['sender'],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    String userMessage = _messageController.text;

    // Send user message to the Makersuite API
    String chatBotResponse = await sendMessageToChatBot(userMessage);

    // Update the chat messages
    setState(() {
      _chatMessages.add({
        'message': userMessage,
        'type': 'user',
        'time': DateTime.now(),
        'sender': 'You',
      });

      _chatMessages.add({
        'message': chatBotResponse,
        'type': 'bot',
        'time': DateTime.now(),
        'sender': 'ChatBot',
      });
    });

    // Clear the message input field
    _messageController.clear();
  }


  Future<String> sendMessageToChatBot(String message) async {
    final apiKey = 'AIzaSyCF5XyXjfjOO1MhldxsycOSO6s55gQBTo8'; // Replace with your actual API key
    final url = 'https://generativelanguage.googleapis.com/v1beta2/models/chat-bison-001:generateMessage?key=$apiKey';
    final uri = Uri.parse(url);

    // Prepare the request payload
    Map<String, dynamic> request = {
      "prompt": {
        "messages": [{"content": message}]
      },
      "temperature": 0.25,
      "candidateCount": 1,
      "topP": 1,
      "topK": 1
    };

    // Make the HTTP POST request
    final response = await http.post(uri, body: jsonEncode(request));

    // Extract the response message
    final chatBotResponse = json.decode(response.body)["candidates"][0]["content"];

    return chatBotResponse;
  }
}

class ChatBubble extends StatelessWidget {
  final String? message;
  final bool isUser;
  final DateTime? time;
  final String? sender;

  ChatBubble({this.message, required this.isUser, this.time, this.sender});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          sender ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isUser ? Colors.green : Colors.blue,
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isUser ? Colors.green : Colors.grey[300],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) // Display chatbot logo for non-user messages
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    'assets/chatbot.jpg', // Replace with your image asset
                    width: 20.0,
                    height: 20.0,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message ?? '',
                      style: TextStyle(color: isUser ? Colors.white : Colors.black),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      time != null ? DateFormat('HH:mm').format(time!) : '',
                      style: TextStyle(fontSize: 10.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
