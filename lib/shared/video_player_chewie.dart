import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerChewie extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  VideoPlayerChewie({
    @required this.videoPlayerController,
    this.looping,
    Key key,
  }) : super(key: key);

  @override
  _VideoPlayerChewieState createState() => _VideoPlayerChewieState();
}

class _VideoPlayerChewieState extends State<VideoPlayerChewie> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16/9,
      autoInitialize: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.red,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.red[100],
      ),
      placeholder: Container(
          color: Colors.black),
      looping: widget.looping,
      errorBuilder: (context, errorMessage){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Chewie(
      controller: _chewieController,
    );

  }
  @override
  void dispose() {
    super.dispose();
    _chewieController.pause();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
