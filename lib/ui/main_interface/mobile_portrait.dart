import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ai/ai.dart';
import '../../state_management/state_management.dart';
import 'objects/objects.dart';

Widget mobilePortrait(WidgetRef ref) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blue,
      leading: Builder(
        builder: (context) {
          return IconButton(
            tooltip: 'Clear History',
            color: Colors.black,
            iconSize: 25,
            icon: const Icon(Icons.restart_alt),
            onPressed: () {
              clearHistory();
              messageSetState(ref, 3);
            },
          );
        },
      ),
    ),
    body: Stack(children: [
      chatMessage(),
      bottomTextBox(ref),
    ]),
  );
}
