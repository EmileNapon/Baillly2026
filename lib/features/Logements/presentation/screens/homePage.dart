import 'package:flutter/material.dart';
import '../../../../shared/widgets/appBar.dart';
import '../../../../shared/widgets/TopMenuSearch.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Supprimez le Scaffold et la bottomNavigationBar ici !
    return Column(
      children: [
        const MyAppBar(), // Si MyAppBar est un PreferredSizeWidget, il faudra peut-être l'adapter
        const SearchApp(),  
        Expanded(
          child: Container(
            color:Color(0xFFFFFFFF),
          ),
        ),
      ],
      
    );
  }
}





