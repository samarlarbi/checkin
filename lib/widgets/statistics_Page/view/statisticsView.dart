import 'dart:math';

import 'package:checkin/utils/tokenprovider.dart';
import 'package:checkin/widgets/statistics_Page/controller/controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/web_symbols_icons.dart';
import 'package:provider/provider.dart';
import '../../../utils/MyAppBar.dart';
import '../../../utils/colors.dart';
import '../../addAttendee/controller/addattendeecontroller.dart';
import '../../attendees_screen/controller/attendeescontroller.dart';

class StaticsView extends StatefulWidget {
  const StaticsView({super.key});

  @override
  _StaticsViewState createState() => _StaticsViewState();
}

class _StaticsViewState extends State<StaticsView> {
  String errorMessage = "";
  Future<void>? _checkinFuture;
  List<Map<String, dynamic>> legends = [];
  List<Map<String, dynamic>> statics = [];
  final StatisticsController controller = StatisticsController();
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _checkinFuture = _fetchStatistics();
  }

  Future<void> _showErrorDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Are you sure you want to logout?"),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('yess'),
              onPressed: () {
                Logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> Logout(BuildContext context) async {
    try {
      await Provider.of<AccessTokenProvider>(context, listen: false)
          .clearTokens();
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      _showErrorDialog(context, "An error occurred: $e");
    }
  }

  Future<void> _fetchStatistics() async {
    try {
      await controller.fetchStatistics();
      if (!mounted) return;

      setState(() {
        errorMessage = controller.errorMessage;

        // Initialize legends with proper typing
        legends = (controller.statistics["workshops"] as List)
            .map<Map<String, dynamic>>((workshop) {
          final hue = _random.nextDouble() * 360;
          return {
            "text": workshop["name"] as String,
            "value": workshop["attendeesCount"] as int,
            "color": HSLColor.fromAHSL(1.0, hue, 0.7, 0.8).toColor(),
            "workshop": workshop,
          };
        }).toList();

        // Initialize statics with proper typing
        statics = [
          {
            "icon": Icons.people,
            "value": controller.statistics["general"]["totalAttendees"] as int,
            "title": "Attendees",
          },
          {
            "icon": Icons.done_outline_rounded,
            "value":
                controller.statistics["general"]["presentAttendees"] as int,
            "title": "Checked In",
          },
          {
            "icon": Icons.groups_2,
            "value": controller.statistics["general"]["totalTeams"] as int,
            "title": "Teams",
          },
        ];
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: MyAppBar(
        title: "Statistics",
        leading: false,
        action: [
          IconButton(
            icon: const Icon(Icons.logout , color: Colors.black),
            onPressed: () {
              _showErrorDialog(context, "Are you sure you want to logout?");
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _checkinFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Color.fromARGB(255, 108, 106, 106), size: 50),
                    const SizedBox(height: 10),
                    Text(
                      errorMessage.isNotEmpty
                          ? errorMessage
                          : 'Error: ${snapshot.error}',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 108, 106, 106),
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Chart Container
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                sections: _chartSections(),
                                centerSpaceRadius: 60,
                                sectionsSpace: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildLegend(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Stats Cards
                    _buildStatsCards(),
                    const SizedBox(height: 20),
                    // Workshop Attendees List
                    _buildWorkshopsList(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  List<PieChartSectionData> _chartSections() {
    if (legends.isEmpty) return [];

    final totalAttendees =
        controller.statistics["general"]["totalAttendees"] as int;
    if (totalAttendees == 0) return [];

    final checkedInTotal =
        legends.fold<int>(0, (sum, legend) => sum + (legend["value"] as int));
    final uncheckedAttendees = totalAttendees - checkedInTotal;

    final sections = <PieChartSectionData>[];

    for (final legend in legends) {
      final percentage = (legend["value"] as int) / totalAttendees * 100;
      sections.add(
        PieChartSectionData(
          color: legend["color"] as Color,
          value: percentage,
          title: percentage >= 5 ? '${percentage.toStringAsFixed(1)}%' : '',
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
          radius: 50,
        ),
      );
    }

    if (uncheckedAttendees > 0) {
      final uncheckedPercentage = uncheckedAttendees / totalAttendees * 100;
      sections.add(
        PieChartSectionData(
          color: Colors.grey[400]!,
          value: uncheckedPercentage,
          title: uncheckedPercentage >= 5
              ? '${uncheckedPercentage.toStringAsFixed(1)}%'
              : '',
          titleStyle: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
          radius: 50,
        ),
      );
    }

    return sections;
  }

  Widget _buildLegend() {
    final totalAttendees =
        controller.statistics["general"]["totalAttendees"] as int;
    final checkedInTotal =
        legends.fold<int>(0, (sum, legend) => sum + (legend["value"] as int));
    final uncheckedAttendees = totalAttendees - checkedInTotal;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: [
        ...legends.map((legend) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: legend["color"] as Color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 80,
                child: Text(
                  legend["text"] as String,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        }).toList(),
        if (uncheckedAttendees > 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const SizedBox(
                width: 80,
                child: Text(
                  "Not Checked In",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth / 3 - 10;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: statics.map((elem) {
              return Container(
                width: cardWidth,
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      elem["icon"] as IconData,
                      size: 30,
                      color: Primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "+${elem["value"]}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      elem["title"] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildWorkshopsList() {
    final totalAttendees =
        controller.statistics["general"]["totalAttendees"] as int;
    final checkedInTotal =
        legends.fold<int>(0, (sum, w) => sum + (w["value"] as int));
    final uncheckedAttendees = totalAttendees - checkedInTotal;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "Workshop Attendance Details",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          ...legends.map((workshop) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: workshop["color"] as Color,
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(
                  workshop["text"] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
                trailing: Text(
                  "${workshop["value"]} attendees",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
            );
          }).toList(),
          if (uncheckedAttendees > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                ),
                title: const Text(
                  "Not Checked In",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
                trailing: Text(
                  "$uncheckedAttendees attendees",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
