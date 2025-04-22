import 'dart:convert';
import 'package:checkin/Api/httpClient.dart';
import 'package:http/http.dart' as http;

class StatisticsService {
  final HttpClient api;

  StatisticsService() : api = HttpClient();

  Future<Map<String, dynamic>> getGeneralStatistics() async {
    try {
      final response = await api.get('registration/statistics/general');

      return response;
    } catch (e) {
      print('Error fetching statistics: $e');
      return {};
    }
  }
}
