import 'package:babyfs_music/model/music_song_list.dart';
import 'package:babyfs_music/pages/musicDetail/music_play_page.dart';
import 'package:babyfs_music/pages/musicHomePage.dart';
import 'package:babyfs_music/pages/setting/music_setting.dart';
import 'package:babyfs_music/router/custom_router.dart';
import 'package:flutter/material.dart';
import 'router_page_name.dart';
class MusicRouter {
  //初始路由 进入app默认页面
  static final String initialRoute = RouterPageName.MusicHomePage;

  //路由集合
  static final Map <String,WidgetBuilder> routers = {
    RouterPageName.MusicHomePage:(context) => MusicHomePage(),
    RouterPageName.MusicPlayPage:(context) => MusicPlayPage(),
    RouterPageName.MusicSettingPage:(context) => MusicSettingPage(),
  };

//设置跳转动画
  static const opacityCurve = const Interval(0, 0.75,curve: Curves.fastOutSlowIn);

  
  static final RouteFactory generateRoute = (settings) {

    final String name = settings.name;

    final Function pageContetBuilder = routers[name];

    if (pageContetBuilder !=null){

      //音乐类型首页
      if (name == RouterPageName.MusicHomePage){

        // return CustomPageRouter(MusicHomePage());
        return MaterialPageRoute(
          settings: RouteSettings(name: name),
          builder: (context){
            return   MusicHomePage();
          }
        );
      }

      //音乐播放页面
      if (name == RouterPageName.MusicPlayPage){
        if(settings.arguments != null){
          MusicSongListModel songListModel = settings.arguments;

          return CustomPageRouter(MusicPlayPage(songListModel: songListModel,));

        //   return MaterialPageRoute(
        //   settings: RouteSettings(
        //     name: name,
        //     ),
        //   builder: (context){
        //     print('即将跳转的页面是$name');
        //     return MusicPlayPage(
        //       songListModel: songListModel,
        //     );
        //   }
        // );
        }else{
          return MaterialPageRoute(
          settings: RouteSettings(
            name: name,
            ),
          builder: (context){
            print('即将跳转的页面是$name');
            return MusicPlayPage();
          }
        );
        }
        
      }
    //设置页面
      if(name == RouterPageName.MusicSettingPage){
        return MaterialPageRoute(
          settings: RouteSettings(name: name),
          builder: (context){
            return MusicSettingPage();
          }
        );
      }
    }
    return null;
  };

}