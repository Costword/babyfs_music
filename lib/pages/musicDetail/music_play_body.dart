import 'package:babyfs_music/model/music_play_list_manger.dart';
import 'package:babyfs_music/pages/musicDetail/music_lrc_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

typedef GestureTapCallback = void Function();

class MusicPlayBodyWidget extends StatefulWidget {
  const MusicPlayBodyWidget({
     Key key ,
     this.animationController,
     }) : super(key: key);
  final AnimationController animationController;
  @override
  _MusicPlayBodyWidgetState createState() => _MusicPlayBodyWidgetState();
}

//SingleTickerProviderStateMixin 垂直同步，用于动画中获取屏幕刷新率
class _MusicPlayBodyWidgetState extends State<MusicPlayBodyWidget> with SingleTickerProviderStateMixin{

  int indexPage = 0;//用于切换歌词
  MusciLyricPage _musciLyricPage;

  @override
  void initState() {
    ///初始化播放详情页
    ///播放详情页可分为三部分，
    ///1头部导航组件，包括返回键，标题，分享等
    ///2旋转动画部分，有音乐海报，歌词，其中海报可旋转播放暂停时停止旋转
    ///3底部控制部分，进度条，  关注，评价，下载，更多    播放顺序，上一曲，下一曲，暂停/开始 播放列表
    ///
    print('切换显示模式重新加载页面');
    _musciLyricPage =  _lyricBord();
    super.initState();
  }

  @override
  void dispose() {
    _musciLyricPage = null;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          if(indexPage==0){
            indexPage = 1;
          }else{
            indexPage = 0;
          }
        });
      },
      child: IndexedStack(
        index: indexPage,
        children: <Widget>[
          _animationBg(),
          _musciLyricPage
        ],
      )
    );
  }


//海报动画背景
  Widget _animationBg(){
    return Padding(
      padding: EdgeInsets.only(top: 80),
      child: RotationTransition(
        turns: widget.animationController,
        child: Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: CachedNetworkImage(
              imageUrl:MusicPlayListManger.of(context).currentItem!=null?MusicPlayListManger.of(context).currentItem.coverPicUrl:"",
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150),
                    image: DecorationImage(image: imageProvider),
                    color: Colors.white
                  ),
                );
              },
              placeholder: (context, url) {
                return Image.asset('images/music_control/children_song_poster_default@2x.png');
              },
              ),
          ),
        ),
      ),
    );
  }

//歌词列表
  Widget _lyricBord (){
    return MusciLyricPage(songItemModel: MusicPlayListManger.of(context).currentItem,);
  }
}