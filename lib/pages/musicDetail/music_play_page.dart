import 'package:audioplayers/audioplayers.dart';
import 'package:babyfs_music/common/music_store.dart';
import 'package:babyfs_music/model/music_play_list_manger.dart';
import 'package:babyfs_music/model/music_song_list.dart';
import 'package:babyfs_music/pages/musicDetail/music_app_bar.dart';
import 'package:babyfs_music/pages/musicDetail/music_play_body.dart';
import 'package:babyfs_music/pages/musicDetail/music_play_control.dart';
import 'package:flutter/material.dart';

class MusicPlayPage extends StatefulWidget {
  MusicPlayPage(
      {Key key,
      this.appBar,
      this.musicBody,
      this.bottomControl,
      this.songListModel})
      : super(key: key);
  final MusicAppBar appBar; //头部导航
  final Widget musicBody; //中间组件
  final Widget bottomControl; //底部控制栏
  final MusicSongListModel songListModel;
  @override
  _MusicPlayPageState createState() => _MusicPlayPageState();
}

//开启垂直同步，由于不同的设备拥有不同的屏幕刷新率 TickerProviderStateMixin 只有在TickerProvider 下才能配置AnimationController用于控制动画的播放，停止等动作
//如果整个生命周期中只有一个AnimationController，使用SingleTickerProviderStateMixin 比较高效，如果有多个则使用TickerProviderStateMixin
class _MusicPlayPageState extends State<MusicPlayPage>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(seconds: 25), vsync: this);
    MusicPlayListManger.of(context).updatePlayList(widget.songListModel, 0);
    if (MusicPlayListManger.of(context).audioPlayState ==
        PlayerState.PAUSED) {
      _animationController.stop();
    } else {
      _animationController.repeat();
    }
    super.initState();
  }

  @override
  void dispose() {
    print('释放播放详情页面');
    _animationController.dispose();
    // MusicPlayListManger.of(context).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return //背景图片
        Stack(
      children: <Widget>[
        Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "images/music_control/children_song_play_bg@2x.png",
              fit: BoxFit.cover,
            )),
        Scaffold(
            // backgroundColor: MusicStroe.Theme(context).theme,
            appBar: MusicAppBar(
              title: MusicPlayListManger.of(context).currentItem.chineseName,
              leftIcon: Icons.arrow_back_ios,
              rightIcon: Icons.star_border,
              leftOnTap: () {
                print("点击返回事件");
                MusicPlayListManger.of(context).music_stop();
                Navigator.of(context).pop();
              },
            ),
            body: GestureDetector(onTap: () {
              //用来切换焦点，隐藏软键盘
              FocusScope.of(context).requestFocus(FocusNode());
            }, child: LayoutBuilder(
              builder: (context, constraints) {
                double buildersizeH = constraints.maxHeight;
                return Stack(
                  children: <Widget>[
                    //歌词，海报部分
                    Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: double.infinity,
                          height: buildersizeH - 150,
                          child: MusicPlayBodyWidget(
                              animationController: _animationController),
                        )),
                    //下方的控制面板
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        child: MusicPlayControl(
                          loopTapback: (select) {
                            print("点击改变循环模式");
                          },
                          playTapback: (select) {
                            if (select == true) {
                              MusicPlayListManger.of(context).music_pause();
                              _animationController.stop();
                            } else {
                              MusicPlayListManger.of(context).music_resum();
                              _animationController.repeat();
                            }
                            print("点击暂停或者播放$select");
                            // if (select == true) {
                            //   _animationController.repeat();
                            // } else {
                            //   _animationController.stop();
                            // }
                          },
                          lastTapback: (select) {
                            print("点击上一曲");
                          },
                          nextTapback: (select) {
                            print("点击下一曲");
                          },
                          listTapback: (select) {
                            print("展开列表");
                          },
                        ),
                      ),
                    )
                  ],
                );
              },
            )))
      ],
    );
  }
}
