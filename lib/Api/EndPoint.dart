class EndPoint {
  static const String baseUrl = 'http://localhost:4500/api/v1';

  static const String getallAttendees = 'registration';
  static const String getcheckedticket = 'api/attendees/checked';
  static const String checkbycodeticket = 'registration/verify-qrcode/';
//  static const String checkbycodeticket = 'api/attendees/checkbycodeticket';
  static const String checkinguest = 'api/attendees/checkinguest';
  static const String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2RlIjoiaG1kNWlkZW1pdCIsImlhdCI6MTczOTAwNjI0NX0.c0PlVESmeORinVRy-JPBB6JEW4qMGfe1-ynzHV7ysZc";
  static const int timeoutDuration = 15; // Timeout duration in seconds
}

class ApiKey {
  static String apiKey = 'Authorization';
  static String apiValue = 'Basic 5885deea-f4c3-c5a-b8c-7e1148a33a10';
  static String Attendeeid = "id";

  static String email = "email";
  static String password = "password";
  static String token = "Acces_Token";
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
  static String tickethadMeal = "hadMeal";
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
