import 'package:flutter/material.dart';
import 'package:checkin/Api/httpClient.dart';
import '../service/checkin.dart';

class CheckinController with ChangeNotifier {
  final AttendeeCheckinService attendeeService;
  Map<String, dynamic> _attendee = {};
  bool _isLoading = false;
  String _errorMessage = '';

  CheckinController() : attendeeService = AttendeeCheckinService(HttpClient());

  Map<String, dynamic> get attendee => _attendee;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchCheckin(ticketCode) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      var attendees = await attendeeService.checkin(ticketCode);
      _attendee = attendees;
      print("Fetched attendees: $attendees");
    } catch (e) {
      _errorMessage = "Error fetching attendee data: $e";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
