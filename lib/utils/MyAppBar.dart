import 'package:flutter/material.dart';
import 'colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool leading;
  final List<Widget> action;

  const MyAppBar(
      {Key? key, this.title, this.leading = false, this.action = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: action,
      leading: leading
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              color: const Color.fromARGB(255, 86, 86, 86),
            )
          : Padding(padding: EdgeInsets.zero),
      title: Text(
        title ?? '',
        style: const TextStyle(color: Color.fromARGB(255, 69, 69, 69)),
      ),
      centerTitle: true,
      backgroundColor: Background,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
