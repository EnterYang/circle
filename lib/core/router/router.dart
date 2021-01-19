import 'package:circle/ui/pages/main/main.dart';
import 'package:flutter/material.dart';

class CIRRouter {
  static final String initialRoute = CIRMainPage.routeName;

  static final Map<String, WidgetBuilder> routes = {
    CIRMainPage.routeName: (ctx) => CIRMainPage(),
  };

  static final RouteFactory generateRoute = (settings) {
    return null;
  };

  static final RouteFactory unknownRoute = (settings) {
    return null;
  };
}