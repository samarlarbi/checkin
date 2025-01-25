import 'dart:convert';
import 'package:checkin/widgets/ticket_page/view/ticketPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/web_symbols_icons.dart';
import 'package:http/http.dart' as http; // Import du package HTTP
import 'package:checkin/widgets/attendees_screen/controller/attendeescontroller.dart';
import 'package:checkin/utils/MyAppBar.dart';
import 'package:checkin/utils/colors.dart';
import 'package:checkin/widgets/attendees_screen/models/Attendee.dart';

class Invitations extends StatefulWidget {
  const Invitations({super.key});

  @override
  State<Invitations> createState() => _InvitationsState();
}

class _InvitationsState extends State<Invitations> {
  TextEditingController searchController = TextEditingController();
  final AttendeeController _controller = AttendeeController();
  int currentPage = 0;
  bool isLoading = false;
  final FocusNode _focusNode = FocusNode();
  // Liste des invités pour l'affichage
  List<Attendee> _displayedAttendees = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
    _fetchAttendees();
  }

  @override
  void dispose() {
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Fonction pour charger les invités (avec ou sans recherche)
  Future<void> _fetchAttendees({String search = ""}) async {
    setState(() {
      isLoading = true;
    });

    try {
      final String url =
          'https://ceremony-backend-to-deploy.onrender.com/api/v1/registration?currentPage=$currentPage&sizePerPage=10';
      final Uri uri =
          Uri.parse(search.isNotEmpty ? '$url&search=$search' : url);

      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2RlIjoiRUxfJGlSX2tiaVIiLCJpYXQiOjE3Mzc0MTE2NDR9.INKEJw81Q9UyYbVlWGgj3Thk-K7pyVDslLOutY5kJzg",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Transformation des données en objets `Attendee`
        List<dynamic> attendeesData = data['data']; // Adaptez selon votre API
        setState(() {
          _displayedAttendees =
              attendeesData.map((item) => Attendee.fromJson(item)).toList();
        });
      } else {
        throw Exception("Failed to load attendees");
      }
    } catch (e) {
      print("Erreur: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fonction pour changer de page
  void _changePage(int page) {
    setState(() {
      currentPage = page;
    });
    _fetchAttendees(search: searchController.text.trim());
  }

  Future<void> _refreshData() async {
    _fetchAttendees(search: searchController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: MyAppBar(
        title: "All Invitations",
        leading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            // Champ de recherche
            Container(
              color: Background,
              padding: EdgeInsets.only(bottom: 10, top: 20),
              child: TextField(
                controller: searchController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Enter ticket code',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    color: _focusNode.hasFocus ? Primary : Colors.grey,
                    onPressed: () {
                      // Lancer la recherche uniquement si le champ n'est pas vide
                      if (searchController.text.trim().isNotEmpty) {
                        _fetchAttendees(search: searchController.text.trim());
                      } else {
                        _fetchAttendees(); // Requête par défaut si aucun texte
                      }
                    },
                  ),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Primary, width: 2),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                onChanged: (value) {
                  // Lancer la recherche uniquement si le champ n'est pas vide
                  if (searchController.text.trim().isNotEmpty) {
                    _fetchAttendees(search: searchController.text.trim());
                  } else {
                    _fetchAttendees(); // Requête par défaut si aucun texte
                  }
                },
              ),
            ),
            const SizedBox(height: 5),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: Column(
                      children: [
                        // Pagination
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: currentPage > 0
                                  ? () {
                                      // Changer de page sans lancer de recherche
                                      _changePage(currentPage - 1);
                                    }
                                  : null,
                            ),
                            Text(
                              'Page $currentPage',
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: () {
                                // Changer de page sans lancer de recherche
                                _changePage(currentPage + 1);
                              },
                            ),
                          ],
                        ),
                        // Liste des invités
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: _refreshData,
                            child: ListView.builder(
                              itemCount: _displayedAttendees.length,
                              itemBuilder: (context, index) {
                                final attendee = _displayedAttendees[index];
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    tileColor: Colors.white,
                                    trailing: IconButton(
                                      icon: Icon(Icons
                                          .keyboard_double_arrow_right_rounded),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyTicketView(ticket: {
                                                    "ticketId": attendee
                                                        .ticket.ticketId,
                                                    "type":
                                                        attendee.ticket.type,
                                                    "isCheckedIn": attendee
                                                        .ticket.isCheckedIn,
                                                    "attendee": {
                                                      "name": attendee.name,
                                                      "email": attendee.email
                                                    },
                                                    "relatives": attendee
                                                        .ticket.relatives
                                                  })),
                                        );
                                      },
                                    ),
                                    title: Text(attendee.name),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("+" +
                                            attendee.ticket.relatives.length
                                                .toString() +
                                            " guests"),
                                      ],
                                    ),
                                    leading: attendee.ticket.isCheckedIn == true
                                        ? const Icon(
                                            WebSymbols.ok,
                                            size: 30,
                                            fill: 0,
                                            opticalSize: 1,
                                            grade: 600,
                                            weight: 900,
                                            color: Primary,
                                          )
                                        : const Icon(
                                            WebSymbols.cancel,
                                            color: Color.fromARGB(
                                                255, 160, 82, 82),
                                            size: 30,
                                          ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyTicketView(ticket: {
                                                  "ticketId":
                                                      attendee.ticket.ticketId,
                                                  "type": attendee.ticket.type,
                                                  "isCheckedIn": attendee
                                                      .ticket.isCheckedIn,
                                                  "attendee": {
                                                    "name": attendee.name,
                                                    "email": attendee.email
                                                  },
                                                  "relatives":
                                                      attendee.ticket.relatives
                                                })),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
