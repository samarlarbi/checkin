import 'package:checkin/Api/EndPoint.dart';
import 'package:checkin/utils/colors.dart';
import 'package:checkin/widgets/ticket_page/view/ticketPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttericon/web_symbols_icons.dart';

class MyTable extends StatelessWidget {
  final tickets;

  MyTable({super.key, required this.tickets});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
            leading: (tickets[index].containsKey("ticket") &&
                        tickets[index]["ticket"][ApiKey.checked] == true) ||
                    (tickets[index].containsKey("done") &&
                        tickets[index][ApiKey.checked] == true)
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
            title: Text(tickets[index][ApiKey.AttendeeName] == null
                ? tickets[index]["attendee"][ApiKey.AttendeeName].toString()
                : tickets[index][ApiKey.AttendeeName].toString()),
            trailing: IconButton(
              icon: Icon(Icons.keyboard_double_arrow_right_rounded),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/myTicketView', // Your route name
                  arguments: {
                    'ticketno': tickets[index].containsKey("ticket")
                        ? tickets[index]["ticket"]["ticketNo"]
                        : tickets[index]["ticketNo"]
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
