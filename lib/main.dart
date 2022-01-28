import 'package:babyfs_music/common/theme_state.dart';
import 'package:babyfs_music/model/music_play_list_manger.dart';
import 'package:babyfs_music/pages/musicHomePage.dart';
import 'package:babyfs_music/router/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //当页面需要监听多个ChangeNotifier时需要使用MultiProvider
    //放在此处的ChangeNotifier的状态监听作用域的范围是整个 MaterialApp 
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeState>(create: (_)=>ThemeState(),),
        ChangeNotifierProvider<MusicPlayListManger>(create: (_)=>MusicPlayListManger())
      ],
      child: Consumer<ThemeState>(
        builder: (context,state,widget){
          return MaterialApp(
            color: state.theme,
            initialRoute: MusicRouter.initialRoute,
            onGenerateRoute: MusicRouter.generateRoute,
            theme: ThemeData(primaryColor:state.theme),
            // home: MusicHomePage()
          );
        },
      )
    );
  }
}

