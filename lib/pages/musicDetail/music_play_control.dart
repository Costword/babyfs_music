import 'package:babyfs_music/common/music_global.dart' as musicGlobal;
import 'package:babyfs_music/pages/musicDetail/music_button.dart';
import 'package:babyfs_music/pages/musicDetail/music_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef GestureTapCallback = void Function(bool select);

enum ControlTye {
  play_control_loop,
  play_control_play,
  play_control_last,
  play_control_next,
  play_control_list
}

class MusicPlayControl extends StatefulWidget {
  MusicPlayControl(
      {Key key,
      this.loopBtn,
      this.playBtn,
      this.lastBtn,
      this.nextBtn,
      this.listBtn,
      this.loopTapback,
      this.playTapback,
      this.lastTapback,
      this.nextTapback,
      this.listTapback})
      : super(key: key);

  final MusicButton loopBtn;
  final MusicButton playBtn;
  final MusicButton lastBtn;
  final MusicButton nextBtn;
  final MusicButton listBtn;

  final GestureTapCallback loopTapback;
  final GestureTapCallback playTapback;
  final GestureTapCallback lastTapback;
  final GestureTapCallback nextTapback;
  final GestureTapCallback listTapback;

  @override
  _MusicPlayControlState createState() => _MusicPlayControlState();
}

class _MusicPlayControlState extends State<MusicPlayControl> with TickerProviderStateMixin{
  //播放控制面板需要知道当前歌曲的播放状态，循环模式
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            left: musicGlobal.MusicGlobal.controlMargin,
            right: musicGlobal.MusicGlobal.controlMargin),
        height: 200,
        child: Column(
          children: <Widget>[
            MusicPlaySlider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _itemButton(ControlTye.play_control_loop),
                _itemButton(ControlTye.play_control_last),
                _itemButton(ControlTye.play_control_play),
                _itemButton(ControlTye.play_control_next),
                _itemButton(ControlTye.play_control_list),
              ],
            ),
          ],
        ));
  }

  MusicButton _itemButton(ControlTye type) {
    switch (type) {
      case ControlTye.play_control_loop:
        {
          return MusicButton(
            normalImgPath: 'images/music_control/children_song_all_loop@2x.png',
            selectImgPath:
                'images/music_control/children_song_single_loop@2x.png',
            onTap: (select) {
              widget.loopTapback(select);
            },
          );
        }
      case ControlTye.play_control_play:
        {
          return MusicButton(
            normalImgPath: 'images/music_control/children_song_play@2x.png',
            selectImgPath: 'images/music_control/children_song_pause@2x.png',
            size: 40,
            onTap: (select) {
              widget.playTapback(select);
            },
          );
        }
      case ControlTye.play_control_last:
        {
          return MusicButton(
            normalImgPath: 'images/music_control/music_previous@2x.png',
            onTap: (select) {
              widget.lastTapback(select);
            },
          );
        }
      case ControlTye.play_control_next:
        {
          return MusicButton(
            normalImgPath: 'images/music_control/music_next@2x.png',
            onTap: (select) {
              widget.nextTapback(select);
            },
          );
        }
      case ControlTye.play_control_list:
        {
          return MusicButton(
            normalImgPath: 'images/music_control/children_song_list@2x.png',
            onTap: (select) {
              widget.listTapback(select);
            },
          );
        }
    }
  }
}
