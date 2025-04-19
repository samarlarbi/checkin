import 'package:checkin/models/attendee.dart';
import 'package:checkin/widgets/addAttendee/service/addattendeeservices.dart';

class AddAttendeeController {
  bool isLoading = false;
  String errorMessage = "";
  Map<String, dynamic> form = {};

  final AddAttendeeService addattendeeService;

  AddAttendeeController() : addattendeeService = AddAttendeeService();
  Future<void> getForm() async {
    if (isLoading) return;
    isLoading = true;
    errorMessage = "";

    try {
      form = await addattendeeService.getFrom();

      print("Fetched form data: $form");
      print(form["workshops"]);
    } catch (e) {
      errorMessage = "Error fetching data: $e";
            throw Exception("Error fetching form: $e");

    }

    isLoading = false;
  }

  Future<void> addAttendee(attendee) async {
    if (isLoading) return;
    isLoading = true;
    errorMessage = "";

    try {
      print("controller---$attendee");
      await addattendeeService.addAttendee(attendee);
    } catch (e) {
      errorMessage = "Error add attendee: $e";
      throw Exception("Error adding attendee : $e");
    }

    isLoading = false;
  }
}
