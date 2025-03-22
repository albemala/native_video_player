import 'package:flutter/material.dart';
import 'package:native_video_player_example/video-list-screen-view.dart';
import 'package:native_video_player_example/video-player-screen-view.dart';

enum AppRoute {
  videoPlayer,
  videoList,
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  var _appRoute = AppRoute.videoPlayer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Video Player Example'),
        ),
        body: BodyView(
          appRoute: _appRoute,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_display),
              label: 'Video Player',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_stream),
              label: 'Video List',
            ),
          ],
          currentIndex: _appRoute.index,
          onTap: (index) {
            setState(() {
              _appRoute = AppRoute.values[index];
            });
          },
        ),
      ),
    );
  }
}

class BodyView extends StatelessWidget {
  final AppRoute appRoute;

  const BodyView({
    super.key,
    required this.appRoute,
  });

  @override
  Widget build(BuildContext context) {
    switch (appRoute) {
      case AppRoute.videoPlayer:
        return const VideoPlayerScreenView();
      case AppRoute.videoList:
        return const VideoListScreenView();
    }
  }
}
