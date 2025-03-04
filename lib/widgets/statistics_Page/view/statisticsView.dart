import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/web_symbols_icons.dart';
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
  final AttendeeController _controller = AttendeeController();
  final AddAttendeeController _controller2 = AddAttendeeController();

  Future<void>? _checkinFuture;

  List<Map<String, dynamic>> legends = [];

  late final List<Map<String, dynamic>> statics = [
    {
      "titre": "Attendees",
      "icon": Icons.people_alt_rounded,
      "value": _controller.attendees.length
    },
    {
      "titre": "checked",
      "icon": Icons.check_circle_outlined,
      "value": _controller.attendees.where((attendee) {
        return attendee["ticket"]["done"] == true;
      }).length
    },
    {
      "titre": "Teams",
      "icon": Icons.groups_2,
      "value": _controller2.form["teams"].length
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkinFuture = fetchAttendees();
  }

  Future<void> fetchAttendees({String search = ""}) async {
    try {
      final response = await _controller.fetchAttendees();

      await _controller2.getForm();

      Map<String, int> workshopAttendance = {};

      for (var attendee in _controller.attendees) {
        for (var workshopEntry in attendee["ticket"]["workshops"]) {
          String workshopName = workshopEntry["workshop"]["name"];
          workshopAttendance[workshopName] = 0;
        }
      }

      for (var attendee in _controller.attendees) {
        for (var workshopEntry in attendee["ticket"]["workshops"]) {
          if (workshopEntry["hasAttended"] == true) {
            String workshopName = workshopEntry["workshop"]["name"];
            workshopAttendance[workshopName] =
                (workshopAttendance[workshopName] ?? 0) + 1;
          }
        }
      }

      workshopAttendance.forEach((workshop, count) {
        print("$workshop: $count attendees checked in");
      });

      List<Color> workshopColors = [
        Color.fromARGB(255, 126, 185, 232),
        Color.fromARGB(255, 255, 180, 100),
        Color.fromARGB(255, 150, 232, 126),
        Color.fromARGB(255, 232, 126, 180),
      ];

      setState(() {
        int colorIndex = 0;
        int x = 0;

        legends.add({
          "color": Colors.grey,
          "text": "Not Checked",
          "value": _controller.attendees.length - x
        });

        legends.addAll(workshopAttendance.entries.map((entry) {
          x = x + entry.value;
          return {
            "color": workshopColors[colorIndex++ % workshopColors.length],
            "text": entry.key.split(":")[0].trim(),
            "value": entry.value
          };
        }).toList());
      });

      return response;
    } catch (e) {
      setState(() {
        _checkinFuture = null;
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: MyAppBar(
        title: "Statistics",
        leading: false,
      ),
      body: FutureBuilder(
        future: _checkinFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 50),
                        SizedBox(
                          height: 150,
                          child: PieChart(
                            PieChartData(
                              sections: _chartSections(),
                              centerSpaceRadius: 60,
                              sectionsSpace: 2,
                            ),
                          ),
                        ),
                        SizedBox(height: 55),
                        _buildLegend(), // Display the legend under the chart
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  _statics(),
                  SizedBox(height: 10),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: Colors.white,
                    leading: Icon(
                      Icons.lunch_dining,
                      size: 30,
                      color: Color.fromARGB(255, 223, 96, 96),
                    ),
                    title: Text('Had Lunch'),
                    trailing: Text(_controller.attendees
                        .where((attendee) {
                          return attendee["ticket"]["hadLunch"] == true;
                        })
                        .length
                        .toString()),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: Colors.white,
                    leading: Icon(
                      Icons.dinner_dining_sharp,
                      size: 30,
                      color: Colors.orange,
                    ),
                    title: Text('Had Dinner'),
                    trailing: Text(_controller.attendees
                        .where((attendee) {
                          return attendee["ticket"]["hadMeal"] == true;
                        })
                        .length
                        .toString()),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  List<PieChartSectionData> _chartSections() {
    double total = legends.fold(0, (sum, entry) => sum + entry["value"]);
    return legends.map((legend) {
      return PieChartSectionData(
        color: legend["color"],
        value: (legend["value"] / total) * 100,
        titleStyle: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
        title: ((legend["value"] / total) * 100).toStringAsFixed(2) + " %",
        radius: 50,
      );
    }).toList();
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: legends
          .map(
            (legend) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  SizedBox(width: 3),
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: legend["color"],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    legend["text"],
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _statics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: statics
          .map(
            (elem) => Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    elem["icon"],
                    size: 30,
                    color: Primary,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "+ " + elem["value"].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  Text(
                    elem["titre"],
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
