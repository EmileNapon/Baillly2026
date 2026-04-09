// Créer une app Flutter minimale 
import 'package:flutter/material.dart';

void main() {
 runApp(LinkedInApp());
}

class LinkedInApp extends StatelessWidget {

  Widget build(BuildContext context) {
    return MaterialApp(
      title:"LinkedIn UI",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Roboto",
        scaffoldBackgroundColor: const Color(0xFFF3F2EF),
      ),
      home: Column(
      children: [
        Expanded(child:Container())
      ],
      )
    );
  }

}

class appBar extends StatelessWidget implements PreferredSizeWidget{
 @override
  Size get preferredSize =>  const Size.fromHeight(60);
 Widget build(BuildContext context) {
   return Container(
    color: Colors.white,
    padding: EdgeInsets.all(8),
    child: Column(
      children: [
        Row(
          children: [
            
          ],
        )
      ],
    ),
   
   );
 }

}
