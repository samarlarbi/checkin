import 'package:flutter/material.dart';
import 'package:checkin/Api/httpClient.dart';
import '../service/service.dart';

class CheckinGuestController with ChangeNotifier {
  final GuestCheckinService guestCheckinService;
  Map<String, dynamic> _attendee = {};
  bool _isLoading = false;
  String _errorMessage = '';

  CheckinGuestController() : guestCheckinService = GuestCheckinService(HttpClient());

  Map<String, dynamic> get attendee => _attendee;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchCheckinGuest(ticketCode) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      var attendees = await guestCheckinService.checkin(ticketCode);
      _attendee = attendees;
      _isLoading = false;
      
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
