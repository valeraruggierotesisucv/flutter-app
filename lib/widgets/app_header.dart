import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Function? goBack;
  const AppHeader({super.key, this.title, this.goBack});

  @override
  Widget build(BuildContext context) {
    return  AppBar(
          title: title != null 
            ? Text(
                title!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SFProRounded'
                ),
              ) 
            : Image.asset('assets/images/EventifyTextLogo.png'),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: goBack != null 
            ? IconButton(
                onPressed: () => goBack!(),
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ) 
            : const SizedBox(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}