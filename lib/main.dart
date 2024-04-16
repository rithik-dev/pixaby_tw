import 'package:flutter/material.dart';
import 'package:pixaby_tw/utils/route_generator.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();

  runApp(const _MainApp());
}

class _MainApp extends StatelessWidget {
  const _MainApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RouteGenerator.initialRoute,
      onGenerateRoute: RouteGenerator.onGenerateRoute,
      themeMode: ThemeMode.light,
      theme: ThemeData.light().copyWith(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
            TargetPlatform.values,
            value: (_) => const ZoomPageTransitionsBuilder(),
          ),
        ),
      ),
    );
  }
}
