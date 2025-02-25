// ignore_for_file: prefer_const_constructors

import 'package:checkin/main.dart';
import 'package:checkin/utils/MyAppBar.dart';
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

  Future<void>? _checkinWorkshopFuture;
  var test;
  @override
  void initState() {
    super.initState();
    _checkinFuture2 = fetchAttendee(widget.ticketno);
  }

  Future<void> fetchAttendee(String code) async {
    try {
      print(code);
      await _controller.getTiketbyTicketno(code);
    } catch (e) {
      showAboutDialog(context: context, children: [
        Text("Error fetching attendee data: $e"),
      ]);

      print(_controller.errorMessage);
    } finally {}
  }

  Future<void> ConfirmWorkshopCheckin(ticketno, workshopid) async {
    try {
      var attendee =
          await _controller.ConfirmWorkshopCheckin(ticketno, workshopid);
    } catch (e) {
      showAboutDialog(context: context, children: [
        Text("Error fetching attendee data: $e"),
      ]);

      print(_controller.errorMessage);
    } finally {}
  }

  Future<void> ConfirmDinner(ticketno) async {
    try {
      var attendee = await _controller.ConfirmDinner(ticketno);
    } catch (e) {
      showAboutDialog(context: context, children: [
        Text("Error fetching attendee data: $e"),
      ]);

      print(_controller.errorMessage);
    } finally {
      _controller.notifyListeners();
    }
  }

  Future<void> ConfirmCheckin(ticketno) async {
    try {
      var attendee = await _controller.ConfirmCheckin(ticketno);
      setState(() {
        _controller.attendee[ApiKey.checked] =
            _controller.attendee[ApiKey.checked];
      });
    } catch (e) {
      showAboutDialog(context: context, children: [
        Text("Error fetching attendee data: $e"),
      ]);

      print(_controller.errorMessage);
    } finally {
      _controller.notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    double maxwidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 229, 229, 229),
        body: FutureBuilder(
          future: _checkinFuture2,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return Container(
                color: Background,
                child: Stack(
                  children: [
                    ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.all(0),
                          height: MediaQuery.of(context).size.height * 0.3,
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
                                    icon: const Icon(
                                        Icons.mode_edit_outline_outlined),
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
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                            child: Icon(
                                              Icons.person_outline_rounded,
                                              color: Colors.white,
                                              size: 40,
                                            )),
                                        SizedBox(width: 10),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _controller.attendee["attendee"]
                                                  [ApiKey.AttendeeName],
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              "+216 " +
                                                  _controller
                                                          .attendee["attendee"]
                                                      [ApiKey.email],
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _checkinFuture = ConfirmCheckin(
                                                    _controller.attendee[ApiKey
                                                        .ticketno]); // Trigger the Future when button is pressed
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white),
                                            child: FutureBuilder(
                                                future: _checkinFuture,
                                                initialData: true,
                                                builder: ((context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Primary,
                                                        strokeWidth: 2,
                                                      ),
                                                    );
                                                  } else if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    if (snapshot.hasError) {
                                                      return Text(
                                                        "try again",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      );
                                                    }
                                                    return Wrap(
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .center,
                                                      alignment:
                                                          WrapAlignment.center,
                                                      children: [
                                                        Text(
                                                          _controller.attendee[
                                                                  ApiKey
                                                                      .checked]
                                                              ? "Checked"
                                                              : "Not checked",
                                                          style: TextStyle(
                                                              color: Primary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                        ),
                                                        SizedBox(width: 5),
                                                        _controller.attendee[
                                                                ApiKey.checked]
                                                            ? Icon(
                                                                Icons
                                                                    .done_outline_rounded,
                                                                color: Primary,
                                                                size: 20,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .watch_later_outlined,
                                                                color: Primary,
                                                                size: 20,
                                                              )
                                                      ],
                                                    );
                                                  }
                                                  return Wrap(
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                                      Text(
                                                        _controller.attendee[
                                                                ApiKey.checked]
                                                            ? "Checked"
                                                            : "not checked",
                                                        style: TextStyle(
                                                            color: Primary,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                      SizedBox(width: 5),
                                                      _controller.attendee[
                                                              ApiKey.checked]
                                                          ? Icon(
                                                              Icons
                                                                  .done_outline_rounded,
                                                              color: Primary,
                                                              size: 20,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .watch_later_outlined,
                                                              color: Primary,
                                                              size: 20,
                                                            )
                                                    ],
                                                  );
                                                }))),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Wrap(
                                alignment: WrapAlignment.spaceEvenly,
                                children: [
                                  // Container(
                                  //   width: maxwidth * 0.45,
                                  //   padding: EdgeInsets.all(5),
                                  //   child: Column(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.center,
                                  //     children: [
                                  //       Text(
                                  //         "University",
                                  //         style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 15,
                                  //             fontWeight: FontWeight.w900),
                                  //       ),
                                  //       Text(
                                  //         this._controller.attendee[ApiKey.fac]
                                  //             [ApiKey.namefac],
                                  //         style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 13,
                                  //             fontWeight: FontWeight.w500),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  Container(
                                    width: maxwidth * 0.45,
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "ticket",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        Text(
                                          _controller.attendee[ApiKey.ticketno]
                                              .toString(),
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
                          top: MediaQuery.of(context).size.height * 0.3),
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
                                          this._controller.attendee["attendee"]
                                              [ApiKey.team][ApiKey.nameteam],
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
                                trailing: FutureBuilder(
                                  future: _checkinDinnerFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Primary,
                                          strokeWidth: 2,
                                        ),
                                      );
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        return Text(
                                          "try again",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w900),
                                        );
                                      }
                                    }
                                    return Checkbox(
                                      fillColor: MaterialStateProperty.all(
                                          Colors.orange),
                                      checkColor: Colors.white,
                                      side: const BorderSide(
                                        color: Colors.grey,
                                        style: BorderStyle.solid,
                                        width: 5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      splashRadius: 52,
                                      value:
                                          _controller.attendee[ApiKey.hadMeal],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _checkinDinnerFuture =
                                              ConfirmDinner(widget.ticketno);
                                        });
                                      },
                                    );
                                  },
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
                                    itemCount: _controller
                                        .attendee[ApiKey.workshops].length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading:
                                            Icon(Icons.work, color: Primary),
                                        title: Text(_controller
                                                    .attendee[ApiKey.workshops]
                                                [index][ApiKey.workshop]
                                            [ApiKey.nameworkshop]),
                                        trailing: FutureBuilder(
                                          future: _checkinWorkshopFuture,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Primary,
                                                  strokeWidth: 2,
                                                ),
                                              );
                                            } else if (snapshot
                                                    .connectionState ==
                                                ConnectionState.done) {
                                              if (snapshot.hasError) {
                                                return Text(
                                                  "try again",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                );
                                              }
                                            }
                                            return Checkbox(
                                              key: Key(_controller
                                                  .attendee[ApiKey.workshops]
                                                      [index][ApiKey.workshop]
                                                      [ApiKey.idworkshop]
                                                  .toString()),
                                              fillColor:
                                                  MaterialStateProperty.all(
                                                      Primary),
                                              checkColor: Colors.white,
                                              side: const BorderSide(
                                                color: Colors.grey,
                                                style: BorderStyle.solid,
                                                width: 5,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              splashRadius: 52,
                                              value: _controller.attendee[
                                                      ApiKey.workshops][index]
                                                  [ApiKey.hasAttended],
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  // Optimistic UI Update
                                                  _controller.attendee[ApiKey
                                                              .workshops][index]
                                                          [ApiKey.hasAttended] =
                                                      value;

                                                  // Confirm Check-in
                                                  _checkinWorkshopFuture =
                                                      ConfirmWorkshopCheckin(
                                                    _controller.attendee[
                                                        ApiKey.ticketno],
                                                    _controller.attendee[ApiKey
                                                                    .workshops]
                                                                [index]
                                                            [ApiKey.workshop]
                                                        [ApiKey.idworkshop],
                                                  ).catchError((error) {
                                                    setState(() {
                                                      _controller.attendee[ApiKey
                                                                      .workshops]
                                                                  [index]
                                                              [
                                                              ApiKey
                                                                  .hasAttended] =
                                                          !value!;
                                                    });
                                                    // Show a snackbar or dialog with the error message
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Check-in failed. Please try again.')),
                                                    );
                                                  });
                                                });
                                              },
                                            );
                                          },
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
              );
            }
          },
        ));
  }
}
