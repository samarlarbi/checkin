import 'package:checkin/utils/MyAppBar.dart';
import 'package:checkin/utils/colors.dart';
import 'package:checkin/widgets/ticket_page/view/components/CheckInWidget.dart';
import 'package:checkin/widgets/ticket_page/view/components/GuestCheckInWidget.dart';
import 'package:flutter/material.dart';
import 'package:ticket_widget/ticket_widget.dart';

import '../controller/controller.dart';

class MyTicketView extends StatefulWidget {
  final ticket;

  MyTicketView({Key? key, this.ticket}) : super(key: key);

  @override
  State<MyTicketView> createState() => _MyTicketViewState();
}

class _MyTicketViewState extends State<MyTicketView> {
  final CheckinGuestController _controller = CheckinGuestController();
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchAttendee(attendeeid) async {
    await _controller.fetchCheckinGuest(attendeeid);
    setState(() {});
    print("****************************" + _controller.attendee.toString());

    if (_controller.attendee.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Checkin'),
            content: Text('Checkin failed'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyTicketView(ticket: _controller.attendee)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Ticket",
        leading: true,
      ),
      backgroundColor: Color.fromARGB(255, 229, 229, 229),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Center(
          child: TicketWidget(
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            isCornerRounded: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: TicketData(
              ticket: widget.ticket,
            ),
          ),
        ),
      ),
    );
  }
}

class TicketData extends StatefulWidget {
  final Map<String, dynamic> ticket;

  TicketData({
    Key? key,
    required this.ticket,
  }) : super(key: key);

  @override
  State<TicketData> createState() => _TicketDataState();
}

class _TicketDataState extends State<TicketData> {
  final CheckinGuestController _controller = CheckinGuestController();
  void dispose() {
    super.dispose();
  }

  Future<void> _Checkinguest(attendeeid) async {
    await _controller.fetchCheckinGuest(attendeeid);
    setState(() {});
    print("****************************" + _controller.attendee.toString());

    if (_controller.attendee.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Checkin'),
            content: Text('Checkin failed'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor =
        widget.ticket['isCheckedIn'] == true ? Colors.green : Colors.red;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.12,
                child: CheckInWidget(
                  ticketId: widget.ticket['ticketId'],
                  initialStatus: widget.ticket['isCheckedIn'],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Affichage des détails du détenteur du ticket
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ticket Type',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                          widget.ticket["type"],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Name',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                          widget.ticket["name"] == null
                              ? widget.ticket["attendee"]["name"]
                              : widget.ticket["name"],
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                          widget.ticket["email"] == null
                              ? widget.ticket["attendee"]["email"]
                              : widget.ticket["email"],
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 5),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(children: [
                      ticketDetailsWidget(
                        'Ticket ID',
                        widget.ticket['ticketId'],
                        '',
                        "",
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Affichage des invités (relatives)
              Padding(
                padding: EdgeInsets.only(top: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Guests',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      "+" + widget.ticket["relatives"].length.toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              // Liste des invités
              ...widget.ticket["relatives"].map<Widget>((relative) {
                return Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: GuestCheckInWidget(relative: relative));
              }).toList(),
            ],
          ),
          SizedBox(
              height: widget.ticket["type"] == "EXTERNAL" ||
                      widget.ticket["type"] == "INDIVIDUAL" ||
                      widget.ticket["type"] == "WITH_ONE"
                  ? 30
                  : 2),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                    width: widget.ticket["type"] == "EXTERNAL" ||
                            widget.ticket["type"] == "INDIVIDUAL" ||
                            widget.ticket["type"] == "WITH_ONE"
                        ? MediaQuery.of(context).size.width * 0.4
                        : MediaQuery.of(context).size.width * 0.2,
                    "assets/mic.png"),
                Image.asset(
                    width: widget.ticket["type"] == "EXTERNAL" ||
                            widget.ticket["type"] == "INDIVIDUAL" ||
                            widget.ticket["type"] == "WITH_ONE"
                        ? MediaQuery.of(context).size.width * 0.4
                        : MediaQuery.of(context).size.width * 0.2,
                    "assets/nateg.png")
              ])
        ],
      ),
    );
  }
}

Widget ticketDetailsWidget(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              firstTitle,
              style: TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      )
    ],
  );
}
