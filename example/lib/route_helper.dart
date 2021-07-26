import 'package:example/SecondPage.dart';
import 'package:flutter/material.dart';

import 'FirstPage.dart';

///路由管理
class RouteHelper {
  ///主模块
  static const String firstPage = 'first';
  static const String secondPage = 'second';

  ///路由与页面绑定注册
  static Map<String, WidgetBuilder> routes = {
    firstPage: (context) => FirstPage(),
    secondPage: (context) => SecondPage(),
  };
}
