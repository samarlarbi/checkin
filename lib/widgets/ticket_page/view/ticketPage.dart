// ignore_for_file: prefer_const_constructors

import 'package:checkin/main.dart';
import 'package:checkin/utils/MyAppBar.dart';
import 'package:flutter/material.dart';

import '../../../Api/EndPoint.dart';
import '../../../utils/colors.dart';
import '../controller/controller.dart';

class MyTicketView extends StatefulWidget {
  final ticket;

  MyTicketView({Key? key, this.ticket}) : super(key: key);

  @override
  State<MyTicketView> createState() => _MyTicketViewState();
}

class _MyTicketViewState extends State<MyTicketView> {
  final CheckinGuestController _controller = CheckinGuestController();

  @override
  Widget build(BuildContext context) {
    double maxwidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 229, 229, 229),
        body: Container(
          color: Background,
          child: Stack(
            children: [
              ListView(
                children: [
                  Container(
                    margin: EdgeInsets.all(0),
                    height: MediaQuery.of(context).size.height * 0.4,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Primary,
                    ),
                    child: ListView(
                      children: [
                        AppBar(
                          leading: IconButton(
                            onPressed: () => Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()),
                                (route) => false),
                            icon: const Icon(Icons.arrow_back),
                            color: Colors.white,
                          ),
                          title: Text(
                            "Attendee Information",
                            style: const TextStyle(color: Colors.white),
                          ),
                          centerTitle: true,
                          backgroundColor: Primary,
                          elevation: 0,
                          actions: [
                            IconButton(
                              onPressed: () {},
                              icon:
                                  const Icon(Icons.mode_edit_outline_outlined),
                              color: Colors.white,
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            children: [
                              Wrap(
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                      child: Icon(
                                        Icons.person_outline_rounded,
                                        color: Colors.white,
                                        size: 40,
                                      )),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.ticket[ApiKey.AttendeeName] +
                                            "\n+216 " +
                                            widget.ticket[ApiKey.phone] +
                                            "\n" +
                                            widget.ticket[ApiKey.email],
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  child: Text(
                                    "Checked in",
                                    style: TextStyle(
                                        color: Primary,
                                        fontWeight: FontWeight.w500),
                                  ))
                            ],
                          ),
                        ),
                        Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: maxwidth * 0.45,
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "University",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    this.widget.ticket[ApiKey.fac]
                                        [ApiKey.namefac],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: maxwidth * 0.45,
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Level",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    this.widget.ticket[ApiKey.studylevel],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.35),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          spacing: 5,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: maxwidth * 0.45,
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Text(
                                    "Team",
                                    style: TextStyle(
                                        color: Primary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    this.widget.ticket[ApiKey.team]
                                        [ApiKey.nameteam],
                                    style: TextStyle(
                                        color: Primary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: maxwidth * 0.45,
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Text(
                                    "Rank",
                                    style: TextStyle(
                                        color: Primary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    "0",
                                    style: TextStyle(
                                        color: Primary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.fastfood,
                            color: Colors.orange,
                          ),
                          title: Text("Dinner"),
                          trailing: Checkbox(
                            fillColor: MaterialStateProperty.all(Colors.orange),
                            checkColor: Colors.white,
                            side: BorderSide(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            splashRadius: 52,
                            value: true,
                            onChanged: (bool? value) {},
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Workshops Section
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Workshops",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Primary),
                            ),
                            SizedBox(height: 5),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget
                                  .ticket[ApiKey.ticket][ApiKey.workshops]
                                  .length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Icon(Icons.work, color: Primary),
                                  title: Text(widget.ticket[ApiKey.ticket]
                                          [ApiKey.workshops][index]
                                      [ApiKey.workshop][ApiKey.nameworkshop]),
                                  trailing: Checkbox(
                                    fillColor:
                                        MaterialStateProperty.all(Primary),
                                    checkColor: Colors.white,
                                    side: BorderSide(
                                        color: Colors.grey,
                                        style: BorderStyle.solid,
                                        width: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    splashRadius: 52,
                                    value: widget.ticket[ApiKey.ticket]
                                            [ApiKey.workshops][index]
                                        [ApiKey.hasAttended],
                                    onChanged: (bool? value) {},
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
