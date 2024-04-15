import 'package:flutter/material.dart';
import 'package:pixaby_tw/features/images_grid/views/grid_details_screen.dart';
import 'package:pixaby_tw/features/images_grid/views/grid_screen.dart';

class RouteGenerator {
  const RouteGenerator._();

  static const initialRoute = GridScreen.id;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    MaterialPageRoute routeBuilder(Widget widget) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => widget,
      );
    }

    final args = settings.arguments as dynamic;

    switch (settings.name) {
      case GridScreen.id:
        return routeBuilder(const GridScreen());
      case GridDetailsScreen.id:
        return routeBuilder(GridDetailsScreen(image: args['image']));
      default:
        return routeBuilder(
          Scaffold(
            body: Center(
              child: Text(
                'ROUTE\n\n${settings.name}\n\nNOT FOUND',
              ),
            ),
          ),
        );
    }
  }
}
