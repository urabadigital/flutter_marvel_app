import 'package:flutter/material.dart';

import 'core/providers/theme_changer.dart';
import 'ui/views/home/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final _myChangeNotifier = MyChangeNotifier();

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ThemeChanger(
      myChangeNotifier: _myChangeNotifier,
      child: AnimatedBuilder(
        animation: _myChangeNotifier,
        builder: (context, snapshot) {
          return MaterialApp(
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            title: 'Marvel App',
            theme: _myChangeNotifier.isWhite
                ? ThemeData(
                    useMaterial3: true,
                    primaryColor: Colors.white,
                    floatingActionButtonTheme:
                        const FloatingActionButtonThemeData(
                            elevation: 0, foregroundColor: Colors.white),
                    brightness: Brightness.light,
                  )
                : ThemeData(
                    useMaterial3: true,
                    primaryColor: const Color(0xFF252525),
                    floatingActionButtonTheme:
                        const FloatingActionButtonThemeData(
                            elevation: 0, foregroundColor: Colors.black),
                    brightness: Brightness.dark,
                    scaffoldBackgroundColor: const Color(0xFF2C2C2C),
                  ),
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}
