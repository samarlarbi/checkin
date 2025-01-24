class Attendee {
  final String id;
  final String name;
  final String email;
  final String phone;
  final Ticket ticket;

  Attendee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.ticket,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      ticket: Ticket.fromJson(json['ticket']),
    );
  }
}

class Ticket {
  final String ticketId;
  final bool isCheckedIn;
  final String type;
  final bool isPaid;
  final bool isPresenceConfirmed;
  final String justification;
  final List<dynamic> relatives;

  Ticket({
    required this.ticketId,
    required this.isCheckedIn,
    required this.type,
    required this.isPaid,
    required this.isPresenceConfirmed,
    required this.justification,
    required this.relatives,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      ticketId: json['ticketId'],
      isCheckedIn: json['isCheckedIn'],
      type: json['type'],
      isPaid: json['isPaid'],
      isPresenceConfirmed: json['isPresenceConfirmed'],
      justification: json['justification'],
      relatives: List<dynamic>.from(json['relatives']),
    );
  }
}
