import 'package:checkin/utils/MyAppBar.dart';
import 'package:checkin/utils/searchField.dart';
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
      appBar: MyAppBar(
        title: "All Invitations",
        leading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            SearchField(),
            SizedBox(height: 10),
            MyTable(),
          ],
        ),
      ),
    );
  }
}
