import 'dart:convert';

import 'package:checkin/utils/MyAppBar.dart';
import 'package:checkin/utils/colors.dart';
import 'package:checkin/widgets/addAttendee/controller/addattendeecontroller.dart';
import 'package:checkin/widgets/ticket_page/view/ticketPage.dart';
import 'package:flutter/material.dart';

import '../controllers/controllers.dart';

class EditAttendeeView extends StatefulWidget {
  final String ticketno;

  EditAttendeeView({required this.ticketno});

  @override
  _EditAttendeeViewState createState() => _EditAttendeeViewState();
}

class _EditAttendeeViewState extends State<EditAttendeeView> {
  final _formKey = GlobalKey<FormState>();
  final EditAttendeeController _controller = EditAttendeeController();

  List workshops = [];
  List facs = [];
  List teams = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController teamController = TextEditingController();
  final TextEditingController ticketNoController = TextEditingController();
  final AddAttendeeController _controller2 = AddAttendeeController();

  String? fac;
  String? team;
  String? firstworkshop;
  String? secondworkshop;

  String? specialization;
  String? studyLevel;
  List<String> selectedWorkshops = [];
  Future<void>? submitFuture;
  Future<void>? _attendeeFuture;

  @override
  void initState() {
    super.initState();
    _fetchFormData();
    _attendeeFuture = fetchAttendee(widget.ticketno);
  }

  Future<void> fetchAttendee(String code) async {
    try {
      await _controller.getTiketbyTicketno(code);
      setState(() {
        nameController.text = _controller.attendee["attendee"]['name'] ?? '';
  emailController.text = _controller.attendee["attendee"]['email'] ?? '';
  phoneController.text = _controller.attendee["attendee"]['phone'] ?? '';
  ticketNoController.text = _controller.attendee['ticketNo']?.toString() ?? '';

  fac = _controller.attendee["attendee"]['facId'];
  team = _controller.attendee["attendee"]['team']?['id'];
  specialization = _controller.attendee["attendee"]['specialization'];
  studyLevel = _controller.attendee["attendee"]['studyLevel'];

  if (_controller.attendee['workshops'] != null && _controller.attendee['workshops'].isNotEmpty) {
    firstworkshop = _controller.attendee['workshops'][0]['workshop']['id'];
    secondworkshop = _controller.attendee['workshops'][1]['workshop']['id'];
  } });
    } catch (e) {
      showAboutDialog(context: context, children: [
        Text("Error fetching attendee data: $e"),
      ]);
    }
  }

  Future<void> _fetchFormData() async {
    try {
      await _controller2.getForm();
      setState(() {
        workshops = _controller2.form["workshops"];
        facs = _controller2.form["facs"];
        teams = _controller2.form["teams"];
      });
    } catch (error) {
      print("Error fetching form data: $error");
    }
  }

  Future _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> attendeeData = {
        "id": _controller.attendee["attendee"]['id'],
        "name": nameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "ticketNo": ticketNoController.text,
        "teamId": team,
        "facId": fac,
        "specialization": specialization,
        "studyLevel": studyLevel,
        "workshopIds": [firstworkshop, secondworkshop]
      };

      try {
        await _controller.editAttendee(attendeeData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Attendee Updated!")),
        );
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      leading: IconButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyTicketView(ticketno: _controller.attendee['ticketNo'].toString(),)),
                (Route<dynamic> route) => false,
              ),
              icon: const Icon(Icons.arrow_back),
              color: const Color.fromARGB(255, 86, 86, 86),
            )
        ,
      title: Text(
       "Edit Information",
        style: const TextStyle(color: Color.fromARGB(255, 69, 69, 69)),
      ),
      centerTitle: true,
      backgroundColor: Background,
      elevation: 0,
    ),
      body: FutureBuilder(
        future: _attendeeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    buildTextField("Name", nameController),
                    buildTextField("Email", emailController, isEmail: true),
                    buildTextField("Phone", phoneController, isNumber: true),
                    buildTextField("Ticket Number", ticketNoController, isNumber: true),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: "Study Level"),
                      value: studyLevel,
                      items: ["FIRST", "SECOND", "THIRD"].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) => setState(() => studyLevel = newValue),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: "Specialization"),
                      value: specialization,
                      items: ["ENGINEER", "OTHER"].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) => setState(() => specialization = newValue),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: "Faculty"),
                      value: fac,
                      items: List<DropdownMenuItem<String>>.from(
                        facs.map<DropdownMenuItem<String>>((value) => DropdownMenuItem(
                          value: value["id"],
                          child: Text(value["name"]),
                        )),
                      ),
                      onChanged: (newValue) => setState(() => fac = newValue),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: "Teams"),
                      value: team,
                      items: List<DropdownMenuItem<String>>.from(
                        teams.map<DropdownMenuItem<String>>((value) => DropdownMenuItem(
                          value: value["id"],
                          child: Text(value["name"]),
                        )),
                      ),
                      onChanged: (newValue) => setState(() => team = newValue),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: "First Workshop"),
                      value: firstworkshop,
                      items: List<DropdownMenuItem<String>>.from(
                        workshops.map<DropdownMenuItem<String>>((value) => DropdownMenuItem(
                          value: value["id"],
                          child: Text(value["name"]),
                        )),
                      ),
                      onChanged: (newValue) => setState(() => firstworkshop = newValue),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: "Second Workshop"),
                      value: secondworkshop,
                      items: List<DropdownMenuItem<String>>.from(
                        workshops.map<DropdownMenuItem<String>>((value) => DropdownMenuItem(
                          value: value["id"],
                          child: Text(value["name"]),
                        )),
                      ),
                      onChanged: (newValue) => setState(() => secondworkshop = newValue),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          submitFuture = _submitForm();
                        });
                      },
                      child: FutureBuilder<void>(
                        future: submitFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            return Text("Submit");
                          }
                        },
                      ),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(16.0)),
                        backgroundColor: MaterialStateProperty.all<Color>(Primary),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool isEmail = false, bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isEmail ? TextInputType.emailAddress : (isNumber ? TextInputType.phone : TextInputType.text),
      validator: (value) => value!.isEmpty ? "Enter $label" : null,
    );
  }
}
