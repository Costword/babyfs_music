//歌词显示页面
import 'package:babyfs_music/model/music_item_model.dart';
import 'dart:async';
import 'package:babyfs_music/model/music_lrc_manger.dart';
import 'package:babyfs_music/model/music_play_list_manger.dart';
import 'package:babyfs_music/model/music_song_list.dart';
import 'package:babyfs_music/pages/musicDetail/music_lrc_widget.dart';
import 'package:babyfs_music/pages/musicDetail/music_lyric_cell.dart';
import 'package:babyfs_music/pages/musicDetail/music_paging_scrollPhysics.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rect_getter/rect_getter.dart';


const double PADDING_TOP = 200;//listview的初始padding
const double ITEM_HEIGHT = 50;//listview的item高度
const double PLAY_SIZE = 15;//标记位置的播放按钮大小

class MusciLyricPage extends StatefulWidget {
  MusciLyricPage({Key key, this.songItemModel}) : super(key: key);

  final SongItemModel songItemModel;
  @override
  _MusciLyricPageState createState() => _MusciLyricPageState();
}

class _MusciLyricPageState extends State<MusciLyricPage>
    with TickerProviderStateMixin {
//当前播放歌曲的歌词数组
  List<MusicLrc> lyrics;
  Timer draggingTimer; //歌词拖动到确认跳转/取消的缓冲时间计时器
  bool _isDragging = false; //当前是否是拖动状态
  Duration draggingProgress = Duration(seconds: 8); //歌词拖动到确认跳转/取消的缓冲时间，默认固定8s
  double progress; //当前歌曲播放的进度

  int _currentdraggingLineStartTime = 0; //当前拖动行的开始时间
  double _maxWidth;
  double _maxHeight;//歌词的最大高度
  int _dragLine; //当前歌词拖拽的第几行
  int _currentLine; //当前歌词播放的第几行
  ScrollController _lyricScrollController;
  GlobalKey listViewKey = RectGetter.createGlobalKey();//用于标记listview的item
  Map _keys;
  @override
  void initState() {
    //初始化歌词和画布
    lyrics = MusicLrc.formatLyric(widget.songItemModel.lyrics);
    _lyricScrollController = ScrollController();
    _keys = {};
    Future.delayed(Duration(seconds: 1),(){
      //延迟1秒，获取歌词列表的rect
      getVisible();
    });
    super.initState();
  }

  @override
  void dispose() {
    _lyricScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//自定义view
    return Padding(
        padding: const EdgeInsets.only(top: 0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            _maxWidth = constraints.maxWidth;
            _maxHeight =  lyrics.length * 51.0;
            return Container(
                // color: Colors.pink,
                child: lyrics == null
                    ? Text('当前暂无歌词')
                    : StreamBuilder(
                        stream: MusicPlayListManger.of(context)
                            .currentSongPositionStream,
                        builder: (context, snapshot) {
                          //自定义view   canvas：画布  paint：画笔
                          if (snapshot.data != null) {
                            int posiontime = int.parse(snapshot.data);
                            if (posiontime >= 0) {
                              progress = double.parse(snapshot.data);
                              var playIndex =
                                  MusicLrc.findLyricIndex(progress, lyrics);
                              if (_currentLine != playIndex) {
                                _currentLine = playIndex;
                                jumpTo(_currentLine);
                              }
                            }
                          }
                          return Stack(
                            children: <Widget>[
                              NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification notification) {
                                  if (notification is ScrollStartNotification) {
                                    //滚动开始
                                    getVisible();
                                  }
                                  if (notification
                                      is ScrollUpdateNotification) {
                                    //滚动中
                                    if(_isDragging){
                                      double currentLine = (notification.metrics.pixels )/ITEM_HEIGHT;
                                      int targetLine  =  currentLine.roundToDouble().toInt();
                                    if(targetLine>0){
                                       _dragLine = targetLine;
                                      _currentdraggingLineStartTime = int.parse("${lyrics[_dragLine].startTime.inMilliseconds}"); 
                                    }
                                    }
                                  }
                                  if (notification is ScrollEndNotification) {
                                    //滚动结束
                                    _isDragging = false;
                                    cancelTimer();
                                    draggingTimer = Timer(draggingProgress, () {
                                      resetDragging();
                                    });
                                  }
                                  if (notification is UserScrollNotification) {
                                    //用户主动滚动  手动
                                    _isDragging = true;
                                    //只是为了重新构建streambuilder刷新使用，不改变其他参数
                                    MusicPlayListManger.of(context)
                                        .updateCurrentSongPosion(-1);
                                  }
                                  //向上传递冒泡通知
                                  return true;
                                },
                                child: RectGetter(
                                    key: listViewKey,
                                    child: ListView.builder(
                                        padding: EdgeInsets.only(top: PADDING_TOP),
                                        itemCount: lyrics.length,
                                        controller: _lyricScrollController,
                                        cacheExtent: 2000,
                                        scrollDirection: Axis.vertical,
                                        itemExtent: ITEM_HEIGHT,
                                        physics: PagingScrollPhysics(
                                          itemHeight: ITEM_HEIGHT,
                                          paddingSpacing: PADDING_TOP,
                                          maxSize: _maxHeight
                                        ),
                                        itemBuilder: (context, index) {
                                          //分配globkey
                                          _keys[index] =
                                              RectGetter.createGlobalKey();
                                          return MusicLyricCell(
                                            key: _keys[index],
                                            index: index,
                                            currentLine: _currentLine,
                                            dragLine: _dragLine,
                                            musicLyricModel: lyrics[index],
                                          );
                                        })),
                              ),
                              Visibility(
                                  visible: _isDragging,
                                  child: creatLine(_maxWidth))
                            ],
                          );
                        },
                      ));
          },
        ));
  }

