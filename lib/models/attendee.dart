class Attendee {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String studyLevel;
  final String specialization;
  final Faculty fac;
  final Team team;
  final Ticket ticket;

  Attendee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.studyLevel,
    required this.specialization,
    required this.fac,
    required this.team,
    required this.ticket,
  });

  // From JSON to Attendee object
  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      studyLevel: json['studyLevel'],
      specialization: json['specialization'],
      fac: Faculty.fromJson(json['fac']),
      team: Team.fromJson(json['team']),
      ticket: Ticket.fromJson(json['ticket']),
    );
  }

  @override
  String toString() {
    return 'Attendee{name: $name, email: $email, phone: $phone}';
  }
}

// Faculty class
class Faculty {
  final String id;
  final String name;

  Faculty({required this.id, required this.name});

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      id: json['id'],
      name: json['name'],
    );
  }
}

// Team class
class Team {
  final String id;
  final String name;

  Team({required this.id, required this.name});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
    );
  }
}

// Ticket class
class Ticket {
  final String ticketNo;
  final bool done;
  final bool hadMeal;
  final List<Workshop> workshops;

  Ticket({
    required this.ticketNo,
    required this.done,
    required this.hadMeal,
    required this.workshops,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    var workshopList = (json['workshops'] as List)
        .map((workshop) => Workshop.fromJson(workshop))
        .toList();
    return Ticket(
      ticketNo: json['ticketNo'],
      done: json['done'],
      hadMeal: json['hadMeal'],
      workshops: workshopList,
    );
  }
}

// Workshop class
class Workshop {
  final bool hasAttended;
  final WorkshopDetails workshop;

  Workshop({required this.hasAttended, required this.workshop});

  factory Workshop.fromJson(Map<String, dynamic> json) {
    return Workshop(
      hasAttended: json['hasAttended'],
      workshop: WorkshopDetails.fromJson(json['workshop']),
    );
  }
}

// WorkshopDetails class
class WorkshopDetails {
  final String id;
  final String name;

  WorkshopDetails({required this.id, required this.name});

  factory WorkshopDetails.fromJson(Map<String, dynamic> json) {
    return WorkshopDetails(
      id: json['id'],
      name: json['name'],
    );
  }
}
