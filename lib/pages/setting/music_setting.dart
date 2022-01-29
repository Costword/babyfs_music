import 'package:flutter/material.dart';

class MusicSettingPage extends StatefulWidget {
  MusicSettingPage({Key key, this.index}) : super(key: key);

  final int index;

  @override
  State<MusicSettingPage> createState() => _MusicSettingPageState();
}

class _MusicSettingPageState extends State<MusicSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
      ),
      body: Center(child: Text("设置${widget.index}")),
    );
  }
}
