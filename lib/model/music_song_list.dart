import 'package:babyfs_music/model/music_lrc_manger.dart';

import 'music_item_model.dart';

class MusicSongListModel{
  List<SongItemModel>  songList; 

  MusicSongListModel(
    this.songList
  );

  factory MusicSongListModel.fromJson(List<dynamic> json){

    var jsonArray = json;

    // var lrc = jsonArray[0]["lyrics"];
    
    // List<MusicLrc> lrclist =   MusicLrc.formatLyric(lrc);
    // print(lrc);

    List<SongItemModel> list = jsonArray.map((e) => SongItemModel.fromJson(e)).toList();
    
    return MusicSongListModel(list);
  }
}

class SongItemModel{

//   0:"audioUrl" -> "http://ap.s.babyfs.cn/fc9028d9a0891b1034dafe42d2dac6855141b98e.mp3?e=1641841449&token=AyS1gYvZtmwvi9Jr1hCznQgxtYHlfL1B3Cn0eR-L:Z…"
// 1:"chineseName" -> "哒扣哒扣哒"
// 2:"collect" -> false
// 3:"coverPicUrl" -> "http://i.s.babyfs.cn/912a9d1a6b894a07bbf5a4039789d4c3.jpg"
// 4:"description" -> ""
// 5:"durationTime" -> 69.36
// 6:"englishName" -> "Dickory Dickory Dare"
// 7:"hashPermission" -> false
// 8:"id" -> 9
// 9:"lyrics" -> "[00:00.916]Dickory Dickory Dare \n哒扣哒扣哒
// [00:12.430]Dickory dickory dare \n哒扣哒扣哒
// [00:14.828]The pig flew up in the air \n猪飞到了天上
// […"
// 10:"materialId" -> 10282516
  int id;//歌曲ID
  bool collect;//是否收藏
  double durationTime;//时长
  bool hashPermission;//
  int materialId;//未知ID
  

  String audioUrl;//播放链接
  String chineseName;//中文名
  String coverPicUrl;//海报地址
  String description;//描述
  String englishName;//英文名
  String lyrics;//歌词

  SongItemModel(
      this.id,
      this.collect,
      this.durationTime,
      this.hashPermission,
      this.materialId,
      this.audioUrl,
      this.chineseName,
      this.coverPicUrl,
      this.description,
      this.englishName,
      this.lyrics,
      );

  factory SongItemModel.fromJson(Map<String, dynamic> json) =>
      SongItemModel(
        json['id'],
        json['collect'],
        json['durationTime'],
        json['hashPermission'],
        json['materialId'],
        json['audioUrl'],
        json['chineseName'],
        json['coverPicUrl'],
        json['description'],
        json['englishName'],
        json['lyrics'],
      );
}