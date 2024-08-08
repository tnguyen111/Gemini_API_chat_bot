import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:testing_responsive_gemini_image_chat/message_history.dart';
import 'package:testing_responsive_gemini_image_chat/state_management/state_management.dart';
import '../ui/main_interface/objects/objects.dart';
import 'package:mime/mime.dart';
import 'package:docx_to_text/docx_to_text.dart';

final model = GenerativeModel(
  model: 'gemini-1.5-flash',
  apiKey: 'API KEY HERE',
  systemInstruction: Content.system('''
          You are a chat bot.
          The user can send you messages or files, and they can also reset your chat history.
          YOU CAN SEE FILES AND IMAGE!
          '''),
  generationConfig: GenerationConfig(temperature: 2),
   safetySettings: [
     SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
     SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
     SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
     SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
  ]
);

ChatSession chat = model.startChat();

Future<String> SendResponse(WidgetRef ref, String input) async {
  print("Gemini run");
  dynamic response;
  String geminiResponse = '';
  try {
    print(jsonEncode(input));
    messages.add(
      ChatMessage(messageContent: input, messageType: "sender"),
    );
    messageSetState(ref, 1);
    messages.add(
      ChatMessage(messageContent: '...', messageType: "gemini"),
    );
    response = await chat.sendMessage(Content.text(jsonEncode(input)));
    messageSetState(ref, 2);
    geminiResponse = response.text;
    print("Gemini reponse: $geminiResponse");
    messages.removeLast();
    messages.add(
      ChatMessage(messageContent: geminiResponse, messageType: "gemini"),
    );
    print('Message History: $messages');
  } catch (e) {
    messages.removeLast();
    print(e.toString());
    messages
        .add(ChatMessage(messageContent: e.toString(), messageType: "gemini"));
    messageSetState(ref, 2);
    return e.toString();
  }
  return geminiResponse;
}

Future<String> sendFiles(WidgetRef ref, Uint8List input, String path) async {
  print("Gemini run file");
  String? geminiResponse = '';
  try {
    var mimeType = lookupMimeType(path);
    print(path);
    print(mimeType);
    if (mimeType == null) {
      if (path.endsWith('jfif')) {
        mimeType = 'image/jpg';
      }
    }

    if (mimeType!.startsWith('image/')) {
      messages.add(
        ChatMessage(messageContent: input, messageType: "image"),
      );
    } else if (path.endsWith('docx')) {
      print('docx start');
      String docxText = docxToText(input);
      mimeType = 'text/plain';
      return SendResponse(ref, docxText);
    } else if (mimeType.startsWith('application/')) {
      mimeType = 'text/rtf';
      messages.add(
        ChatMessage(messageContent: input, messageType: "doc"),
      );
    } else if (mimeType.startsWith('text/')) {
      messages.add(
        ChatMessage(messageContent: input, messageType: "doc"),
      );
    }
    messageSetState(ref, 1);
    messages.add(
      ChatMessage(messageContent: '...', messageType: "gemini"),
    );
    print(input);
    final response = await chat.sendMessage(Content.data(mimeType, input));
    messageSetState(ref, 2);
    geminiResponse = response.text;
    print("Gemini reponse: ${geminiResponse!}");
    messages.removeLast();
    messages.add(
      ChatMessage(messageContent: geminiResponse, messageType: "gemini"),
    );
    print('Message History: $messages');
  } catch (e) {
    messages.removeLast();
    print(e.toString());
    messages
        .add(ChatMessage(messageContent: e.toString(), messageType: "gemini"));
    messageSetState(ref, 2);
    return e.toString();
  }
  return geminiResponse;
}

void clearHistory() {
  chat = model.startChat();
  messages.clear();
  return;
}
