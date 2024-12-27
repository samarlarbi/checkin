import 'package:checkin/utils/MyAppBar.dart';
import 'package:checkin/utils/colors.dart';
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
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: TicketWidget(
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          isCornerRounded: true,
          padding: EdgeInsets.all(20),
          child: TicketData(
            ticket: widget.ticket,
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

  List<bool> checkboxValues = [false, false, false];
  @override
  Widget build(BuildContext context) {
    String ticketStatus =
        widget.ticket['checkedIn'] == true ? "Checked-In" : "Pending";
    Color statusColor =
        widget.ticket['checkedIn'] == true ? Colors.green : Colors.red;
    int uncheckedGuest = widget.ticket["ticket"]["ticketTypeId"]['nbGuest'] -
        widget.ticket["checkedInGuest"];
    int checkedINGuest = widget.ticket["checkedInGuest"];
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
            Row(
              children: [
                Text(
                  widget.ticket["ticket"]["ticketTypeId"]['nameTicketType'],
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.school,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            )
          ],
        ),
        Padding(
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
          padding: EdgeInsets.only(top: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ticketDetailsWidget('name', widget.ticket['nameAttendee'],
                  'Email', widget.ticket["email"]),
              Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: ticketDetailsWidget('code',
                    widget.ticket["ticket"]["codeTicket"].toString(), '', ''),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: ticketDetailsWidget('Phone', widget.ticket["phone"], '', ''),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: ticketDetailsWidget(
                  'guests',
                  "+" +
                      widget.ticket["ticket"]["ticketTypeId"]['nbGuest']
                          .toString() +
                      " Guests",
                  '',
                  ''),
            ),
            Row(
              children: [
                Row(
                  children: List.generate(uncheckedGuest, (index) {
                    return Transform.scale(
                      scale: 1.2,
                      child: _controller.isLoading
                          ? CircularProgressIndicator(
                              color: Secondary,
                            )
                          : Checkbox(
                              fillColor: MaterialStateProperty.all(Secondary),
                              value: checkboxValues[index],
                              onChanged: (bool? value) {
                                _Checkinguest(widget.ticket["_id"]);
                                setState(() {
                                  checkboxValues[index] = true;
                                });
                                print(checkboxValues);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                    );
                  }),
                ),
                Row(
                  children: List.generate(checkedINGuest, (index) {
                    return Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        fillColor: MaterialStateProperty.all(Secondary),
                        value: true,
                        onChanged: (bool? value) {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
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
