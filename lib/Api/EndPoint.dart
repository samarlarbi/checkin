import 'package:flutter_dotenv/flutter_dotenv.dart';

class EndPoint {
  static final String baseUrl = "http://192.168.1.40:4500/api/v1";

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
  static String token =
      "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2RlIjoiMTIzNDU2Nzg5IiwiaWF0IjoxNzM5MzczODc5fQ.oeAh7EoHx3APxKhrk_mNxwwlCYFifidxcA9xogGDZFA";

  static String Attendeeid = "id";

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
