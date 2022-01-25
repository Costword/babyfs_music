import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'music_item_model.dart';
import 'package:provider/provider.dart';
import 'music_song_list.dart';

class MusicPlayListManger extends ChangeNotifier {
  AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState audioPlayState;

  //当前播放系统 iOS， Android
  TargetPlatform platform;

//当前播放位置
  int _currentIndex = 0;
  int _currentPlayId = 0;

  //当前的播放列表
  MusicSongListModel _currentPlayList;

//当前歌曲播放总时长
  Duration _duration;

//当前歌曲播放进度
  Duration _position;

//获取当前的播放列表
  MusicSongListModel get playList => _currentPlayList;

//当前播放音乐
  SongItemModel get currentItem => _currentPlayList.songList[_currentIndex];

//当前的播放状态
  bool currentPlayStatus = false;

  var _durationText = "00:00";
  var _positionText = "00:00";

  get durationText => _durationText;
  get positionText => _positionText;

  int get currentindex => _currentIndex;

//播放进度
  double playProgress = 0.0;

//监听列表播放进度
  final StreamController<int> _currentIndexController =
      StreamController<int>.broadcast();

//监听当前的播放状态
  final StreamController<PlayerState> _currentPlayStateController =
      StreamController<PlayerState>.broadcast();

//监听当前歌曲的播放时间

final StreamController<String> _currentSongPositionController = StreamController<String>.broadcast();

get currentSongPositionController =>_currentSongPositionController;

  Stream<int> get onUpdateCurrentIndex => _currentIndexController.stream;

  Stream<PlayerState> get onPlayerStateChange =>
      _currentPlayStateController.stream;
  Stream<String> get currentSongPositionStream =>_currentSongPositionController.stream;

  @override
  void dispose() {
    _currentIndexController.close();
    _currentPlayStateController.close();
    _currentSongPositionController.close();
    super.dispose();
  }

  MusicPlayListManger({this.platform}) {
    _listenPlayerDurationChange();
    _listenPlayerPositionChange();
    _listenPlayerStateChange();
  }

///监听播放状态
  void _listenPlayerStateChange() {
    _audioPlayer.onPlayerStateChanged.listen((event) {
      audioPlayState = event;
      _currentPlayStateController.add(audioPlayState);
      print("播放状态改变了$event");
      if (event == PlayerState.COMPLETED) {
        print("播放完成，下一曲");
      }
      if(event == PlayerState.PLAYING){
        //开启旋转动画
        print('当前的音乐播放状态是:播放中');
        // notifyListeners();
      }
    });
  }

//监听播放时间
  void _listenPlayerDurationChange() {
    _audioPlayer.onDurationChanged.listen((event) {
      _duration = event;
      var durationResult = _duration.toString()?.split('.')?.first ?? "";
      List<String> durationList = durationResult.split(':');
      _durationText = durationList[1] + ":" + durationList[2];

      if (platform == TargetPlatform.iOS) {

        //开启锁屏控制
        _audioPlayer.notificationService.startHeadlessService();
        _audioPlayer.notificationService.setNotification(
          title: currentItem.chineseName, //标题
          albumTitle: "", //专辑
          artist: "", //作者
          imageUrl: currentItem.coverPicUrl, //封面
          duration: _duration, //播放进度
          elapsedTime: Duration(seconds: 0), //从0秒开始
        );
      }

      //调用此方法通知UI更新
      notifyListeners();
    });
  }

//监听播放进度
  void _listenPlayerPositionChange() {
    _audioPlayer.onAudioPositionChanged.listen((event) {
      _position = event;
      var positonResult = _position.toString()?.split('.').first ?? "";
      List<String> positonList = positonResult.split(':');
      _positionText = positonList[1] + ":" + positonList[2];
      if (_positionText != null && _durationText != null) {
        print('监听到播放进度$_positionText');
        //转换成毫秒 再相除
        playProgress = _position.inMilliseconds / _duration.inMilliseconds;
        //确保是一个小于等于1的值
        playProgress = playProgress > 1.0 ? 1.0 : playProgress;

        //更新当前歌曲的播放进度，用于歌词绘制
        updateCurrentSongPosion(_position.inMilliseconds < _duration.inMilliseconds?_position.inMilliseconds:_duration.inMilliseconds);
      }
      notifyListeners();
    });
  }

//更新当前歌曲的播放进度
  updateCurrentSongPosion(int m){
    _currentSongPositionController.sink.add('$m');
  }

  /// 更新播放进度
  music_seek(double value) async{
    final position = value * _duration.inMilliseconds;
    int seekResult = await _seek(position);
  }

  Future<int> _seek(position) async {
    int result = await _audioPlayer.seek(Duration(milliseconds: position.round()));
    return result;
  }

//开始播放
  music_play() {
    
    if (audioPlayState == PlayerState.PLAYING) {
      _pause();
    } else {
      _play();
    }
  }

  //更新播放列表，并初始化音乐播放器
  Function updatePlayList(MusicSongListModel songList, int index) {
    _currentPlayList = songList;
    _currentIndex = index;
    _play();
  }

//停止播放
  music_stop() {
    _stop();
  }

//暂停播放
  music_pause() {
    _pause();
  }

//继续播放
music_resum() {
_resum();
}

//开始播放
  _play() async {
    String playUrl = _currentPlayList.songList[_currentIndex].audioUrl;
    // if(currentItem.audioUrl == playUrl  && audioPlayState==AudioPlayerState.PLAYING){
      // int result = await _audioPlayer.resume();
    //   _pause();
    // }
    if (playUrl != null) {
      int result = await _audioPlayer.play(playUrl, isLocal: false);
    }
  }

  //暂停播放
  _pause() async{
    int result = await _audioPlayer.pause();
  }
  //继续播放
  _resum() async{
    int result = await _audioPlayer.resume();
  }

//停止播放，销毁播放器
  _stop() async{
    int result = await _audioPlayer.stop();
    // _audioPlayer.dispose();
    // _audioPlayer = null;
    // audioPlayState = null;
    // _currentIndexController.close();
    // _currentPlayStateController.close();
    
  }

//注册状态监听
  static MusicPlayListManger of(BuildContext context) {
    //注册Provider关联MusicPlayListManger
    return Provider.of<MusicPlayListManger>(context, listen: false);
  }
}
