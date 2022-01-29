import 'package:babyfs_music/common/music_store.dart';
import 'package:babyfs_music/common/personal_icons.dart';
// import 'package:babyfs_music/model/music_homelist_model.dart';
// import 'package:babyfs_music/model/music_lrc_manger.dart';
// import 'package:babyfs_music/model/music_song_list.dart';
import 'package:babyfs_music/pages/bottomBar/animation_bottom_bar.dart';
import 'package:babyfs_music/pages/bottomBar/animation_tablebar_icon.dart';
import 'package:babyfs_music/pages/setting/music_setting.dart';

import 'package:flutter/material.dart';

import 'home/music_home_page.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class MusicHomePage extends StatefulWidget {
  MusicHomePage({Key key}) : super(key: key);
  @override
  _MusicHomePageState createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  int _currrentIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currrentIndex,
        children: [
          MusicHomeListPage(),
          // MusicSettingPage(
          //   index: 0,
          // ),
          MusicSettingPage(
            index: 1,
          ),
          MusicSettingPage(
            index: 2,
          ),
          MusicSettingPage(
            index: 3,
          ),
        ],
      ),
      bottomNavigationBar: MusicAnimationBottomNavBar(
        selectPositoin: _currrentIndex,
        iconList: TableIconData.tableIconList,
        selectCallBack: (index) {
          setState(() {
            _currrentIndex = index;
          });
        },
      ),
    );
  }
}
