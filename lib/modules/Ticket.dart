class Ticket {
  final int idticket;
  final int typeticket;
  final int nbguests;
  final String attende;
  final String date;
  final int checkguests;
  final String email;
  final String phone;
  final bool checked;

 Ticket(
       this.idticket,
       this.typeticket,
       this.nbguests,
       this.attende,
       this.date,
       this.checkguests,
       this.email,
       this.phone,
       this.checked);
  Ticket.fromJson(Map<String, dynamic> json)
      : idticket = json['idticket'],
        typeticket = json['typeticket'],
        nbguests = json['nbguests'],
        attende = json['attende'],
        date = json['date'],
        checkguests = json['checkguests'],
        email = json['email'],
        phone = json['phone'],
        checked = json['checked'];
  Map<String, dynamic> toJson() =>
      {'idticket': idticket,
       'typeticket': typeticket,
       'nbguests': nbguests,
       'attende': attende,
       'date': date,
       'checkguests': checkguests,
       'email': email,
       'phone': phone,
       'checked': checked};
}