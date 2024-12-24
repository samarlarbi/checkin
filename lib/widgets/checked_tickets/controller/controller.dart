import 'package:checkin/widgets/checked_tickets/service/Checkedticketsservice.dart';
import 'package:flutter/material.dart';
import 'package:checkin/Api/httpClient.dart';

class CheckedTicketsController with ChangeNotifier {
  final CheckedTicketsService checkedTicketsService;
  List<Map<String, dynamic>> _checkedTickets = [];
  bool _isLoading = false;
  String _errorMessage = '';

  CheckedTicketsController()
      : checkedTicketsService = CheckedTicketsService(HttpClient());

  List<Map<String, dynamic>> get checkedTickets => _checkedTickets;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch checked invitations and update state
  Future<void> fetchCheckedTickets() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Call the service to fetch data
      var invitations = await checkedTicketsService.getCheckedTickets();
      _checkedTickets = invitations;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
