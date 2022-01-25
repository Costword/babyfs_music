import 'package:babyfs_music/common/music_store.dart';
import 'package:flutter/material.dart';
import 'music_button.dart';


typedef GestureTapCallback = void Function();

class MusicAppBar extends StatefulWidget implements PreferredSizeWidget{
  MusicAppBar({
    Key key,
    this.title,
    this.leftIcon,
    this.rightIcon,
    this.rightSelectIcon,
    this.leftOnTap,
    this.rightOnTap,
    }) :preferredSize = Size.fromHeight(kToolbarHeight),super(key: key);

final String title;//标题

final IconData leftIcon;//左侧按钮
final IconData rightIcon;//右侧按钮
final IconData rightSelectIcon;//右侧选中按钮
final GestureTapCallback leftOnTap;//左边点击事件
final GestureTapCallback rightOnTap;//右边点击事件

final Size preferredSize;

  @override
  _MusicAppBarState createState() => _MusicAppBarState();
}

class _MusicAppBarState extends State<MusicAppBar> {
  @override
  Widget build(BuildContext context) {
    List <Widget> _list = List();

    if(widget.leftIcon != null)
    {
      bool isleft = true;
      _list.add(_item(isleft));
    }

    if(widget.title != null){
      _list.add(_title());
    }
    
    if(widget.rightIcon != null)
    {
      bool isleft = false;
      _list.add(_item(isleft));
    }
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 20,right: 20),
        // color: MusicStroe.Theme(context).theme,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _list,
        ),
      )
      );
  }

  Widget _item (bool isleft) {
    if(widget.leftIcon == null ){
      return Text("");
    }
    return MusicButton(
      normalIconData: isleft==true? widget.leftIcon:widget.rightIcon,
      selectIconData: widget.rightSelectIcon,
      size: 30,
      backgroundColor: Colors.white10,
      imageColor: Colors.grey,
      borders: BorderRadius.circular(25),
      onTap: (select) {
        if(widget.leftOnTap != null && isleft)
        {
          widget.leftOnTap();
        }
      },
    );
  }

  Widget _title () {
    // MusicStroe.Theme(context).TextColor
    return Text("${widget.title}",style: TextStyle(fontSize: 25 ,color:Colors.black ,fontWeight: FontWeight.w500),);
  }
}