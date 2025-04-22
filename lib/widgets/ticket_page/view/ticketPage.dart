// ignore_for_file: prefer_const_constructors

import 'package:checkin/main.dart';
import 'package:checkin/utils/MyAppBar.dart';
import 'package:checkin/widgets/editAttendee/view/EditAttendeeView.dart';
import 'package:flutter/material.dart';

import '../../../Api/EndPoint.dart';
import '../../../utils/colors.dart';
import '../controller/controller.dart';

class MyTicketView extends StatefulWidget {
  final ticketno;

  MyTicketView({Key? key, this.ticketno}) : super(key: key);

  @override
  State<MyTicketView> createState() => _MyTicketViewState();
}

class _MyTicketViewState extends State<MyTicketView> {
  final ConfirmGeneralCheckinController _controller =
      ConfirmGeneralCheckinController();
  Future<void>? _checkinFuture;
  Future<void>? _checkinFuture2;
  Future<void>? _checkinDinnerFuture;
  String errorMessage = ""; // Track errors to display in UI

  Future<void>? _checkinWorkshopFuture;
  var test;

  @override
  void initState() {
    super.initState();
    _checkinFuture2 = fetchAttendee(widget.ticketno);
  }

  Future<void> fetchAttendee(String code) async {
    try {
      await _controller.getTiketbyTicketno(code);
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching attendee data, check your connection!";
      });
      debugPrint("Error fetching attendee: $e");
    }
  }

  Future<void> ConfirmWorkshopCheckin(ticketno, workshopid) async {
    try {
      await _controller.ConfirmWorkshopCheckin(ticketno, workshopid);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error confirming workshop: $e")),
      );
      debugPrint("Error confirming workshop: $e");
    }
  }

  Future<void> ConfirmCheckin(ticketno) async {
    try {
      await _controller.ConfirmCheckin(ticketno);
      setState(() {
        _controller.attendee[ApiKey.checked] =
            _controller.attendee[ApiKey.checked];
      });
      _controller.notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error confirming check-in: $e")),
      );
      debugPrint("Error confirming check-in: $e");
    }
  }

  Widget _buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline,
            color: const Color.fromARGB(255, 108, 106, 106), size: 50),
        const SizedBox(height: 10),
        Text(
          errorMessage.isNotEmpty ? errorMessage : 'Error loading data',
          style: TextStyle(
              color: const Color.fromARGB(255, 108, 106, 106),
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildCheckinButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _checkinFuture =
              ConfirmCheckin(_controller.attendee[ApiKey.ticketno]);
        });
      },
      style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width, 40),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: Primary, width: 1),
          )),
      child: FutureBuilder(
        future: _checkinFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Primary,
                strokeWidth: 2,
              ),
            );
          }

          final isChecked = _controller.attendee[ApiKey.checked] ?? false;
          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              Text(
                isChecked ? "Checked" : "Not checked",
                style: TextStyle(color: Primary, fontWeight: FontWeight.w900),
              ),
              SizedBox(width: 5),
              Icon(
                isChecked
                    ? Icons.done_outline_rounded
                    : Icons.watch_later_outlined,
                color: Primary,
                size: 20,
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildWorkshopItem(int index) {
    final workshop = _controller.attendee[ApiKey.workshops][index];
    return ListTile(
      leading: Icon(Icons.work, color: Primary),
      title: Text(workshop[ApiKey.workshop][ApiKey.nameworkshop]),
      trailing: Checkbox(
        key: Key(workshop[ApiKey.workshop][ApiKey.idworkshop].toString()),
        fillColor: MaterialStateProperty.all(Primary),
        checkColor: Colors.white,
        side: BorderSide(color: Colors.grey, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        value: workshop[ApiKey.hasAttended],
        onChanged: (bool? value) {
          setState(() {
            workshop[ApiKey.hasAttended] = value;
            _checkinWorkshopFuture = ConfirmWorkshopCheckin(
              _controller.attendee[ApiKey.ticketno],
              workshop[ApiKey.workshop][ApiKey.idworkshop],
            ).catchError((_) {
              setState(() => workshop[ApiKey.hasAttended] = !value!);
            });
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Attendee",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Primary,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/editattendee', arguments: {
                  'ticketno': _controller.attendee[ApiKey.ticketno],
                });
              }),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 229, 229, 229),
      body: FutureBuilder(
        future: _checkinFuture2,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          }
          if (snapshot.hasError || errorMessage.isNotEmpty) {
            return _buildErrorWidget();
          }
          if (!_controller.attendee.containsKey("attendee")) {
            return _buildErrorWidget();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  _controller.attendee["attendee"]
                                      [ApiKey.AttendeeName],
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 85, 84, 84),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  Text(
                                    "email",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 100, 100, 100),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    _controller.attendee["attendee"]
                                        [ApiKey.email],
                                    style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 92, 92, 92),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "ticket",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 100, 100, 100),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    _controller.attendee[ApiKey.ticketno]
                                        .toString(),
                                    style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 92, 92, 92),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            spacing: 5,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    Text(
                                      "Team",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 100, 100, 100),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      _controller.attendee["attendee"]
                                          [ApiKey.team][ApiKey.nameteam],
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 92, 92, 92),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        _buildCheckinButton(),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Workshops",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Primary,
                          ),
                        ),
                        SizedBox(height: 5),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              _controller.attendee[ApiKey.workshops].length,
                          itemBuilder: (context, index) {
                            return _buildWorkshopItem(index);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
