import 'package:checkin/Api/EndPoint.dart';
import 'package:flutter/material.dart';
import 'package:checkin/Api/httpClient.dart';
import '../service/service.dart';

class ConfirmGeneralCheckinController with ChangeNotifier {
  final ConfirmGeneralCheckinService confirmGeneralCheckinService;
  Map<String, dynamic> _attendee = {};
  Map<String, dynamic> _checkedattendee = {};
  Map<String, dynamic> _workshopattendee = {};
  bool _isLoading = false;
  String _errorMessage = '';

  ConfirmGeneralCheckinController()
      : confirmGeneralCheckinService =
            ConfirmGeneralCheckinService(HttpClient());

  Map<String, dynamic> get workshopattendee => _workshopattendee;
  Map<String, dynamic> get attendee => _attendee;
  Map<String, dynamic> get checkedattendee => _checkedattendee;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<Map<String, dynamic>> getTiketbyQRcode(qrcode) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      var attendees =
          await confirmGeneralCheckinService.getTiketbyQRcode(qrcode);
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

  Future<Map<String, dynamic>> getTiketbyTicketno(ticketno) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      var attendees =
          await confirmGeneralCheckinService.getTiketbyTicketno(ticketno);
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

  Future<Map<String, dynamic>> ConfirmDinner(ticketno) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      var attendees =
          await confirmGeneralCheckinService.ConfirmDinner(ticketno);
      _attendee[ApiKey.hadMeal] = attendees[ApiKey.hadMeal];
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

  // ignore: non_constant_identifier_names
  Future<Map<String, dynamic>> ConfirmWorkshopCheckin(
      ticketno, workshopid) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      var attendees = await confirmGeneralCheckinService.CheckinWorkshop(
          ticketno, workshopid);
      _workshopattendee = attendees;
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
    return _workshopattendee;
  }

  Future<void> ConfirmCheckin(ticketno) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      var attendees = await confirmGeneralCheckinService.checkin(ticketno);
      _attendee[ApiKey.checked] = attendees[ApiKey.checked];
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
