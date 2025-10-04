class ParkingSpace {
  final String id;
  final String name;
  final String description;
  final int totalSlots;
  final int availableSlots;
  final double pricePerHour;
  final List<String> features;
  final String address;
  final double latitude;
  final double longitude;
  final String distanceFromTemple;
  final List<String> images;
  final bool isCovered;
  final bool hasSecurity;
  final bool hasEVCharging;
  final String operatingHours;

  ParkingSpace({
    required this.id,
    required this.name,
    required this.description,
    required this.totalSlots,
    required this.availableSlots,
    required this.pricePerHour,
    required this.features,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distanceFromTemple,
    required this.images,
    required this.isCovered,
    required this.hasSecurity,
    required this.hasEVCharging,
    required this.operatingHours,
  });

  double get availabilityPercentage => (availableSlots / totalSlots) * 100;
  bool get isAvailable => availableSlots > 0;
}