import 'package:flutter/material.dart';
import 'package:todolist_app/navigation/navigation.dart';
// import 'package:todolist_app/main.dart';
import 'package:todolist_app/routers/route_name.dart';
import 'package:todolist_app/screens/home_page/home_page.dart';

class AppRoute {
  static Route onGenerateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case AppRouterName.homePage:
        return MaterialPageRoute(
            builder: (_) => const HomePage(
                  initialTab: 0,
                ));

      case AppRouterName.navigationPage:
        return MaterialPageRoute(builder: (_) => const NavigationBottom());
    }

    return _errPage();
  }

  static Route _errPage() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Text('No Router! Please check your configuration'),
        ),
      );
    });
  }
}
