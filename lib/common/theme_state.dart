import 'package:babyfs_music/common/music_global.dart';
import 'package:babyfs_music/pages/musicDetail/music_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeState extends ChangeNotifier {
  

//是否是黑暗模式
  bool  get isDarkTheme =>  MusicGlobal.light==true ? false : true;
  
  Color _theme =  Colors.blue[200];
  
  Color get theme => _theme;

  Color get IconColor {
    if(isDarkTheme){
      return Colors.white;
    }
    return Colors.orange[200];
  }

  Color get IconSelectColor {
    if(isDarkTheme){
      return Colors.grey;
    }
    return Colors.red[200];
  }

  Color get TextColor {
    if(isDarkTheme){
      return Colors.white;  
    }
      return Colors.black;
  }

  Color get SliderActivityColor {
    if(isDarkTheme){
      return Colors.orange[200];  
    }
      return Colors.pink[200];
  }

   Color get SliderNormalColor {
    if(isDarkTheme){
      return Colors.white;
    }
    return Colors.grey[100];
  }
 
 static ThemeState of(context){
   //注册Provider关联ThemeState
        return Provider.of<ThemeState>(context,listen: false);
  }
}