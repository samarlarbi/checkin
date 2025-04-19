import 'dart:convert';

import 'package:checkin/utils/MyAppBar.dart';
import 'package:checkin/utils/colors.dart';
import 'package:checkin/widgets/addAttendee/controller/addattendeecontroller.dart';
import 'package:flutter/material.dart';

class AddAttendeeView extends StatefulWidget {
  @override
  _AddAttendeeViewState createState() => _AddAttendeeViewState();
}

class _AddAttendeeViewState extends State<AddAttendeeView> {
  final _formKey = GlobalKey<FormState>();
  final AddAttendeeController _controller = AddAttendeeController();

  List workshops = [];
  List facs = [];
  List teams = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController teamController = TextEditingController();
  final TextEditingController ticketNoController = TextEditingController();

  String? fac;
  String? team;
  String? firstworkshop;
  String? secondworkshop;

  String? specialization;
  String? studyLevel;
  List<String> selectedWorkshops = [];
  Future<void>? submitFuture;
  Future<void>? formfuture;
  String errorMessage = ""; // Track errors to display in UI

  @override
  void initState() {
    super.initState();
    formfuture = _fetchFormData();
  }

  Future<void> _fetchFormData() async {
    try {
      await _controller.getForm();

      setState(() {
        workshops = _controller.form["workshops"];
        facs = _controller.form["facs"];
        teams = _controller.form["teams"];
      });
    } catch (e) {
      setState(() {
        errorMessage = 'no connection ';
      });
    }
  }

  Future _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> attendeeData = {
        "name": nameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "ticketNo": ticketNoController.text,
        "teamId": team,
        "facId": fac,
        "specialization": specialization,
        "studyLevel": studyLevel,
        "workshopIds": [firstworkshop, secondworkshop],
      };
      String jsonString = jsonEncode(attendeeData);

      try {
        await _controller.addAttendee(jsonString);

        print("Attendee Added: $jsonString");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Attendee Added!"),
            backgroundColor: const Color.fromARGB(255, 120, 219, 123),
          ),
        );
      } catch (e) {
        print("errooooor $e");
        setState(() {
          errorMessage = 'Failed to add attendee';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: "Add Attendee",
          leading: true,
        ),
        body: FutureBuilder(
            future: formfuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || errorMessage.isNotEmpty) {
                return ListView(children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            color: const Color.fromARGB(255, 108, 106, 106),
                            size: 50),
                        const SizedBox(height: 10),
                        Text(
                          errorMessage.isNotEmpty
                              ? errorMessage
                              : 'Error: ${snapshot.error}',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 108, 106, 106),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ]);
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        buildTextField("Name", nameController),
                        buildTextField("Email", emailController, isEmail: true),
                        buildTextField("Phone", phoneController,
                            isNumber: true),
                        buildTextField("ticket Number", ticketNoController,
                            isNumber: true),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(labelText: "Study Level"),
                          value: studyLevel,
                          items:
                              ["FIRST", "SECOND", "THIRD"].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) =>
                              setState(() => studyLevel = newValue),
                        ),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration:
                              InputDecoration(labelText: "Specialization"),
                          value: specialization,
                          items: ["ENGINEER", "OTHER"].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) =>
                              setState(() => specialization = newValue),
                        ),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(labelText: "Faculty"),
                          value: fac,
                          items: List<DropdownMenuItem<String>>.from(
                            facs.map<DropdownMenuItem<String>>((value) =>
                                DropdownMenuItem(
                                    value: value["id"],
                                    child: Text(value["name"]))),
                          ),
                          onChanged: (newValue) =>
                              setState(() => fac = newValue),
                        ),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(labelText: "Teams"),
                          value: team,
                          items: List<DropdownMenuItem<String>>.from(
                            teams.map<DropdownMenuItem<String>>((value) =>
                                DropdownMenuItem(
                                    value: value["id"],
                                    child: Text(value["name"]))),
                          ),
                          onChanged: (newValue) =>
                              setState(() => team = newValue),
                        ),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: "First Workshop",
                          ),
                          value: firstworkshop,
                          items: List<DropdownMenuItem<String>>.from(
                            workshops.map<DropdownMenuItem<String>>((value) =>
                                DropdownMenuItem(
                                    value: value["id"],
                                    child: Text(value["name"]))),
                          ),
                          onChanged: (newValue) =>
                              setState(() => firstworkshop = newValue),
                        ),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                              labelText: "Second Workshop",),
                          value: secondworkshop,
                          items: List<DropdownMenuItem<String>>.from(
                            workshops.map<DropdownMenuItem<String>>((value) =>
                                DropdownMenuItem(
                                    value: value["id"],
                                    child: Text(value["name"]))),
                          ),
                          onChanged: (newValue) =>
                              setState(() => secondworkshop = newValue),
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
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                return Text("Submit");
                              }
                            },
                          ),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(16.0)),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Primary)),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }));
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool isEmail = false, bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : (isNumber ? TextInputType.phone : TextInputType.text),
      validator: (value) => value!.isEmpty ? "Enter $label" : null,
    );
  }
}
