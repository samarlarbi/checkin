import 'package:checkin/utils/MyAppBar.dart';
import 'package:checkin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:ticket_widget/ticket_widget.dart';

class MyTicketView extends StatelessWidget {
  final ticket;

  const MyTicketView({Key? key, this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: "Ticket",
        leading: true,
      ),
      backgroundColor: Color.fromARGB(255, 229, 229, 229),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: TicketWidget(
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          isCornerRounded: true,
          padding: const EdgeInsets.all(20),
          child: TicketData(
            ticket: ticket,
          ),
        ),
      ),
    );
  }
}

class TicketData extends StatelessWidget {
  final Map<String, dynamic> ticket;
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

  const TicketData({
    Key? key,
    required this.ticket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String ticketStatus = ticket['checked'] == true ? "Checked-In" : "Pending";
    Color statusColor = ticket['checked'] == true ? Colors.green : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120.0,
              height: 25.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(width: 1.0, color: statusColor),
              ),
              child: Center(
                child: Text(
                  ticketStatus,
                  style: TextStyle(color: statusColor),
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'Ceremony Ticket',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ticketDetailsWidget(
                  'name', ticket['person'], 'Date', '28-08-2022'),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: ticketDetailsWidget('code', '76836A45', '', ''),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child:
              ticketDetailsWidget('telphone', nbguests(ticket['type']), '', ''),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: ticketDetailsWidget(
                  'guests', nbguests(ticket['type']), '', ''),
            ),
            Row(
              children: [
                for (int i = 0; i < ticket['nbguest']; i++)
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: true,
                      onChanged: (bool? value) {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
        SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Image.asset(
              width: MediaQuery.of(context).size.width * 0.3, "assets/mic.png"),
          Image.asset(
              width: MediaQuery.of(context).size.width * 0.3,
              "assets/nateg.png")
        ])
      ],
    );
  }
}

Widget ticketDetailsWidget(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              firstTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      )
    ],
  );
}
