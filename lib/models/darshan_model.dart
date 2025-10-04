class DarshanTicket {
  final String ticketType;
  final String date;
  final String timeSlot;
  final int numberOfPersons;
  final double price;
  final String fullName;
  final String email;
  final String phoneNumber;

  DarshanTicket({
    required this.ticketType,
    required this.date,
    required this.timeSlot,
    required this.numberOfPersons,
    required this.price,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'ticketType': ticketType,
      'date': date,
      'timeSlot': timeSlot,
      'numberOfPersons': numberOfPersons,
      'price': price,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}