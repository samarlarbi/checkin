import 'package:flutter/material.dart';
import '../../../Api/httpClient.dart';
import '../../../utils/MyAppBar.dart';
import '../../../utils/colors.dart';
import '../../../utils/searchField.dart';
import '../../../utils/table.dart'; // Assuming your table widget is here
import '../service/Checkedticketsservice.dart'; // Assuming you have a service to fetch the tickets

class CheckedTicketsPage extends StatefulWidget {
  const CheckedTicketsPage({super.key});

  @override
  _CheckedTicketsPageState createState() => _CheckedTicketsPageState();
}

class _CheckedTicketsPageState extends State<CheckedTicketsPage> {
  late Future<List<Map<String, dynamic>>> ticketsFuture;
  List<Map<String, dynamic>> tickets = [];
  List<Map<String, dynamic>> filteredTickets = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ticketsFuture = fetchTickets();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchTickets() async {
    try {
      var response =
          await CheckedTicketsService(HttpClient()).getCheckedTickets();
      tickets = response;
      filteredTickets = response;
      return response;
    } catch (e) {
      throw Exception("Failed to load tickets");
    }
  }

  void filterTickets(String query) {
    setState(() {
      filteredTickets = tickets
          .where((ticket) =>
              ticket['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: MyAppBar(
        title: "Checked Tickets",
        leading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            SearchField(),
            SizedBox(height: 10),
            // Use FutureBuilder to handle async loading
            FutureBuilder<List<Map<String, dynamic>>>(
              future: ticketsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No tickets available.'));
                }

                return MyTable(
                  tickets: filteredTickets,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
