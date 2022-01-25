import 'music_item_model.dart';

class MusicPlayListModel{
  List<MusicItemModel>  playList; 

  MusicPlayListModel(
    this.playList,
  );

  factory MusicPlayListModel.fromJson(Map<String,dynamic> json){

    var jsonArray = json['items'] as List;

    List<MusicItemModel> list = jsonArray.map((e) => MusicItemModel.fromJson(e)).toList();
    
    return MusicPlayListModel(list);
  }
}

