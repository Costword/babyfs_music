import 'global.dart';

class Api {
  static final String baseUrl =  apiEnv == APIENV.DEVELOP
  ?"http://m.lpt.babyfs.cn/api/"
  :"https://a.api.babyfs.cn/api/";

//音乐馆API
static musicSceneList() => "${baseUrl}library/search?dataType=64&sortType=1&page_index=1&page_size=1000&displayAreas=0";

//根据id获取播放列表
static musicSummary(id) => "${baseUrl}library/subject/particular/list?id=$id&page_index=1&page_size=1000";

static musicDetail(ids) =>"${baseUrl}library/baby_song/batch?ids=$ids";

//磨耳朵
static courseMusicList() => '${baseUrl}v3/audio/course/recommend';

//获取歌词
static lrc(String shortId) => '${baseUrl}av/subtitle?short_id=$shortId';

//儿歌列表
/**
 * @{@"dataType": @"64",
     @"page_size": @"9999",
     @"displayAreas": @"0",
     @"page_index": @"1"}
*/
static final String kLibraryListSearchPath = "${baseUrl}library/search";

//批量获取儿歌列表
/*
@{
  @{@"ids": songIds}
}
*/
static final String kLibrarySongDetailBatchPath = "${baseUrl}library/baby_song/batch";

}

