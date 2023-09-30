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
          title: const Text('Plugin example app'),
        ),
        body: _buildBodyView(),
        bottomNavigationBar: BottomNavigationView(
          selectedAppRoute: _appRoute,
          onAppRouteSelected: (appRoute) {
            setState(() {
              _appRoute = appRoute;
            });
          },
        ),
      ),
    );
  }

  Widget _buildBodyView() {
    switch (_appRoute) {
      case AppRoute.videoPlayer:
        return const VideoPlayerScreenView();
      case AppRoute.videoList:
        return const VideoListScreenView();
    }
  }
}

class BottomNavigationView extends StatelessWidget {
  final AppRoute selectedAppRoute;
  final void Function(AppRoute) onAppRouteSelected;

  const BottomNavigationView({
    super.key,
    required this.selectedAppRoute,
    required this.onAppRouteSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
      currentIndex: selectedAppRoute.index,
      onTap: (index) => onAppRouteSelected(AppRoute.values[index]),
    );
  }
}
