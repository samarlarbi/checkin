import 'package:flutter/material.dart';

import '../../../utils/MyAppBar.dart';
import '../../../utils/colors.dart';
import '../../../utils/searchField.dart';
import '../../../utils/table.dart';

class CheckedInvitationsPage extends StatelessWidget {
  final tickets;
  const CheckedInvitationsPage({super.key, this.tickets});

  @override
  Widget build(BuildContext context) {
    ticketfilter() {
      return tickets.where((ticket) => ticket["checked"] == true).toList();
    }

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
            MyTable(tickets: ticketfilter()),
          ],
        ),
      ),
    );
    ;
  }
}
