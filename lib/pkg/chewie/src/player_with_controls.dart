import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import './chewie_player.dart';
import './cupertino_controls.dart';
import './material_controls.dart';

class PlayerWithControls extends StatelessWidget {
  PlayerWithControls({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChewieController chewieController = ChewieController.of(context);

    return Center(
      child: Container(
        color: Colors.black,
        child: AspectRatio(
          aspectRatio:
              chewieController.aspectRatio ?? _calculateAspectRatio(context),
          child: _buildPlayerWithControls(chewieController, context),
        ),
      ),
    );
  }

  Container _buildPlayerWithControls(
      ChewieController chewieController, BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          // chewieController.placeholder ?? Container(),
          CroppedVideo(
            chewieController: chewieController,
            controller: chewieController.videoPlayerController,
            cropAspectRatio: chewieController.aspectRatio,
          ),
          // chewieController.overlay ?? Container(),
          _buildControls(context, chewieController),
        ],
      ),
    );
  }

  Widget _buildControls(
    BuildContext context,
    ChewieController chewieController,
  ) {
    return chewieController.showControls
        ? chewieController.customControls != null
            ? chewieController.customControls
            : Theme.of(context).platform == TargetPlatform.android
                ? MaterialControls()
                : CupertinoControls(
                    backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
                    iconColor: Color.fromARGB(255, 200, 200, 200),
                  )
        : Container();
  }

  double _calculateAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return width > height ? width / height : height / width;
  }
}

class CroppedVideo extends StatefulWidget {
  CroppedVideo({this.controller, this.chewieController, this.cropAspectRatio});

  final VideoPlayerController controller;
  final ChewieController chewieController;
  final double cropAspectRatio;

  @override
  CroppedVideoState createState() => CroppedVideoState();
}

class CroppedVideoState extends State<CroppedVideo> {
  VideoPlayerController get controller => widget.controller;

  double get cropAspectRatio => widget.cropAspectRatio;
  bool initialized = false;

  VoidCallback listener;

  @override
  void initState() {
    super.initState();
    _waitForInitialized();
  }

  @override
  void didUpdateWidget(CroppedVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != controller) {
      oldWidget.controller.removeListener(listener);
      initialized = false;
      _waitForInitialized();
    }
  }

  void _waitForInitialized() {
    listener = () {
      if (!mounted) {
        return;
      }
      if (initialized != controller.value.initialized) {
        initialized = controller.value.initialized;
        setState(() {});
      }
    };
    controller.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: widget.chewieController.keepVideoAspectRatio
              ? controller.value.aspectRatio
              : cropAspectRatio ?? controller.value.aspectRatio,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size?.width ?? 0,
              height: controller.value.size?.height ?? 0,
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
