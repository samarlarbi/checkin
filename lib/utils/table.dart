import 'package:checkin/utils/colors.dart';
import 'package:checkin/widgets/ticket_page/view/ticketPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttericon/web_symbols_icons.dart';

class MyTable extends StatelessWidget {
  final tickets;

  String nbguests(int type) {
    if (type == 1) {
      return "0 guest";
    } else if (type == 2) {
      return "+1 guest";
    } else if (type == 3) {
      return "+2 guests";
    } else if (type == 4) {
      return "guest";
    }
    return "Unknown";
  }

  MyTable({super.key, required this.tickets});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.symmetric(vertical: 7),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: Colors.white,
              leading: tickets[index]["checkedIn"] == true
                  ? const Icon(
                      WebSymbols.ok,
                      size: 30,
                      fill: 0,
                      opticalSize: 1,
                      grade: 600,
                      weight: 900,
                      color: Primary,
                    )
                  : const Icon(
                      WebSymbols.cancel,
                      color: Color.fromARGB(255, 160, 82, 82),
                      size: 30,
                    ),
              title: Text(tickets[index]['nameAttendee'].toString()),
              subtitle: Text(nbguests(tickets[index]['checkedInGuest'])),
              trailing: IconButton(
                icon: Icon(Icons.keyboard_double_arrow_right_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyTicketView(ticket: tickets[index])),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
