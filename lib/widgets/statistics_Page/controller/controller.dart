import 'package:checkin/widgets/statistics_Page/services/services.dart';

class StatisticsController {
  String errorMessage = '';
  bool isLoading = false;
  Map<String, dynamic> statistics = {};
  StatisticsService? _service;
  StatisticsController() : _service = StatisticsService();

  Future<void> fetchStatistics() async {
    try {
      isLoading = true;
      errorMessage = '';

      final response = await _service!.getGeneralStatistics();
      print(response);

      if (response.isEmpty) {
        errorMessage = 'No statistics found';
      } else {
        statistics = response;
      }
    } catch (e) {
      errorMessage = 'Error fetching statistics: ${e.toString()}';
      print(errorMessage);
    } finally {
      isLoading = false;
    }
  }
}
