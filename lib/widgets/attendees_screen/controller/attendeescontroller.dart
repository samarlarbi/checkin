import 'package:flutter/material.dart';
import 'package:checkin/Api/httpClient.dart';

import '../service/attendeeservice.dart';

class AttendeeController with ChangeNotifier {
  final AttendeeService attendeeService;
  List<Map<String, dynamic>> _attendees = [];
  bool _isLoading = false;
  String _errorMessage = '';

  AttendeeController() : attendeeService = AttendeeService(HttpClient());

  List<Map<String, dynamic>> get attendee => _attendees;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch checked invitations and update state
  Future<void> fetchAttendee() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      var attendees = await attendeeService.getAttendees();
      _attendees = attendees;
      print("//////" + attendees.toString());
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
