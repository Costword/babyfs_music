import 'package:babyfs_music/common/music_global.dart';
import 'package:babyfs_music/common/music_store.dart';
import 'package:babyfs_music/common/theme_state.dart';
import 'package:babyfs_music/model/music_play_list_manger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MusicPlaySlider extends StatefulWidget {
  MusicPlaySlider({Key key}) : super(key: key);
//进度条包含进度和时间
  @override
  _MusicPlaySliderState createState() => _MusicPlaySliderState();
}

class _MusicPlaySliderState extends State<MusicPlaySlider> with TickerProviderStateMixin{
  double changevalue = 0.0;
  bool startSlider = false;//手动拖动进度条事件
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: MusicGlobal.controlMargin,right: MusicGlobal.controlMargin),
      child: Column(
        children: <Widget>[
         _item(context),
         _slider(context),
        ],
      ),
    );
  }

  _item(context){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Selector<MusicPlayListManger,String>(
            builder: (context,positionText,_){
              return Text(positionText,style: TextStyle(color: Colors.grey,fontSize: 12),);
            },
             selector: (context,state){
               return state.positionText;
             },
             shouldRebuild: (pre,next){
               print("监听到播放进度改变前后两个值分别是 $pre 和 $next");
               return pre != next;
             },
            ),
            Selector<MusicPlayListManger,String>(
              //取到监听值，然后构建
            builder: (context,durationText,_){
              return Text(durationText,style: TextStyle(color: Colors.grey,fontSize: 12),);
            },
            //取出所需要监听的值
             selector: (context,state){
               return state.durationText;
             },
             shouldRebuild: (pre,next){
               print("监听到播放进度改变前后两个值分别是 $pre 和 $next");
               return pre != next;
             },
            ),

        ],
      )
    );
  }

  _slider(content){
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor:ThemeState.of(context).SliderActivityColor,//拖动部分的颜色
        inactiveTrackColor:ThemeState.of(context).SliderNormalColor,//未拖动部分的颜色
        activeTickMarkColor: ThemeState.of(context).IconColor,
        inactiveTickMarkColor: Colors.green,
        trackHeight: 5,//进度条高度
        thumbColor: Colors.orange,//小球颜色
        overlayColor: Colors.purple[50],//小球外部环绕光圈颜色
        overlayShape:RoundSliderOverlayShape(//可继承SliderComponentShape自定义形状
        //外部小球外部环绕光圈大小
          overlayRadius:10
        ),
        thumbShape: RoundSliderThumbShape(//可继承SliderComponentShape自定义形状
        //小球内部实心圆大小
          disabledThumbRadius: 6,
          enabledThumbRadius: 6,
        )
      ), 
      child: Selector<MusicPlayListManger,double>(
        builder: (content,progress,_){

          if(startSlider == false){
            changevalue = progress;
          }
          return Slider(
            value: changevalue, 
            onChangeStart: (double value){
              startSlider = true;
            },
            onChanged: (double value){
              setState(() {
                changevalue = value;
              });
          },
          onChangeEnd: (double value){
            MusicPlayListManger.of(context).music_seek(value);
            startSlider =false;
          },
          );
        },
         selector: (content,state){
           return state.playProgress;
         },
         shouldRebuild: (pre,next){
           return pre != next;
         },
        )
    );
  }
}