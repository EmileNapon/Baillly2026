import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
final _avatarColors = const Color(0xFFB24020);
final Widget? leading;
final Widget? center;
final Widget? title;
final String? nom;
final String? nomPrenom;
final List<Widget>? actions;

const MyAppBar({super.key, this.leading, this.center,this.title, this.nom, this.nomPrenom, this.actions,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      titleSpacing: 4,
      leading:leading ?? Container(width: 39,height: 39,
        decoration: BoxDecoration(color: _avatarColors, shape: BoxShape.circle,border: Border.all(color: const Color(0xFFE0DDD8),width: 2,),),
        child: center ?? Center(
          child: Text('EN',style: TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w600,),),
        ),      
      ),
      
      title: title ?? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Bonjour, &{nom}', style: TextStyle(fontSize: 11, color: Color(0xFF666666))),
          SizedBox(height: 1),
          Text('&{nomPrenom}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF191919))),
        ],
      ),
      
      actions: actions ?? [
        IconButton( icon: Icon(Icons.notifications_none),  onPressed: () {},),
        const SizedBox(width: 10),
        IconButton( icon: Icon(Icons.settings_outlined),  onPressed: () {},)
      ],
    );
  }

@override
Size get preferredSize => Size.fromHeight(60);
}

