import 'package:babyfs_music/common/personal_icons.dart';
import 'package:flutter/material.dart';

class TableIconData {

  TableIconData({
    this.iconData,
    this.index,
    this.title,
    this.animationController
  });
  IconData iconData;
  int index;
  String title;
  AnimationController animationController;


static List<TableIconData> tableIconList = <TableIconData>[
  TableIconData(
    iconData: PersonalIcons.discover,
    index: 0,
    title: "推荐",
    animationController: null
  ),
  TableIconData(
    iconData: PersonalIcons.wode,
    index: 1,
    title: "我的",
    animationController: null
  ),
  TableIconData(
    iconData: Icons.search,
    index: 2,
    title: "查询",
    animationController: null
  ),
  TableIconData(
    iconData: Icons.alarm,
    index: 3,
    title: "定时",
    animationController: null
  ),
];
}