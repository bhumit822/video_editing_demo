import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/return_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_editing_demo/ui/viewpage.dart';
import 'package:video_player/video_player.dart';

class EditingCotroller extends GetxController {
  Rx<VideoPlayerController> vc = VideoPlayerController.file(File("")).obs;

  genrateEditingView(context) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    final dir = Directory("/storage/emulated/0/ccc/");
    if (dir.existsSync()) {
    } else {
      await dir.create(recursive: true);
    }
    final thumbdir = Directory("/storage/emulated/0/ccc/thumbnail");
    if (thumbdir.existsSync()) {
      thumbdir.listSync().forEach((element) {
        element.delete();
      });
    } else {
      await thumbdir.create(recursive: true);
    }

    final File file = File("/storage/emulated/0/ccc/test222.mp4");

    final File save = File(
        "/storage/emulated/0/ccc" + "/videoc${math.Random().nextInt(100)}.mp4");
    // await save.create();

    final _a = await FFmpegKitConfig.selectDocumentForRead('video/*')
        .then((input) async {
      await FFmpegKitConfig.getSafParameterForRead(input!).then((value) async {
        log("sdfsdfsdf----->$value");
        // await FFmpegKit.executeAsync(
        //     '-i ${value} -vf "transpose=1" ${save.path}', (session) async {
        //   final returnCode = await session.getReturnCode();

        //   if (ReturnCode.isSuccess(returnCode)) {
        //     // SUCCESS
        //     log("Success----->");
        //     Get.to(() => VideoEditingView(
        //           video: save,
        //         ));
        //   } else if (ReturnCode.isCancel(returnCode)) {
        //     // CANCEL
        //     log("cancel----->");
        //   } else {
        //     // ERROR
        //     log("error-----> ${(await session.getAllLogs()).map((e) => e.getMessage())}");
        //   }
        // });
        // await FFmpegKit.executeAsync("-i ${value}  ${save.path}",
        //     // "-r 10 -i ${files.last} -r 200 ${save.path}",
        //     (session) async {
        //   final returnCode = await session.getReturnCode();

        //   if (ReturnCode.isSuccess(returnCode)) {
        //     // SUCCESS
        //     log("Success----->");
        //     Get.to(() => VideoEditingView(
        //           video: save,
        //         ));
        //   } else if (ReturnCode.isCancel(returnCode)) {
        //     // CANCEL
        //     log("cancel----->");
        //   } else {
        //     // ERROR
        //     log("error-----> ${(await session.getAllLogs()).map((e) => e.getMessage())}");
        //   }
        // });

        await FFmpegKit.executeAsync(
            "-i $value -vf fps=1/4 ${thumbdir.path}/.thumb%d.jpg",
            (session) async {
          final returnCode = await session.getReturnCode();

          if (ReturnCode.isSuccess(returnCode)) {
            // SUCCESS
            log("Success----->");
          } else if (ReturnCode.isCancel(returnCode)) {
            // CANCEL
            log("cancel----->");
          } else {
            // ERROR
            log("error-----> ${(await session.getAllLogs()).map((e) => e.getMessage())}");
          }
        });
        Get.to(() => VideoEditingView(video: save));
      });
    });

    //this is working
    // final _a = await FFmpegKitConfig.selectDocumentForWrite(
    //         "test%2d.mp4", 'video/*')
    //     .then((uri) async {
    //   await FFmpegKitConfig.getSafParameterForWrite(uri!)
    //       .then((safUrl) async {
    //     log("test----->_ffmpeg_output=====${safUrl}");
    //     await FFmpegKit.executeAsync(
    //         "-i ${files.last} -ss 40.0 ${save.path}",
    //         // "-r 10 -i ${files.last} -r 200 ${save.path}",
    //         (session) async {
    //       final returnCode = await session.getReturnCode();

    //       if (ReturnCode.isSuccess(returnCode)) {
    //         // SUCCESS
    //         log("Success----->");
    //         log("lenght----->${save.lengthSync()}");
    //         final vc = VideoPlayerController.file(save);
    //         await vc.initialize();
    //         await showDialog(
    //             context: context,
    //             builder: (context) {
    //               vc.play();
    //               return VideoPlayer(vc);
    //             });
    //         vc.pause();
    //       } else if (ReturnCode.isCancel(returnCode)) {
    //         // CANCEL
    //         log("cancel----->");
    //       } else {
    //         // ERROR
    //         log("error-----> ${(await session.getAllLogs()).map((e) => e.getMessage())}");
    //       }
    //     });
    //   });
    // });

    // FFmpegKit.execute(
    //         '-i ${files.last} -i "[0:v][1:v] overlay=5:2, drawtext=fontsize=20:fontcolor=white:text=hello" out.mp4')
    //     .then((rc) async => print(
    //         "FFmpeg process exited with rc ${(await rc.getOutput())}"));

    // print("------>${(await _v.getOutput())}");
    // log("test----->_ffmpeg_output=====${_ffmpeg_output}");
    // log("test----->_ffmpeg_output=====${x}");
    // print(
    //     "------>msgs----${(await _v.getLogs()).map((e) => e.getMessage())}");
  }
}
