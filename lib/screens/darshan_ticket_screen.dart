import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../models/darshan_model.dart';

class DarshanTicketScreen extends StatefulWidget {
  const DarshanTicketScreen({super.key});

  @override
  State<DarshanTicketScreen> createState() => _DarshanTicketScreenState();
}

class _DarshanTicketScreenState extends State<DarshanTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form fields
  String _selectedTicketType = 'General Darshan';
  String _selectedDate = '';
  String _selectedTimeSlot = '06:00 AM - 08:00 AM';
  int _numberOfPersons = 1;
  String _fullName = '';
  String _email = '';
  String _phoneNumber = '';

  // Darshan options
  final List<String> _ticketTypes = [
    'General Darshan',
    'Special Darshan',
    'VIP Darshan',
    'Quick Darshan'
  ];
  
  final List<String> _timeSlots = [
    '06:00 AM - 08:00 AM',
    '08:00 AM - 10:00 AM',
    '10:00 AM - 12:00 PM',
    '12:00 PM - 02:00 PM',
    '04:00 PM - 06:00 PM',
    '06:00 PM - 08:00 PM',
  ];

  double get _ticketPrice {
    switch (_selectedTicketType) {
      case 'General Darshan':
        return 0.0;
      case 'Special Darshan':
        return 50.0;
      case 'VIP Darshan':
        return 100.0;
      case 'Quick Darshan':
        return 25.0;
      default:
        return 0.0;
    }
  }

  double get _totalPrice => _ticketPrice * _numberOfPersons;

  @override
  void initState() {
    super.initState();
    // Set default date to tomorrow
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    _selectedDate = "${tomorrow.day}/${tomorrow.month}/${tomorrow.year}";
  }

  void _bookDarshan() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Create ticket object
      final ticket = DarshanTicket(
        ticketType: _selectedTicketType,
        date: _selectedDate,
        timeSlot: _selectedTimeSlot,
        numberOfPersons: _numberOfPersons,
        price: _totalPrice,
        fullName: _fullName,
        email: _email,
        phoneNumber: _phoneNumber,
      );

      // Show confirmation dialog
      _showConfirmationDialog(ticket);
    }
  }

  void _showConfirmationDialog(DarshanTicket ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Darshan Booking'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Type: ${ticket.ticketType}'),
              Text('Date: ${ticket.date}'),
              Text('Time: ${ticket.timeSlot}'),
              Text('Persons: ${ticket.numberOfPersons}'),
              Text('Total: ₹${ticket.price.toStringAsFixed(2)}'),
              const SizedBox(height: 10),
              const Text('Proceed with booking?'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessDialog(ticket);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(DarshanTicket ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Successful!', style: TextStyle(color: Colors.green)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Darshan Ticket Booked Successfully', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Booking ID: DWK${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}'),
            Text('Type: ${ticket.ticketType}'),
            Text('Date: ${ticket.date}'),
            Text('Time: ${ticket.timeSlot}'),
            const SizedBox(height: 10),
            Text('Please arrive 15 minutes before your scheduled time.', style: TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to home
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Darshan Ticket Booking'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Card(
                  color: Colors.white.withOpacity(0.9),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(Icons.confirmation_number, size: 40, color: Colors.blue.shade700),
                        const SizedBox(height: 8),
                        Text(
                          'Book Your Darshan Ticket',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 18 : 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF061C42),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Secure your spot for divine darshan',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Ticket Type Selection
                Card(
                  color: Colors.white.withOpacity(0.9),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Ticket Type',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF061C42),
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _selectedTicketType,
                          items: _ticketTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedTicketType = value!;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedTicketType == 'General Darshan' 
                              ? 'Free entry' 
                              : '₹${_ticketPrice.toStringAsFixed(2)} per person',
                          style: TextStyle(
                            color: _selectedTicketType == 'General Darshan' ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Date and Time Selection
                Card(
                  color: Colors.white.withOpacity(0.9),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Date & Time',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF061C42),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Date Picker
                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: const Text('Select Date'),
                          subtitle: Text(_selectedDate),
                          trailing: const Icon(Icons.arrow_drop_down),
                          onTap: _selectDate,
                          tileColor: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Time Slot
                        DropdownButtonFormField<String>(
                          value: _selectedTimeSlot,
                          items: _timeSlots.map((slot) {
                            return DropdownMenuItem(
                              value: slot,
                              child: Text(slot),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedTimeSlot = value!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Time Slot',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Number of Persons
                Card(
                  color: Colors.white.withOpacity(0.9),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Number of Persons',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF061C42),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _numberOfPersons > 1 ? () {
                                setState(() {
                                  _numberOfPersons--;
                                });
                              } : null,
                              icon: const Icon(Icons.remove),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _numberOfPersons.toString(),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              onPressed: _numberOfPersons < 10 ? () {
                                setState(() {
                                  _numberOfPersons++;
                                });
                              } : null,
                              icon: const Icon(Icons.add),
                            ),
                            const Spacer(),
                            Text(
                              'Total: ₹${_totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Personal Information
                Card(
                  color: Colors.white.withOpacity(0.9),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF061C42),
                          ),
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                          onSaved: (value) => _fullName = value!,
                        ),

                        const SizedBox(height: 12),

                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (value) => _email = value!,
                        ),

                        const SizedBox(height: 12),

                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (value.length < 10) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                          onSaved: (value) => _phoneNumber = value!,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Book Now Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _bookDarshan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      'BOOK DARSHAN TICKET - ₹${_totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Important Notes
                Card(
                  color: Colors.orange.shade50,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info, color: Colors.orange.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'Important Information',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Please arrive 15 minutes before your scheduled time\n'
                          '• Carry valid ID proof for verification\n'
                          '• Dress modestly as per temple guidelines\n'
                          '• Photography may be restricted in certain areas\n'
                          '• Tickets are non-refundable',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12 : 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}