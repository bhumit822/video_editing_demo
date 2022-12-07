import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_editing_demo/controllers/videoviewcontroller.dart';
import 'package:video_editing_demo/ui/viewpage.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  EditingCotroller().genrateEditingView(context);
                },
                icon: Icon(Icons.add_box_rounded))
          ],
        ),
        body: "hello".toText());
  }
}

extension TextWidget on String {
  Text toText() {
    return Text(this);
  }
}

extension OnTextWidget on Text {}
