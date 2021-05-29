import 'package:flutter/widgets.dart';

import 'package:steadyroutes/root.dart';

mixin NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  static Future<dynamic> navigateToWithArguments(
      String routeName, Object args) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: args,
    );
  }

  static void goBack() {
    navigatorKey.currentState!.pop();
  }

  static void popUntilRoot() {
    navigatorKey.currentState!.popUntil(ModalRoute.withName(
      Root.routeName,
    ));
  }
}
