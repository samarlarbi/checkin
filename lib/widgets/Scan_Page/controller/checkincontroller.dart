import 'package:flutter/material.dart';
import 'package:checkin/Api/httpClient.dart';
import '../service/checkin.dart';

class CheckinController with ChangeNotifier {
  final AttendeeCheckinService attendeeService;
  Map<String, dynamic> _attendee = {};
  bool _isLoading = false;
  String _errorMessage = '';

  // Constructor accepts token (for authentication) and HttpClient (for HTTP requests)
  CheckinController({required String token})
      : attendeeService = AttendeeCheckinService(token: token);

  Map<String, dynamic> get attendee => _attendee;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch check-in data based on the ticket code
  Future<void> fetchCheckin(String ticketCode) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      var response = await attendeeService.verifyQRCode(ticketCode);

      // Check if the response contains an error
      if (response.containsKey("error")) {
        _errorMessage = response["error"];
      } else {
        // Update the attendee data if there is no error
        _attendee = response;
      }

      // Optionally log the response for debugging
      print("Fetched attendee data: $response");

    } catch (e) {
      _errorMessage = "Error fetching attendee data: $e";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
