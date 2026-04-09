import 'package:flutter/material.dart';
import '../features/Logements/presentation/screens/homePage.dart';
class ImmoApp extends StatelessWidget {
  const ImmoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bailly', 
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF3F2EF),
      ),
      home:const HomePage(),
    );
  }
}