//绘制中心显示的指示线
  Widget creatLine(maxWidth) {

    const double _paddingTop = PADDING_TOP + ((ITEM_HEIGHT-PLAY_SIZE)/2);
    return Padding(
      padding: const EdgeInsets.only(top:_paddingTop),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            Icons.play_arrow,
            color: Colors.grey,
            size: PLAY_SIZE,
          ),
          Container(
            width: _maxWidth-(PLAY_SIZE  + 40 + 10),
            height: 0.5,
            color: Colors.grey,
          ),
          Container(
            padding: EdgeInsets.only(right: 10),
            width: 40,
            child: Text(
            DateUtil.formatDateMs(_currentdraggingLineStartTime,
                format: 'mm:ss'),
            style: TextStyle(color: Colors.grey, fontSize: 8),
          ),
          )
        ],
      ),
    );
  }

  //重置拖动属性
  resetDragging() {
    _isDragging = false;
    _dragLine = null;
    //只是为了重新构建streambuilder刷新使用，不改变其他参数
    MusicPlayListManger.of(context).updateCurrentSongPosion(-1);
  }

  //清空计时器
  void cancelTimer() {
    if (draggingTimer != null) {
      if (draggingTimer.isActive) {
        draggingTimer.cancel();
        draggingTimer = null;
      }
    }
  }

  List<int> getVisible() {
    /// 先获取整个ListView的rect信息，然后遍历map
    /// 利用map中的key获取每个item的rect,如果该rect与ListView的rect存在交集
    /// 则将对应的index加入到返回的index集合中
    var rect = RectGetter.getRectFromKey(listViewKey);
    var _items = <int>[];
    _keys.forEach((index, key) {
      var itemRect = RectGetter.getRectFromKey(key);
      if(itemRect != null){
        //只赋值一次
        if(lyrics[index].lyricRect == null){
          lyrics[index].lyricRect  = itemRect;
        }
      }
      if (itemRect != null &&
          !(itemRect.top > rect.bottom || itemRect.bottom < rect.top))
        _items.add(index);
    });

// 300 351 第一个
    print('赋值完成后的歌词信息$lyrics');
    /// 这个集合中存的就是当前处于显示状态的所有item的index
    return _items;
  }

  void scrollLoop(int target, Rect listRect) {
    var first = getVisible().first;
    bool direction = first < target;
    Rect _rect;
    if (_keys.containsKey(target))
      _rect = RectGetter.getRectFromKey(_keys[target]);
    if (_rect == null ||
        (direction
            ? _rect.bottom < listRect.top
            : _rect.top > listRect.bottom)) {
      var offset = _lyricScrollController.offset +
          (direction ? listRect.height / 2 : -listRect.height / 2);
      offset = offset < 0.0 ? 0.0 : offset;
      offset = offset > _lyricScrollController.position.maxScrollExtent
          ? _lyricScrollController.position.maxScrollExtent
          : offset;
      _lyricScrollController.animateTo(offset,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
      Timer(Duration.zero, () {
        scrollLoop(target, listRect);
      });
      return;
    }
    _lyricScrollController.animateTo(
        _lyricScrollController.offset + _rect.top - listRect.top,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease);
  }

  void jumpTo(int target) {
    // var visible = getVisible();
    // // if (visible.contains(target)) return;
    // var listRect = RectGetter.getRectFromKey(listViewKey);
    // scrollLoop(target, listRect);
    _dragLine = null;
    _isDragging = false;
    MusicLrc currentLyric = lyrics[target];
    if(currentLyric.lyricRect !=null){
      _lyricScrollController.animateTo(currentLyric.lyricRect.top - 400, duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

}
