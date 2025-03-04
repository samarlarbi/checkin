import 'package:checkin/Api/EndPoint.dart';
import 'package:flutter/material.dart';
import 'package:checkin/Api/httpClient.dart';

import '../services/services.dart';

class EditAttendeeController with ChangeNotifier {
  final EditAttendeeServices editAttendeeServices;
  Map<String, dynamic> _attendee = {};
  Map<String, dynamic> _checkedattendee = {};
  Map<String, dynamic> _workshopattendee = {};
  bool _isLoading = false;
  String _errorMessage = '';

  EditAttendeeController()
      : editAttendeeServices = EditAttendeeServices(HttpClient());

  Map<String, dynamic> get workshopattendee => _workshopattendee;
  Map<String, dynamic> get attendee => _attendee;
  Map<String, dynamic> get checkedattendee => _checkedattendee;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<Map<String, dynamic>> editAttendee(body) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      var attendees = await editAttendeeServices.editAttendee(body);
      print(attendees);
      return attendees;
    } catch (e) {
      _errorMessage = "Error fetching attendee data: $e";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return _attendee;
  }

  Future<Map<String, dynamic>> getTiketbyTicketno(ticketno) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      var attendees = await editAttendeeServices.getTiketbyTicketno(ticketno);
      _attendee = attendees;
      print("*******************00");
      print(attendees);
      return attendees;
    } catch (e) {
      _errorMessage = "Error fetching attendee data: $e";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return _attendee;
  }
}
