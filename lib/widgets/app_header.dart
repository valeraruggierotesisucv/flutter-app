import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Function? goBack;
  const AppHeader({super.key, this.title, this.goBack});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      // title: title != null ? Text(title!) : Text('Your App Title'),
      title: title != null ? Text(title!) : Image.asset('assets/images/EventifyTextLogo.png'),
      centerTitle: true,
      leading: goBack != null ? IconButton(
        onPressed: () => goBack!(),
        icon: Icon(Icons.arrow_back),
      ) : SizedBox(),



      
    );
  }


  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}