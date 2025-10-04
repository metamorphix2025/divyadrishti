import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../models/parking_model.dart';
import 'parking_details_screen.dart';

class ParkingScreen extends StatelessWidget {
  ParkingScreen({super.key});

  final List<ParkingSpace> parkingSpaces = [
    ParkingSpace(
      id: '1',
      name: 'Main Parking',
      description: 'Primary parking area with maximum capacity and security',
      totalSlots: 200,
      availableSlots: 45,
      pricePerHour: 30.0,
      features: ['Covered', 'Security', 'CCTV', 'Well Lit', 'EV Charging'],
      address: 'Dwarka Temple Main Entrance, Near North Gate',
      latitude: 22.2405,
      longitude: 68.9686,
      distanceFromTemple: '150m from temple',
      images: [],
      isCovered: true,
      hasSecurity: true,
      hasEVCharging: true,
      operatingHours: '24/7',
    ),
    ParkingSpace(
      id: '2',
      name: 'VIP Parking',
      description: 'Exclusive parking for VIP visitors with valet service',
      totalSlots: 50,
      availableSlots: 0,
      pricePerHour: 100.0,
      features: ['Covered', 'Valet', 'Security', 'Premium', 'Reserved'],
      address: 'Dwarka Temple South Gate, VIP Zone',
      latitude: 22.2398,
      longitude: 68.9692,
      distanceFromTemple: '50m from temple',
      images: [],
      isCovered: true,
      hasSecurity: true,
      hasEVCharging: false,
      operatingHours: '6:00 AM - 10:00 PM',
    ),
    ParkingSpace(
      id: '3',
      name: 'Bus Parking',
      description: 'Designated parking area for buses and large vehicles',
      totalSlots: 12,
      availableSlots: 3,
      pricePerHour: 150.0,
      features: ['Large Vehicles', 'Security', 'Spacious', 'Easy Access'],
      address: 'Dwarka Temple East Side, Bus Terminal',
      latitude: 22.2412,
      longitude: 68.9701,
      distanceFromTemple: '300m from temple',
      images: [],
      isCovered: false,
      hasSecurity: true,
      hasEVCharging: false,
      operatingHours: '5:00 AM - 11:00 PM',
    ),
    ParkingSpace(
      id: '4',
      name: 'Two-Wheeler',
      description: 'Secure parking for motorcycles and scooters',
      totalSlots: 400,
      availableSlots: 120,
      pricePerHour: 10.0,
      features: ['Secure', 'Affordable', 'Easy Access', 'Helmet Storage'],
      address: 'Dwarka Temple West Gate, Two-Wheeler Zone',
      latitude: 22.2389,
      longitude: 68.9678,
      distanceFromTemple: '100m from temple',
      images: [],
      isCovered: true,
      hasSecurity: true,
      hasEVCharging: false,
      operatingHours: '24/7',
    ),
  ];

