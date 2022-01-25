class MusicItemModel{

  int id;
  int hot;
  int createTime;
  int libraryDataType;
  int particularsCount;
  List<dynamic> displayArea;

  String name;//名称
  String nameEn;//英文名
  String url;//封面地址

  MusicItemModel(
      this.id,
      this.hot,
      this.createTime,
      this.libraryDataType,
      this.particularsCount,
      this.name,
      this.nameEn,
      this.url,
      this.displayArea
      );

  factory MusicItemModel.fromJson(Map<String, dynamic> json) =>
      MusicItemModel(
        json['id'],
        json['hot'],
        json['createTime'],
        json['libraryDataType'],
        json['particularsCount'],
        json['name'],
        json['nameEn'],
        json['url'],
        json['displayArea']
      );

}

//音频文件
class MusicPlaySongList{

  int id;
  int hot;
  int createTime;
  int libraryDataType;
  int particularsCount;
  List<dynamic> displayArea;

  String name;//名称
  String nameEn;//英文名
  String url;//封面地址

  MusicPlaySongList(
      this.id,
      this.hot,
      this.createTime,
      this.libraryDataType,
      this.particularsCount,
      this.name,
      this.nameEn,
      this.url,
      this.displayArea
      );

  factory MusicPlaySongList.fromJson(Map<String, dynamic> json) =>
      MusicPlaySongList(
        json['id'],
        json['hot'],
        json['createTime'],
        json['libraryDataType'],
        json['particularsCount'],
        json['name'],
        json['nameEn'],
        json['url'],
        json['displayArea']
      );
}

