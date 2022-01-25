class MusicHomeList {
  int page;
  int totalCount;
  int totalPage;
  int limit;

  List<MusicHomeListItem> items;

  MusicHomeList(
      this.page,
      this.totalCount,
      this.totalPage,
      this.limit,
      this.items,
      );
  factory MusicHomeList.fromJson(Map<String, dynamic> json) {

    var itemsJson = json['items'] as List;
    List<MusicHomeListItem> itemsList =
    itemsJson.map((e) => MusicHomeListItem.fromJson(e)).toList();
      return MusicHomeList(
        json['page'],
        json['totalCount'],
        json['totalPage'],
        json['limit'],
        itemsList
        );
  }
}

class MusicHomeListItem{

  int id;
  int hot;
  int createTime;
  int libraryDataType;
  int particularsCount;

  String name;//名称
  String nameEn;//英文名
  String url;//封面地址

  MusicHomeListItem(
      this.id,
      this.hot,
      this.createTime,
      this.libraryDataType,
      this.particularsCount,
      this.name,
      this.nameEn,
      this.url
      );

  factory MusicHomeListItem.fromJson(Map<String, dynamic> json) =>
      MusicHomeListItem(
        json['id'],
        json['hot'],
        json['createTime'],
        json['libraryDataType'],
        json['particularsCount'],
        json['name'],
        json['nameEn'],
        json['url'],
      );
}