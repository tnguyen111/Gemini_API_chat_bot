import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ai/ai.dart';
import '../../state_management/state_management.dart';
import 'objects/objects.dart';

Widget mobileLandscape(WidgetRef ref) {
  return Scaffold(
    appBar: null,
    body: Stack(children: [
      chatMessage(),
      bottomTextBox(ref),
      IconButton(
        alignment: Alignment.topLeft,
        tooltip: 'Clear History',
        padding: const EdgeInsets.all(15),
        color: Colors.black,
        iconSize: 25,
        icon: const Icon(Icons.restart_alt),
        onPressed: () {
          clearHistory();
          messageSetState(ref, 3);
        },
      ),
    ]),
  );
}
