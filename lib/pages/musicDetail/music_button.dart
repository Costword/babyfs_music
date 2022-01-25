import 'package:babyfs_music/common/music_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:cached_network_image/cached_network_image.dart';

typedef GestureTapCallback = void Function(bool select);

class MusicButton extends StatefulWidget {
  MusicButton({
    Key key,

  this.imgUrl,
  this.normalImgPath,
  this.selectImgPath,
  this.normalIconData,
  this.selectIconData,
  this.onTap,
  this.padding : const EdgeInsets.fromLTRB(10, 10, 10, 10),
  this.margin : const EdgeInsets.fromLTRB(0, 0, 0, 0),
  this.isEnable:true,
  this.backgroundColor,
  this.imageColor,
  this.borders,
  this.size : 25
    }) : super(key: key);


  final String imgUrl;
  final String normalImgPath;
  final String selectImgPath;
  final IconData normalIconData;
  final IconData selectIconData;
  final GestureTapCallback onTap;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final bool isEnable;
  final double size;
  final Color backgroundColor;
  final Color imageColor;
  final BorderRadius borders;
  bool selected =false;

  @override
  _MusicButtonState createState() => _MusicButtonState();
}

class _MusicButtonState extends State<MusicButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.selectIconData!=null || widget.selectImgPath != null){
          setState(() {
            widget.selected = !widget.selected;  
          });
        }
        widget.onTap(widget.selected);
        //触感反馈
        Vibrate.feedback(FeedbackType.impact);
      },
      child: _musicButton(context),
    );
  }


  Widget _musicButton(BuildContext context){
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        borderRadius: widget.borders!=null?widget.borders: BorderRadius.circular(15),
        color: widget.backgroundColor!=null?widget.backgroundColor:Colors.white10
      ),
      // MusicStroe.Theme(context).IconColor
      child: widget.normalImgPath == null ? Icon(_iconData(),size: widget.size,color:MusicStroe.Theme(context).IconColor) : _pathImage()
    );
  }


  IconData _iconData(){
    if(widget.selectIconData !=null){
      return widget.selected == true ? widget.selectIconData : widget.normalIconData;
    }
    return  widget.normalIconData;
  }

  Widget _image(){
    return CachedNetworkImage(
      imageUrl: widget.imgUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(image: imageProvider),
        ),
      ),
    );
  }

  Widget _pathImage(){

    if(widget.selectImgPath != null){
      return widget.selected == true? SizedBox(
        width: widget.size,
        height: widget.size,
        child: Container(
          // color: widget.imageColor!=null?widget.imageColor:MusicStroe.Theme(context).IconColor
          child: Image.asset(widget.normalImgPath,fit: BoxFit.contain),
        ),
      ):SizedBox(
        width: widget.size,
        height: widget.size,
        child: Container(
          // color: widget.imageColor!=null?widget.imageColor:MusicStroe.Theme(context).IconColor
          child:  Image.asset(widget.selectImgPath,fit: BoxFit.contain),
          
        )
      );
    }
    return SizedBox(
        width: widget.size,
        height: widget.size,
        child: Container(
          // color: Colors.pink[100],
          child: Image.asset(widget.normalImgPath,fit: BoxFit.contain,),
        )
      );
  }
}