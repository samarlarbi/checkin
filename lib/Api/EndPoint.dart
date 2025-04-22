import 'package:checkin/utils/tokenprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class EndPoint {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://';

  // static const String baseUrl = 'http://
  static const String login = 'auth/login';

  static const String confirm_dinner = "registration/confirm-dinner";
  static const String getallAttendees = 'registration';
  static const String registration = 'registration';

  static const String getticketbyqrcode = 'registration/verify-qrcode/';
  static const String getticketbyticketno = 'registration/verify-ticketId';
  static const String confirm_general_checkin =
      'registration/confirm-general-checkin';
  static const String getform = 'registration/get-form';

  static const String confirm_workshop_checkin =
      "registration/confirm-workshop-checkin";

  static const String checkinguest = 'api/attendees/checkinguest';
  static const int timeoutDuration = 15; // Timeout duration in seconds
}

class ApiKey {
  static String apiKey = 'Authorization';
  static String apiValue = 'Basic 5885deea-f4c3-c5a-b8c-7e1148a33a10';
  // ignore: prefer_interpolation_to_compose_strings

  static String email = "email";
  static String password = "password";
  static String idAttendee = "idAttendee";
  static String AttendeeName = "name";
  static String phone = "phone";
  static String studylevel = "studyLevel";
  static String specialization = "specialization";
  static String fac = "fac";
  static String idfac = "id";
  static String namefac = "name";
  static String team = "team";
  static String idteam = "id";
  static String nameteam = "name";

  static String ticket = "ticket";
  static String ticketno = "ticketNo";
  static String hadMeal = "hadMeal";
  static String error = "error";
  static String message = "message";

  static String workshops = "workshops";
  static String workshop = "workshop";
  static String hasAttended = "hasAttended";
  static String idworkshop = "id";
  static String nameworkshop = "name";
  static String id = "id";

  static String key = "key";
  static String limit = "limit";
  static String page = "page";
  static String annee = "annee";
  static String num_contrat = "num_contrat";
  static String status = "status";
  static String checked = "done";
}
