/*
*自定义listview滚动规则，当滚动的距离不足一行的时候，回滚到最近一行的位置
**/
import 'package:flutter/material.dart';

class PagingScrollPhysics extends ScrollPhysics {
  PagingScrollPhysics(
      {this.itemHeight,
      this.maxSize,
      this.paddingSpacing,
      ScrollPhysics parent})
      : super(parent: parent);

  final double itemHeight; //listView item的高度
  final double maxSize; //最大可滑动区域
  final double paddingSpacing; //间距

  @override
  PagingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return PagingScrollPhysics(
        maxSize: maxSize,
        itemHeight: itemHeight,
        parent: buildParent(ancestor));
  }

//获取当前第几页
  double _getPage(ScrollPosition position, double leading) {
    return (position.pixels + leading) / itemHeight;
  }

  //计算当前需要的滚动位置
  double _getPixels(double page, double leading) {
    return (page * itemHeight) - leading;
  }

//计算需要滚动的位置
  double _getTargetPixel(ScrollPosition position, Tolerance tolerance,
      double velocity, double leading) {
    double page = _getPage(position, leading);

    if (position.pixels < 0) {
      return 0;
    }

    if (position.pixels > maxSize) {
      return maxSize;
    }

    // if(position.pixels > 0){
    //   if(velocity < -tolerance.velocity){
    //     page -= 0.5;
    //   }else{
    //     page += 0.5;
    //   }
    double jli = _getPixels(page.roundToDouble(), leading);
    print("当前返回的滚动距离是$jli");
    return _getPixels(page.roundToDouble(), leading);
    // }
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if (velocity <= 0.0 && position.pixels <= position.minScrollExtent) {
      return super.createBallisticSimulation(position, velocity);
    }

    final Tolerance tolerance = this.tolerance;
    double mypaddingSpacing = paddingSpacing == null ? 0 : paddingSpacing;
    double maxheight = maxSize == null ? 0 : maxSize;
    final double target =
        _getTargetPixel(position, tolerance, velocity, mypaddingSpacing);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }
    return null;
  }
}
