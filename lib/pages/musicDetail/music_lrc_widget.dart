import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:babyfs_music/model/music_lrc_manger.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:babyfs_music/model/music_lrc_manger.dart';
import 'package:provider/provider.dart';

class MusicLyricWidget extends CustomPainter with ChangeNotifier {
  List<MusicLrc> lyric; //歌词
  List<TextPainter> lyricPaints = []; // 其他歌词
  double maxWidth; //最大宽度
  int index; //歌词行数下标
  bool iscurrentLine;//是否是当前播放行
  bool isdragingLine;//是否是拖拽行
  double _offsetY = 0; //计算偏移量
  int _currentLine = 0; //用于标注当前行
  int _dragingLine = 0; //当前拖拽到的行
  Paint linePaint; //画笔
  bool _isDragging = false; //是否在人为拖动
  double totalHeight; //总高度
  TextPainter draggingLineTimeTextPainter; //正在拖动中的当前行的时间
  Size canvasSize = Size.zero; //画布大小
  int dragLineTime; //拖动时间？
  double lineMargin = 15;
  int _currentPosition;//当前歌词播放时间


//  double get offsetY = _offsetY;
//普通歌词样式
  TextStyle normalTextStyle =
      TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400);
//拖动状态
  TextStyle dragTextStyle = TextStyle(
      fontSize: 12, color: Colors.green[200], fontWeight: FontWeight.w400);
//高亮状态
  TextStyle hightLightTextStyle = TextStyle(
      fontSize: 12, color: Colors.red[200], fontWeight: FontWeight.w400);
//时间显示样式
  TextStyle smallTextStyle =
      TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.w500);

  get currentLine => _currentLine;
  get offsetY => _offsetY;
  get dragingLine => _dragingLine;
  get isDragging => _isDragging;
  get currentPosition =>_currentPosition;


  //设置当前行，发通知
  set currentLine(int line) {
    if (_isDragging) {
      return;
    }
    if (line < lyric.length && line >= 0) {
      _currentLine = line;
      // notifyListeners();
    }
  }

//设置当前偏移量，并发出通知
  set offsetY(double value) {
    _offsetY = value;
    notifyListeners();
  }

  set dragingLine(value) {
    _dragingLine = value;
    // notifyListeners();
  }

  set isDragging(value) {
    _isDragging = value;
    // notifyListeners();
  }
  set currentPosition(value){
    _currentPosition = value;
  }

  MusicLyricWidget(this.lyric, {this.maxWidth,this.index}) {
    if (lyric != null) {
      linePaint = Paint()
        //语法糖 等同于 linePaint.color = Colors.white;
        ..color = Colors.green[100]
        ..strokeWidth = 0.5;

      lyricPaints.addAll(lyric
          .map((lrc) => TextPainter(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: lrc.enlyric,
                style: normalTextStyle,
              ),
              textDirection: TextDirection.ltr)
            ..layout(maxWidth: maxWidth))
          .toList());
    }
  }

  //绘制，画布和size
  @override
  void paint(Canvas canvas, Size size) {
    if (lyric.length > 0) {
      canvasSize = size;
      // var y = _offsetY + size.height / 2 - lyricPaints[currentLine].height / 2;

      
      //仅绘制在屏幕内哦1
      // for (int i = 0; i < lyricPaints.length; i++) {
        var currentLyric = lyric[index];
        // bool iscurrentLine = _currentLine == i;
        // bool isdragingLine = (_dragingLine == i && _isDragging==true);
        var currentPainter = lyricPaints[index];
        currentPainter.text = TextSpan(
            text: currentLyric.enlyric,
            style: iscurrentLine
                ? hightLightTextStyle
                : isdragingLine ? dragTextStyle : normalTextStyle);
        //设置约束
        currentPainter.layout(maxWidth: size.width);
        currentPainter
            ..paint(canvas, Offset((size.width - currentPainter.width) / 2, 0));

        // var currentLyricHeight = currentPainter.height;
        //底部预留50的距离防止超出显示区域
        // if (y >= 0 && y <= (size.height - 50)) {
          
        // }
        
        // //当前歌词调整约束后设置下行歌词开始的坐标,只设置一次，防止重复设置页面错乱
        // if(currentLyric.offset == null){
        //     currentLyric.offset = y;
        // }
        // y += currentLyricHeight + lineMargin;
      // }
    }

  }

  //计算传入行与第一行的偏移量
  double calculateCurrentLineOffsetY(int currentLine) {
    double totalHeight = 0;
    for (var i = 0; i < currentLine; i++) {
      var currPaint = lyricPaints[i]
        ..text = TextSpan(text: lyric[i].enlyric, style: normalTextStyle);
      currPaint.layout(maxWidth: maxWidth);
      totalHeight += currPaint.height + lineMargin;
    }
    return totalHeight;
  }



  @override
  bool shouldRepaint(MusicLyricWidget oldDelegate) {
    
        //拖动状态下，歌曲自动播放改变当前歌词行数的时候不重新绘制，防止页面卡顿
       
    return oldDelegate.currentLine != _currentLine;
  }
}
