import 'package:flutter/material.dart';
import 'colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool leading;

  const MyAppBar({Key? key, this.title, this.leading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
            )
          : null,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert_outlined),
          color: const Color.fromARGB(255, 69, 69, 69),
        ),
      ],
      title: Text(
        title ?? '',
        style: const TextStyle(color: Color.fromARGB(255, 69, 69, 69)),
      ),
      centerTitle: true,
      backgroundColor: Background, // Assuming this is defined in colors.dart
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
