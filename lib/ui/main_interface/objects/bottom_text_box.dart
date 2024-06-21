import 'dart:io';
import 'dart:typed_data';


import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ai/ai.dart';
import '../../../state_management/state_management.dart';

Widget bottomTextBox(WidgetRef ref) {
  var state = messageWatchState(ref);
  var controller = TextEditingController();
  String text = '';
  return Stack(
    children: <Widget>[
      Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
          height: 60,
          width: double.infinity,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    String pathInput = result.files.single.path!;
                    File file = File(pathInput);
                    Uint8List input = file.readAsBytesSync();
                    messageSetState(ref, 1);
                    sendFiles(ref, input, pathInput);
                    messageSetState(ref, 2);
                  } else {
                    // User canceled the picker
                  }
                },
                icon: const Icon(
                  Icons.add_rounded,
                  color: Colors.lightBlue,
                  size: 30,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                      hintText: "Write message...",
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none),
                  controller: controller,
                  onChanged: (value) {
                    text = value;
                  },
                  onSubmitted: (value) {
                    if (text != '') {
                      messageSetState(ref, 1);
                      text = value;
                      SendResponse(ref, text);
                      controller.clear();
                      messageSetState(ref, 2);
                    } else {
                      null;
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              FloatingActionButton(
                onPressed: () {
                  if (text != '') {
                    SendResponse(ref, text);
                    controller.clear();
                  }
                },
                backgroundColor: Colors.blue,
                elevation: 0,
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ),
      ),
    ],
  );
}