  void _navigateToParkingDetails(BuildContext context, String parkingName) {
    final parkingSpace = parkingSpaces.firstWhere(
      (space) => space.name == parkingName,
      orElse: () => parkingSpaces.first,
    );
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParkingDetailsScreen(parkingSpace: parkingSpace),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Header section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 12),
                                Text(
                                  "Parking & Facilities",
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 22 : 26,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF061C42),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Complete parking information, transport options, EV charging, and fuel stations near Dwarka Temple",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF061C42),
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Quick Actions Row
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildQuickAction(
                                  "Parking Map",
                                  Icons.map_rounded,
                                  Colors.blue,
                                  () {},
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildQuickAction(
                                  "Get Directions",
                                  Icons.navigation_rounded,
                                  Colors.green,
                                  () {},
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildQuickAction(
                                  "Book Parking",
                                  Icons.book_online_rounded,
                                  Colors.purple,
                                  () {},
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Real-time Parking Availability
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                Colors.grey.shade50,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.sensors_rounded,
                                      color: Colors.green.shade700,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "Live Parking Status",
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 18 : 20,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF061C42),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.green.shade200),
                                    ),
                                    child: Text(
                                      "LIVE",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // Parking Grid
                              GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 25,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.8,
                                children: [
                                  _buildParkingCard(
                                    context,
                                    "Main Parking",
                                    "45/200 slots",
                                    22,
                                    Colors.green,
                                    Icons.directions_car_rounded,
                                  ),
                                  _buildParkingCard(
                                    context,
                                    "VIP Parking",
                                    "FULL",
                                    0,
                                    Colors.red,
                                    Icons.star_rounded,
                                    isFull: true,
                                  ),
                                  _buildParkingCard(
                                    context,
                                    "Bus Parking",
                                    "3/12 slots",
                                    25,
                                    Colors.blue,
                                    Icons.directions_bus_rounded,
                                  ),
                                  _buildParkingCard(
                                    context,
                                    "Two-Wheeler",
                                    "120/400 slots",
                                    30,
                                    Colors.purple,
                                    Icons.two_wheeler_rounded,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Transport & Fuel Section
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              // Transport Options
                              _buildSectionCard(
                                icon: Icons.directions_bus_rounded,
                                title: "Transport Options",
                                color: Colors.teal,
                                child: Column(
                                  children: [
                                    _buildTransportTile(
                                      "Bus Stand",
                                      "Dwarka Main - 500m",
                                      Icons.directions_bus_filled,
                                      Colors.teal,
                                      "4 min walk",
                                    ),
                                    _buildTransportTile(
                                      "Auto Rickshaw",
                                      "Temple entrance",
                                      Icons.auto_awesome_motion,
                                      Colors.orange,
                                      "Available",
                                    ),
                                    _buildTransportTile(
                                      "Taxi Stand",
                                      "Pre-paid service",
                                      Icons.local_taxi,
                                      Colors.blue,
                                      "24/7",
                                    ),
                                    _buildTransportTile(
                                      "Cycle Rickshaw",
                                      "Eco-friendly travel",
                                      Icons.pedal_bike,
                                      Colors.green,
                                      "Short distance",
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Petrol Bunks Section
                              _buildSectionCard(
                                icon: Icons.local_gas_station_rounded,
                                title: "Nearby Petrol Stations",
                                color: Colors.amber,
                                child: Column(
                                  children: [
                                    _buildPetrolStationTile(
                                      "Indian Oil Station",
                                      "Dwarka Main Road - 1.2km",
                                      "24/7 • Diesel/Petrol",
                                      Icons.local_gas_station,
                                      Colors.red,
                                    ),
                                    _buildPetrolStationTile(
                                      "HP Petrol Pump",
                                      "Near Bus Stand - 800m", 
                                      "6 AM - 10 PM • All fuels",
                                      Icons.ev_station,
                                      Colors.blue,
                                    ),
                                    _buildPetrolStationTile(
                                      "Reliance Petroleum",
                                      "Highway Road - 2.5km",
                                      "24/7 • Premium fuels",
                                      Icons.oil_barrel,
                                      Colors.green,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // EV Charging Points
                              _buildSectionCard(
                                icon: Icons.ev_station_rounded,
                                title: "EV Charging Stations",
                                color: Colors.green,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    GridView.count(
                                      crossAxisCount: 2,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      childAspectRatio: 3.5,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      children: [
                                        _buildFeatureChip("Fast Charging", Icons.bolt, Colors.amber),
                                        _buildFeatureChip("24/7 Available", Icons.schedule, Colors.blue),
                                        _buildFeatureChip("Multiple Ports", Icons.electrical_services, Colors.green),
                                        _buildFeatureChip("Digital Pay", Icons.payment, Colors.purple),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      width: double.infinity,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.green.shade500,
                                            Colors.green.shade700,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.green.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.map_rounded, size: 18),
                                            const SizedBox(width: 8),
                                            Text(
                                              "View Charging Map",
                                              style: TextStyle(
                                                fontSize: isSmallScreen ? 14 : 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Quick Action Widget
  Widget _buildQuickAction(String title, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF061C42),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Updated Parking Card Widget with navigation
  Widget _buildParkingCard(BuildContext context, String title, String status, int percentage, Color color, IconData icon, {bool isFull = false}) {
    return GestureDetector(
      onTap: () {
        _navigateToParkingDetails(context, title);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            color: isFull ? Colors.red.shade50 : color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isFull ? Colors.red.shade200 : color.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isFull ? Colors.red.shade100 : color.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: isFull ? Colors.red : color,
                        size: 16,
                      ),
                    ),
                    const Spacer(),
                    if (isFull)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "FULL",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF061C42),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    color: isFull ? Colors.red.shade600 : color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(isFull ? Colors.red : color),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 6,
                ),
                const SizedBox(height: 4),
                Text(
                  isFull ? "0% available" : "$percentage% available",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
                // Add a subtle "Tap for details" hint
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 10, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      "Tap for details",
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section Card Widget
  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF061C42),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  // Transport Tile Widget
  Widget _buildTransportTile(String title, String subtitle, IconData icon, Color color, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF061C42),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Petrol Station Tile Widget
  Widget _buildPetrolStationTile(String title, String location, String details, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF061C42),
                  ),
                ),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  details,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.directions_rounded, color: color, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  // Feature Chip Widget
  Widget _buildFeatureChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}