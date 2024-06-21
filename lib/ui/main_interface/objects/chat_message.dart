import 'package:flutter/material.dart';
import '../../../message_history.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

ScrollController _scrollController = ScrollController();

_scrollToBottom() {
  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
}

class ChatMessage {
  dynamic messageContent;
  String messageType;

  ChatMessage({required this.messageContent, required this.messageType});
}

Widget chatMessage() {
  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  return Stack(
    children: <Widget>[
      ListView.builder(
        itemCount: messages.length,
        shrinkWrap: true,
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 10, bottom: 60),
        itemBuilder: (context, index) {
          return (messages[index].messageType == "image")
              ? Container(
                  padding: const EdgeInsets.only(
                      top: 10, left: 14, right: 14, bottom: 10),
                  child: Image.memory(
                    messages[index].messageContent,
                    height: 300,
                    width: 200,
                    alignment: Alignment.topRight,
                    fit: BoxFit.scaleDown,
                  ),
                )
              : (messages[index].messageContent == "..." &&
                      messages[index].messageType == "gemini")
                  ? Container(
                      padding: const EdgeInsets.only(
                          left: 14, right: 14, bottom: 10),
                      child: const Align(
                        alignment: Alignment.topLeft,
                        child: Icon(Icons.more_horiz, size: 30),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.only(
                          left: 14, right: 14, top: 10, bottom: 10),
                      child: Align(
                        alignment: (messages[index].messageType == "gemini"
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (messages[index].messageType == "gemini"
                                ? Colors.grey.shade200
                                : Colors.blue[200]),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: MarkdownBody(
                            selectable: true,
                            data: messages[index].messageType == "doc"
                                ? 'File Sent'
                                : messages[index].messageContent,
                            styleSheet: MarkdownStyleSheet(
                              textScaler: const TextScaler.linear(1.2),
                            ),
                          ),
                        ),
                      ),
                    );
        },
      ),
    ],
  );
}
