import 'package:checkin/Api/EndPoint.dart';
import 'package:checkin/Api/httpClient.dart';

class ConfirmGeneralCheckinService {
  final HttpClient api;

  ConfirmGeneralCheckinService(this.api);

  Future<Map<String, dynamic>> getTiketbyTicketno(ticketno) async {
    try {
      String endpoint = EndPoint.getticketbyticketno + "/" + ticketno;
      final response = await api.get(endpoint);
      print("respon-----------------");
      print(response);
      return response;
    } catch (e) {
      print("Error fetching ticket: $e");
      return {};
    }
  }

  Future<Map<String, dynamic>> getTiketbyQRcode(qrcode) async {
    try {
      String endpoint = EndPoint.getticketbyqrcode + "/" + qrcode;
      final response = await api.get(endpoint);
      print("respon-----------------");
      print(response);
      return response;
    } catch (e) {
      print("Error fetching ticket: $e");
      return {};
    }
  }

  Future<Map<String, dynamic>> ConfirmDinner(ticketno) async {
    try {
      String endpoint = EndPoint.confirm_dinner;
      final response = await api.patch(endpoint, body: {"ticketNo": ticketno});
      print("respon-----------------");
      print(response);
      return response;
    } catch (e) {
      print("Error fetching ticket: $e");
      return {};
    }
  }

  Future<Map<String, dynamic>> CheckinWorkshop(ticketno, workshopid) async {
    try {
      String endpoint = EndPoint.confirm_workshop_checkin;
      print("-----------servece" + ticketno + " " + workshopid);
      final response = await api.patch(endpoint,
          body: {"ticketNo": ticketno, "workshopId": workshopid});
      print("respon-----------------");
      print(response);
      return response;
    } catch (e) {
      print("Error fetching ticket: $e");
      return {};
    }
  }

  Future<Map<String, dynamic>> checkin(ticketno) async {
    try {
      String endpoint = EndPoint.confirm_general_checkin;
      final response = await api.patch(endpoint, body: {
        "ticketNo": ticketno,
      });
      print("-----------servece");
      print(response);
      return response;
    } catch (e) {
      print("Error fetching ticket: $e");
      return {};
    }
  }
}
