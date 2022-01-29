import 'package:babyfs_music/pages/bottomBar/animation_tablebar_icon.dart';
import 'package:flutter/material.dart';

class TableBarIcon extends StatefulWidget {
  TableBarIcon(
      {Key key,
      this.tableIconData,
      this.removeAllSelect,
      this.rect,
      this.normalIconSize,
      this.iconMarginTop,
      this.isChecked})
      : super(key: key);

  final TableIconData tableIconData; //图标数据
  final Function removeAllSelect;
  final Rect rect; //图标位置
  final double normalIconSize; //图标大小

  final double iconMarginTop; //图标顶部距离

  final bool isChecked; //是否被选中

  @override
  State<TableBarIcon> createState() => _TableBarIconState();
}

class _TableBarIconState extends State<TableBarIcon>
    with TickerProviderStateMixin {
  @override
  void initState() {
    widget.tableIconData.animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    super.initState();
  }

  void setAnimation() {
    //先重制，然后执行一次
    widget.tableIconData.animationController.reset();
    widget.tableIconData.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
        rect: widget.rect,
        child: InkWell(
          //用户点击的时候会出现水波纹效果
          onTap: () {
            if (!widget.isChecked) {
              setAnimation();
              widget.removeAllSelect();
            }
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  widget.tableIconData.title,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: widget.iconMarginTop,
                child: Center(
                  child: IgnorePointer(
                    //忽略点击事件
                    ignoring: true,
                    child: Container(
                        width: widget.normalIconSize,
                        height: widget.normalIconSize,
                        child: RotationTransition(
                            turns: Tween(begin: -0.12, end: 0.0).animate(
                                CurvedAnimation(
                                    //Interval 代表在动画执行时间内 使用Interval内的值对动画时间进行分段，例如从0.5-1.0则代表从动画开始的前一半时间不做改变，在后面时间才开始执行
                                    parent: widget
                                        .tableIconData.animationController,
                                    curve: Interval(0.75, 1.0,
                                        curve: Curves.easeInCubic))),
                            child: RotationTransition(
                              turns: Tween(begin: 0.12, end: -0.12).animate(
                                  CurvedAnimation(
                                      parent: widget
                                          .tableIconData.animationController,
                                      curve: Interval(0.25, 0.75,
                                          curve: Curves.easeInCubic))),
                              child: RotationTransition(
                                  turns: Tween(begin: 0.0, end: 0.12).animate(
                                      CurvedAnimation(
                                          parent: widget.tableIconData
                                              .animationController,
                                          curve: Interval(0.0, 0.25,
                                              curve: Curves.easeInCubic))),
                                  child: Icon(widget.tableIconData.iconData)),
                            ))),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
