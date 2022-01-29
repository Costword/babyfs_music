import 'package:babyfs_music/pages/bottomBar/animation_table_icon.dart';
import 'package:babyfs_music/pages/bottomBar/animation_tablebar_icon.dart';
import 'package:flutter/material.dart';

class MusicAnimationBottomNavBar extends StatefulWidget {
  MusicAnimationBottomNavBar(
      {Key key, this.selectPositoin, this.selectCallBack, this.iconList})
      : super(key: key);

  final int selectPositoin; //当前选中第几个
  final Function(int selectIndex) selectCallBack; //选中回调
  final List<TableIconData> iconList; //当前的底部按钮列表
  @override
  State<MusicAnimationBottomNavBar> createState() =>
      _MusicAnimationBottomNavBarState();
}

//TickerProviderStateMixin 页面如果使用动画需依赖此项
class _MusicAnimationBottomNavBarState extends State<MusicAnimationBottomNavBar>
    with TickerProviderStateMixin {
  double barHeight = 56.0; //导航栏高度
  double indicatorSize = 36.0; //指示器的size
  double indicatorMarginTop = 2.0; //指示器距离顶部高度
  int selectedIndex = 0; //选中的下标
  int previousSelectedIndex = 0; //上次选中的下标
  double normalIconsSize = 26.0; //默认图标高度
  double itemWidth = 0; //ietm宽度

  AnimationController animatiomController;
  Animation<double> animation;
  final myCurve = Cubic(0.68, 0, 0, 1.6);
  List<Widget> barItems = []; //整个tablebar的子类集合
  List<Widget> iconItems = []; //图标的集合
  @override
  void initState() {
//statefulWidget的生命周期：构造函数 - initState - didChangeDependencies - build - addPostFrameCallback-didUpdateWidget-deactivate-dispose
//此处是监听到当前widget的frame改变
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        itemWidth = context.size.width / widget.iconList.length;
      });
    });
    animatiomController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    selectedIndex = widget.selectPositoin;
    animation = Tween(
      begin: selectedIndex.toDouble(),
      end: selectedIndex.toDouble(),
    ).animate(CurvedAnimation(parent: animatiomController, curve: myCurve));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    barItems.add(creatBackground()); //添加背景
    barItems.add(creatIndicator()); //添加指示器
    addNavBaritems(); //添加items

    return Stack(
      clipBehavior: Clip.none,
      children: barItems,
    );
  }

//背景板
  Widget creatBackground() {
    return Container(
      height: barHeight + MediaQuery.of(context).padding.bottom,
      // boxShadow: [
      //   BoxShadow(
      //       color: Colors.grey,
      //       offset: Offset(0.0, 0.0),
      //       blurRadius: 1.0,
      //       spreadRadius: 0.0)
      // ]
      decoration: BoxDecoration(
        color: Colors.white,
      ),
    );
  }

  //指示器
  Widget creatIndicator() {
    return AnimatedBuilder(
      animation: animatiomController,
      builder: (context, child) {
        return Positioned(
            left: (itemWidth - indicatorSize) / 2 + animation.value * itemWidth,
            top: indicatorMarginTop,
            child: child);
      },
      child: Container(
        width: indicatorSize,
        height: indicatorSize,
        decoration: BoxDecoration(
            shape: BoxShape.circle, //盒子形状
            color: Colors.orange),
      ),
    );
  }

  //计算图表位置并添加

  Function addNavBaritems() {
    for (int i = 0; i < widget.iconList.length; i++) {
      //计算图标中心点
      final rectBg = Rect.fromCenter(
          center: Offset(itemWidth / 2 + (i * itemWidth), barHeight / 2),
          width: itemWidth,
          height: barHeight);

      final iconMarginTop =
          indicatorMarginTop + (indicatorSize - normalIconsSize) / 2;
      TableBarIcon tableIcon = TableBarIcon(
        tableIconData: widget.iconList[i],
        rect: rectBg,
        isChecked: selectedIndex == i,
        normalIconSize: normalIconsSize,
        iconMarginTop: iconMarginTop,
        removeAllSelect: () => _selectIndexItem(i),
      );

      barItems.add(tableIcon);
    }
  }

  void _selectIndexItem(int index) {
    if (index == selectedIndex) {
      return;
    }
    previousSelectedIndex = selectedIndex;
    selectedIndex = index;

    print('当前选中的是$index');
    //执行动画
    animation = Tween(
            begin: previousSelectedIndex.toDouble(),
            end: selectedIndex.toDouble())
        .animate(CurvedAnimation(parent: animatiomController, curve: myCurve));
    animatiomController.forward(from: 0.0);
    Future.delayed(Duration(milliseconds: 400), () {
      widget.selectCallBack(selectedIndex);
    });
  }
}
