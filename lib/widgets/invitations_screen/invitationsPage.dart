import 'package:checkin/utils/table.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class Invitations extends StatefulWidget {
  const Invitations({super.key});

  @override
  State<Invitations> createState() => _InvitationsState();
}

class _InvitationsState extends State<Invitations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert_outlined,
                  color: const Color.fromARGB(255, 69, 69, 69)))
        ],
        title: Text(
          "Invitations",
          style: TextStyle(color: const Color.fromARGB(255, 69, 69, 69)),
        ),
        centerTitle: true,
        backgroundColor: Background,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            MyTable(),
          ],
        ),
      ),
    );
  }
}
