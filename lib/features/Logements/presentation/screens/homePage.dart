import 'package:flutter/material.dart';
import '../../../../shared/widgets/appBar.dart';
import '../../../../shared/widgets/TopMenuSearch.dart';
import '../../../../shared/widgets/bottomNav.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
     body: Column(
      children: [
             SearchApp(),
            Expanded(
              child: Container(
                
              ),
            ),
          ],
     ),
   //  bottomNavigationBar: BuildBottomBar(),
    );
  }
}

