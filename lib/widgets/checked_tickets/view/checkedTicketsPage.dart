import 'package:flutter/material.dart';
import '../../../Api/httpClient.dart';
import '../../../utils/MyAppBar.dart';
import '../../../utils/colors.dart';
import '../../../utils/searchField.dart';
import '../../../utils/table.dart'; // Assuming your table widget is here
import '../controller/controller.dart';
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
  final CheckedTicketsController _controller = CheckedTicketsController();

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchTickets() async {
    await _controller.fetchCheckedTickets();
    setState(() {}); // Manually trigger a rebuild
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
            _controller.isLoading
                ? Center(child: CircularProgressIndicator())
                : _controller.errorMessage.isNotEmpty
                    ? Center(child: Text('Error: ${_controller.errorMessage}'))
                    : MyTable(tickets: _controller.checkedTickets),
          ],
        ),
      ),
    );
  }
}
