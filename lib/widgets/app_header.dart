import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Function? goBack;
  const AppHeader({super.key, this.title, this.goBack});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: title != null ? Text(title!) : Image.asset('assets/images/EventifyTextLogo.png'),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: goBack != null ? IconButton(
        onPressed: () => goBack!(),
        icon: Icon(Icons.arrow_back),
      ) : SizedBox(),

    );

  }


  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}