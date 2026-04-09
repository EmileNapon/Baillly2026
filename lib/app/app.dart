import 'package:flutter/material.dart';
import '../shared/widgets/bottomNav.dart';
class ImmoApp extends StatelessWidget {
  const ImmoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bailly', 
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      ),
      home: const BuildBottomBar(), 
    );
  }
}
