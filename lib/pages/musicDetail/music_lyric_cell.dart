import 'package:babyfs_music/model/music_lrc_manger.dart';
import 'package:flutter/material.dart';

class MusicLyricCell extends StatefulWidget {
  const MusicLyricCell({ 
    Key key,
    this.index,
    this.iscurrentLine,
    this.isdragingLine,
    this.musicLyricModel,
    this.currentLine,
    this.dragLine
    }) : super(key: key);

  final int index; //歌词行数下标
  final int currentLine;//当前歌曲播放到第几行
  final int dragLine;//当前歌曲拖拽到第几行
  final bool iscurrentLine;//是否是当前播放行
  final bool isdragingLine;//是否是拖拽行
  final MusicLrc musicLyricModel;//歌词每一行的数据
  @override
  _MusicLyricCellState createState() => _MusicLyricCellState();
}

class _MusicLyricCellState extends State<MusicLyricCell> {

  //普通歌词样式
  TextStyle normalTextStyle =
      TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400);
//拖动状态
  TextStyle dragTextStyle = TextStyle(
      fontSize: 12, color: Colors.green[200], fontWeight: FontWeight.w400);
//高亮状态
  TextStyle hightLightTextStyle = TextStyle(
      fontSize: 12, color: Colors.red[200], fontWeight: FontWeight.w400);

  @override
  Widget build(BuildContext context) {

    bool iscurrentLine = widget.index == widget.currentLine;
    bool isdragLine = widget.index == widget.dragLine;
    return Container(
      // padding: widget.index==0?EdgeInsets.only(top: 0,bottom: 0):EdgeInsets.only(top: 0,bottom: 0),
      // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      child: Center(
        child: Text(
                   widget.musicLyricModel.enlyric,
                   textAlign:TextAlign.center,
                  style:iscurrentLine
                      ? hightLightTextStyle
                      : isdragLine ? dragTextStyle : normalTextStyle),
      ), 
    );
  }
}