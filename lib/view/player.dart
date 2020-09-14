import 'package:flutter/material.dart';
import 'package:fluttermovie/helper/helper.dart';
import 'package:video_player/video_player.dart';


class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {

  Helper _helper = new Helper();

  String url_video = "https://firebasestorage.googleapis.com/v0/b/otakuindo-a8247.appspot.com/o/Youjo+Senki+Movie%2F480p%2F%5BOtakuindo.org%5D+%5BMp4%5D+%5B480p%5D+Youjo+Senki+Movie.mp4?alt=media&token=d8ff7a5d-f0a0-486d-952a-b17c32628874";

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  playVideo(){
    _controller = VideoPlayerController.network(
        url_video)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }


  @override
  void initState() {
    _controller = VideoPlayerController.network(
        url_video);
    //_controller = VideoPlayerController.asset("videos/sample_video.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child:
        Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
