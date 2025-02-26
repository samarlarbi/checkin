import 'package:flutter/material.dart';



class AddAttendeeView extends StatefulWidget {
  @override
  _AddAttendeeViewState createState() => _AddAttendeeViewState();
}

class _AddAttendeeViewState extends State<AddAttendeeView> {
  final _formKey = GlobalKey<FormState>();

  // Form Fields
  String name = "";
  String email = "";
  String phone = "";
  String teamName = "";
  String facName = "";
  String specialization = "";
  String ticketNo = "";
  String studyLevel = "";

  List<String> workshops = [
    "Workshop 1",
    "Workshop 2",
    "Workshop 3"
  ];
  List<String> selectedWorkshops = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Attendee")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField("Name", (value) => name = value),
              buildTextField("Email", (value) => email = value, isEmail: true),
              buildTextField("Phone", (value) => phone = value, isNumber: true),
              buildTextField("Team Name", (value) => teamName = value),
              buildTextField("Faculty Name", (value) => facName = value),
              buildTextField("Specialization", (value) => specialization = value),
              buildTextField("Ticket No", (value) => ticketNo = value),
              
              DropdownButtonFormField<String>(
                value: studyLevel,
                decoration: InputDecoration(labelText: "Study Level"),
                items: ["Undergraduate", "Postgraduate"]
                    .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                    .toList(),
                onChanged: (value) => setState(() => studyLevel = value!),
              ),

              SizedBox(height: 16),
              Text("Select Workshops", style: TextStyle(fontWeight: FontWeight.bold)),

              ...workshops.map((workshop) => CheckboxListTile(
                title: Text(workshop),
                value: selectedWorkshops.contains(workshop),
                onChanged: (bool? checked) {
                  setState(() {
                    if (checked == true) {
                      selectedWorkshops.add(workshop);
                    } else {
                      selectedWorkshops.remove(workshop);
                    }
                  });
                },
              )),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, Function(String) onSaved, {bool isEmail = false, bool isNumber = false}) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: isEmail ? TextInputType.emailAddress : (isNumber ? TextInputType.phone : TextInputType.text),
      validator: (value) => value!.isEmpty ? "Enter $label" : null,
      onSaved: (value) => onSaved(value!),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Map<String, dynamic> attendeeData = {
        "name": name,
        "email": email,
        "phone": phone,
        "teamName": teamName,
        "facName": facName,
        "specialization": specialization,
        "ticketNo": ticketNo,
        "studyLevel": studyLevel,
        "workshopIds": selectedWorkshops,
      };

      print("Attendee Added: $attendeeData");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Attendee Added!")));
    }
  }
}
