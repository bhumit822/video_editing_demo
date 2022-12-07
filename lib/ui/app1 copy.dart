import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
                void Function(Object, StackTrace)? onError;

                try {
                  final piked = await FilePicker.platform.pickFiles();
                  if (piked != null) {
                    await Permission.storage.request();
                    final File file = File(
                        "${(await getTemporaryDirectory()).path}/test.mp4");
                    await file.create();
                    final Directory thumbdir = Directory(
                        "${(await getTemporaryDirectory()).path}/test");
                    thumbdir.createSync();

                    FFmpegKit.executeAsync(
                      "-i ${piked.files.first} -f mp3 -ab 320000 -vn ${file.path}",
                      (session) async {
                        final state = FFmpegKitConfig.sessionStateToString(
                            await session.getState());
                        final code = await session.getReturnCode();

                        if (ReturnCode.isSuccess(code)) {
                        } else {
                          if (onError != null) {
                            onError(
                              Exception(
                                  'FFmpeg process exited with state $state and return code $code.\n${await session.getOutput()}'),
                              StackTrace.current,
                            );
                          }
                          return;
                        }
                      },
                      (l) => log(l.getMessage().toString()),
                    ).then((value) async =>
                        log("${await value.getAllLogsAsString()}"));
                    // await FFmpegKit.executeAsync(
                    //     "-i ${piked.files.first} -ss 40.0 ${file.path}"
                    //     // "-r 10 -i ${files.last} -r 200 ${save.path}",
                    //     , (session) async {
                    //   final returnCode = await session.getReturnCode();
                    //   await Permission.storage.request();
                    //   if (ReturnCode.isSuccess(returnCode)) {
                    //     // SUCCESS
                    //     log("Success----->");
                    //     log("lenght----->${file.lengthSync()}");
                    //     Get.to(() => VideoEditingView());

                    //   } else if (ReturnCode.isCancel(returnCode)) {
                    //     // CANCEL
                    //     log("cancel----->");
                    //   } else {
                    //     // ERROR
                    //     log("errroo----->${file.path}");
                    //     log("errroo----->${piked.files.first.path}");
                    //     log("error----->${(await session.getAllLogs()).map((e) => e.getMessage())}");
                    //   }
                    // });
                    // await FFmpegKit.executeAsync(
                    //     "-i ${piked.files.first.path} ${file.path}");
                    // await FFmpegKit.executeAsync(
                    //     "-i ${piked.files.first.path}-vf fps=1 ${thumbdir.path}/i%d.png");

                    // await FFmpegKit.executeWithArguments([
                    //   "-i ${piked.files.first.path} ${file.path}",
                    //   "-i ${piked.files.first.path}-vf fps=1 ${thumbdir.path}/i%d.png"
                    // ]).whenComplete(() => Get.to(() => VideoEditingView()));

                  }
                } catch (e) {
                  log(e.toString());
                }
              },
              icon: Icon(Icons.add_box_rounded))
        ],
      ),
    );
  }
}
