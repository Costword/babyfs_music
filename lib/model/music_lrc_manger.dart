//解析歌词分类
//歌词需要根据时间来滚动
import 'package:flutter/material.dart';

class MusicLrc {
  String alllyric;
  String enlyric; //英文
  String cnlyric; //中文
  Duration startTime;
  Duration endTime;
  Rect lyricRect; //当前歌词的高度
  

  MusicLrc({this.alllyric,this.enlyric, this.cnlyric, this.startTime, this.endTime});
  @override
  String toString() {
    return 'MusicLrc{enlyric:$enlyric,cnlyric:$cnlyric ,startTime:$startTime ,endTime:$endTime}';
  }

/*
歌词文件格式如下：

[ti:一个人的北京]
[ar:好妹妹乐队]
[al:南北]
[by:]
[offset:0]
[00:00.10]一个人的北京 - 好妹妹乐队
[00:00.20]词：秦昊
[00:00.30]曲：秦昊
[00:00.40]
[00:30.16]你有多久没有看到 满天的繁星
[00:37.34]城市夜晚虚伪的光明 遮住你的眼睛
[00:44.40]连周末的电影 也变得不再有趣
[00:51.71]疲惫的日子里 有太多的问题
[00:59.21]
————————————————
版权声明：本文为CSDN博主「Flutter 笔记」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/qq_23756803/article/details/102814343
*/
  //解析歌词
//歌词标签都是有[] 包裹起来的，'ti'标题    'ar'歌手   'ai'专辑   'by'制作   'offect'时间偏移量   [mm:ss:ms]是一行歌词的时间

  static List<MusicLrc> formatLyric(String lyricStr) {
    //正则匹配所有带[]且中括号内有连续两个数字的内容
    RegExp reg = RegExp(r"^\[\d{2}");

//  先把歌词单独拆出每一行放入List中
    List<MusicLrc> result =
        lyricStr.split('\n').where((r) => reg.hasMatch(r)).map((e) {
//取出时间
      String time = e.substring(1, e.indexOf(']'));

//取出歌词
      String lyric = e.substring(e.indexOf(']') + 1);

      String split = '\\n';

      String enlyric;
      String cnlyric;
      //给空行补上。。。
      if(lyric ==""){
        lyric = '...';
        enlyric = lyric;
      }
      if (lyric.contains(split)) {
        enlyric = lyric.substring(0, lyric.indexOf(split) - 1);
        cnlyric = lyric.substring(lyric.indexOf(split) + 2);
        
        enlyric = enlyric + '\n' + cnlyric;
      }
      int hourSeparatoIndex = time.indexOf(':');
      int minuteSeparatoIndex = time.indexOf('.');
      return MusicLrc(
          alllyric: lyric,
          enlyric: enlyric,
          cnlyric: cnlyric,
          startTime: Duration(
              minutes: int.parse(
                time.substring(0, hourSeparatoIndex),
              ),
              seconds: int.parse(
                time.substring(hourSeparatoIndex + 1, minuteSeparatoIndex),
              ),
              milliseconds: int.parse(time.substring(minuteSeparatoIndex + 1))),
          endTime: null);
    }).toList();

    //遍历数据，每一段歌词的结束时间等于下一段歌词的开始时间
    for (int i = 0; i < result.length - 1; i++) {
      result[i].endTime = result[i + 1].startTime;
    }
    
    /*空行暂时不去除*/
    //移除所有的空行,注意，此处的alllyric一定不能为null 否则会报错
    // result.removeWhere((lyric) => lyric.alllyric.trim().isEmpty);

    //最后一段歌词的结束时间设置为很大，方便结尾处于高亮状态
    result[result.length - 1].endTime = Duration(hours: 1);
    return result;
  }


  //计算出当前时间在歌词的第几行
static  int findLyricIndex(double currentPosition, List<MusicLrc> lyrics) {
    for (int i = 0; i < lyrics.length; i++) {
      var startTime = lyrics[i].startTime.inMilliseconds;
      var endTime = lyrics[i].endTime.inMilliseconds;
      
      if (currentPosition >= startTime && currentPosition <= endTime) {
        return i;
      }
    }
    return 0;
  }
}
