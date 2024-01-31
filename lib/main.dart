import 'package:flutter/material.dart';
import 'package:save_it_forme/screens/home.dart';
import 'package:save_it_forme/themes/theme.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeClass.lightTheme,
      darkTheme: ThemeClass.darkTheme,
      themeMode: ThemeMode.system,
      title: 'Save It ForMe',
      home: const HomePage(),
    );
  }
}
