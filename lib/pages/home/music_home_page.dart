import 'package:babyfs_music/model/music_homelist_model.dart';
import 'package:babyfs_music/model/music_lrc_manger.dart';
import 'package:babyfs_music/model/music_song_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:babyfs_music/http/api.dart';
import 'package:babyfs_music/http/requstManger.dart';
import 'package:babyfs_music/model/music_play_list_model.dart';
import 'package:babyfs_music/router/router_page_name.dart';

class MusicHomeListPage extends StatefulWidget {
  MusicHomeListPage({Key key}) : super(key: key);

  @override
  State<MusicHomeListPage> createState() => _MusicHomeListPageState();
}

class _MusicHomeListPageState extends State<MusicHomeListPage> {
  MusicHomeList _homeList;
  MusicSongListModel _songListModel;
  MusicLrc _lrcmanger;

  @override
  void initState() {
    requstHomePage().then((value) => _homeList);
    super.initState();
  }

  //获取首页列表数据
  Future<MusicHomeList> requstHomePage() async {
    var musicList = await DioClient.instance.get<MusicHomeList>(
        Api.kLibraryListSearchPath,
        queryParameters: {
          "dataType": "64",
          "page_size": "9999",
          "displayAreas": "0",
          "page_index": "1"
        },
        parseFunc: (json) => MusicHomeList.fromJson(json));
    _homeList = musicList;
    return musicList;
  }

  //根据当前分类获取播放列表
  Future<MusicPlayListModel> requsetPlayList(
      MusicHomeListItem itemModel) async {
    var playList = await DioClient.instance.get<MusicPlayListModel>(
        Api.musicSummary(itemModel.id),
        parseFunc: (json) => MusicPlayListModel.fromJson(json));
    return playList;
  }

  //根据播放歌曲id批量获取音频文件

  Future<MusicSongListModel> requstSongList(MusicHomeListItem itemModel) async {
    //获取到一个string类型的id集合
    MusicPlayListModel playlist = await requsetPlayList(itemModel);

//把id拼接成字符串用‘,’隔开
    String idsStr = "";
    for (var itemmodel in playlist.playList) {
      if (idsStr == "") {
        idsStr = itemmodel.id.toString();
      } else {
        idsStr = idsStr + "," + itemmodel.id.toString();
      }
    }
    print("遍历数据获取到的id集合是$idsStr");

    var songList = await DioClient.instance.get<MusicSongListModel>(
        Api.kLibrarySongDetailBatchPath,
        queryParameters: {'ids': idsStr},
        parseArrayFunc: (json) => MusicSongListModel.fromJson(json));

//此处添加一个模拟网络的延迟，尽管接口已经返回很快了，不过为了让我们页面看起来走了一个缓慢的网络请求，仍然添加延迟

    songList = await Future.delayed(Duration(milliseconds: 300), () {
      return songList;
    });
    return songList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: FutureBuilder(
          future: requstHomePage(),
          initialData: null,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text("加载数据");
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapshot.hasError) {
                  return Text("请求错误${snapshot.error}");
                } else {
                  return ListView.builder(
                    itemCount: _homeList.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          requstSongList(_homeList.items[index]).then((value) {
                            print(
                                '点击当前第几项$index 跳转路由${RouterPageName.MusicPlayPage}绑定参数是:${value.toString()}');
                            Navigator.of(context).pushNamed(
                              RouterPageName.MusicPlayPage,
                              arguments: value,
                            );
                            // Navigator.push(context, CustomPageRouter(MusicPlayPage(songListModel:value,)));
                          }).catchError((error) {
                            print('请求错误，请重新尝试');
                          });
                        },
                        child: homePageWithItem(_homeList.items[index]),
                      );
                    },
                  );
                }
            }
          },
        ),
      ),
    );
  }
}

homePageWithItem(MusicHomeListItem item) {
  var container = Container(
    padding: EdgeInsets.all(10),
    width: double.infinity,
    height: 140,
    child: CachedNetworkImage(
      imageUrl: item.url,
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Colors.green,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        );
      },
    ),
  );
  return Container(
      child: Stack(
    children: <Widget>[
      container,
      Container(
        padding: EdgeInsets.fromLTRB(20, 100, 0, 0),
        child: Text(
          item.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            decoration: TextDecoration.none,
          ),
        ),
      )
    ],
  ));
}
