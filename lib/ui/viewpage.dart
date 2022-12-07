import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoEditingView extends StatefulWidget {
  const VideoEditingView({super.key, required this.video});
  final File video;
  @override
  State<VideoEditingView> createState() => _VideoEditingViewState();
}

class _VideoEditingViewState extends State<VideoEditingView> {
  @override
  void initState() {
    super.initState();
    getDirStatus();
    _scrollController.addListener(() {
      log(_scrollController.position.pixels.toString());
    });
    // initVideo();
  }

  initVideo() async {
    vc = VideoPlayerController.file(widget.video);
    await vc?.initialize();
    setState(() {
      isVideo = true;
    });
  }

  final booksDir = Directory("/storage/emulated/0/ccc/thumbnail");
  bool isDirectoryExistent = false;

  List<String> thumbs = [];
  bool isVideo = false;
  ScrollController _scrollController = ScrollController();
  StreamController<List<String>> _streamController = StreamController();
  Stream<List<FileSystemEntity>>? fileStream;
  VideoPlayerController? vc;
  void getDirStatus() async {
    await booksDir.exists().then((isThere) {
      if (isThere) {
        setState(() {
          isDirectoryExistent = true;
        });

        booksDir.watch(events: FileSystemEvent.create).listen((event) {
          log("eeeeeeee-----${event.path}");
          thumbs.add(event.path);
          _streamController.add(thumbs);
          _streamController.sink;
        });
        // fileStream?.listen((event) {
        //   log(event.map((e) => e.path).toString());
        // });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  final dir = await Directory("/storage/emulated/0/ccc");
                  log(dir.listSync().length.toString());
                  // await FFmpegKit.executeAsync(
                  //     "-i ${piked.files.first.path} ${file.path}");
                  // FFmpegKit.executeAsync(
                  //     "-i ${piked.files.first.path}-vf fps=1 ${thumbdir.path}/i%d.png");

                } catch (e) {
                  log(e.toString());
                }
              },
              icon: Icon(Icons.add_box_rounded))
        ],
      ),
      body: Column(
        children: [
          Expanded(child: isVideo ? VideoPlayer(vc!) : SizedBox()),
          SizedBox(
            height: 100,
            child: Row(
              children: [
                Expanded(
                  child: isDirectoryExistent
                      ? StreamBuilder(
                          stream: _streamController.stream,
                          builder: (context, ss) {
                            if (ss.hasData) {
                              return ListView.builder(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: ss.data!.length,
                                  itemBuilder: (context, index) {
                                    return Image.file(File(ss.data![index]));
                                  });
                            } else {
                              return Center(
                                  child: CircularProgressIndicator.adaptive());
                            }
                          })
                      : Text("Nofiles"),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
      ),
    );
  }
}
