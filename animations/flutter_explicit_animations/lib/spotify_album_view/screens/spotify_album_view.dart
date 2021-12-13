import 'package:chattalk_explicit_animations/spotify_album_view/components/album_info.dart';
import 'package:chattalk_explicit_animations/spotify_album_view/components/album_songs_list.dart';
import 'package:chattalk_explicit_animations/spotify_album_view/components/play_paus_button.dart';
import 'package:chattalk_explicit_animations/spotify_album_view/components/sliver_custom_appbar.dart';
import 'package:chattalk_explicit_animations/spotify_album_view/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SpotifyAlbumView extends StatefulWidget {
  const SpotifyAlbumView({Key? key}) : super(key: key);

  @override
  _SpotifyAlbumViewState createState() => _SpotifyAlbumViewState();
}

class _SpotifyAlbumViewState extends State<SpotifyAlbumView> {
  late ScrollController _scrollController;

  late double maxAppBarHeight;
  late double minAppBarHeight;
  late double playPauseButtonSize;
  late double infoBoxHeight;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    maxAppBarHeight = MediaQuery.of(context).size.height * 0.5;
    minAppBarHeight = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).size.height * 0.1;
    playPauseButtonSize = (MediaQuery.of(context).size.width / 320) * 50 > 80
        ? 80
        : (MediaQuery.of(context).size.width / 320) * 50;
    infoBoxHeight = 180;
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                kPrimaryColor,
                Colors.black,
              ],
              stops: [
                0,
                0.7
              ]),
        ),
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverCustomeAppBar(
                  maxAppBarHeight: maxAppBarHeight,
                  minAppBarHeight: minAppBarHeight,
                ),
                AlbumInfo(infoBoxHeight: infoBoxHeight),
                const AlbumSongsList(),
              ],
            ),
            PlayPauseButton(
              scrollController: _scrollController,
              maxAppBarHeight: maxAppBarHeight,
              minAppBarHeight: minAppBarHeight,
              playPauseButtonSize: playPauseButtonSize,
              infoBoxHeight: infoBoxHeight,
            ),
          ],
        ),
      ),
    );
  }
}
