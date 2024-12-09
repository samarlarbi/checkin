import 'package:checkin/colors.dart';
import 'package:flutter/material.dart';
import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';

class Navbar extends StatefulWidget {
  final Widget Screen0;
  final Widget Screen1;
  final Widget Screen2;

  Navbar({
    Key? key,
    required this.Screen0,
    required this.Screen1,
    required this.Screen2,
  }) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return CurvedNavBar(
      actionButton: CurvedActionBar(
        activeIcon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Primary.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.qr_code_scanner_rounded,
            size: 50,
            color: Colors.white,
          ),
        ),
        inActiveIcon: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.qr_code_scanner_rounded,
            size: 50,
            color: Colors.white,
          ),
        ),
        text: "",
      ),
      activeColor: Secondary,
      navBarBackgroundColor: Colors.white,
      inActiveColor: Colors.black45,
      appBarItems: [
        FABBottomAppBarItem(
          activeIcon: const Icon(Icons.groups, color: Secondary),
          inActiveIcon: const Icon(
            Icons.groups,
            size: 30,
            weight: 900,
            color: Color.fromARGB(255, 121, 120, 120),
          ),
          text: 'invitations',
        ),
        FABBottomAppBarItem(
          activeIcon: const Icon(
            Icons.done_all_rounded,
            color: Secondary,
            size: 30,
          ),
          inActiveIcon: const Icon(
            Icons.done_all_rounded,
            size: 30,
            color: Color.fromARGB(255, 121, 120, 120),
          ),
          text: 'checked',
        ),
      ],
      actionBarView: widget.Screen0,
      bodyItems: [
        widget.Screen1,
        widget.Screen2,
      ],
    );
  }
}
