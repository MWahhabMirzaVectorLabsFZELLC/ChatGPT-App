// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'chatmessage.dart';
import 'threedots.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
final TextEditingController _controller = TextEditingController();
final List<ChatMessage> _messages = [];
ChatGPT?  chatGPT;

StreamSubscription? _subscription;
bool _isTyping = false;

@override
  void initState() {
    super.initState();
    chatGPT = ChatGPT.instance;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

void _sendMessage() {
  ChatMessage message = ChatMessage(text: _controller.text, sender: "user");

  setState(() {
    _messages.insert(0, message);
    _isTyping = true;
  });

  _controller.clear();

  final request = CompleteReq(
    prompt: message.text, model: kTranslations, max_tokens:200);

    _subscription = chatGPT!
        .builder("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", 
            orgId: "")
        .onCompleteStream(request: request)
        .listen((response) {
      Vx.log(response!.choices[0].text);
      ChatMessage botMessage = 
          ChatMessage(text: response!.choices[0].text, sender: "bot");

      setState(() {
        _isTyping = false;
        _messages.insert(0, botMessage);
      });
    });
}

  Widget _buildTextComposer(){
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (value) => _sendMessage(),
            decoration: InputDecoration.collapsed(hintText: "Ask me anything"),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () => _sendMessage(),
        ),
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ChatGPT App"),),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              reverse: true,
              padding: Vx.m8,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            )),
            if (_isTyping) ThreeDots(),
            Divider(
              height: 1,
            ),
            Container(
              decoration: BoxDecoration(
                color: context.cardColor
              ),
              child: _buildTextComposer(),
            )
          ],
        ),
      ),
    );
  }
  
  CompleteReq({required String prompt, required String model, required int max_tokens}) {}
}


class ChatGPT {
  static ChatGPT? instance;
  
  builder(String s, {required String orgId}) {}
  
}