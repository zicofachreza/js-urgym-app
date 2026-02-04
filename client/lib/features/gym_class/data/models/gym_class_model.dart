class GymClassModel {
  final String id;
  final String name;
  final String instructor;
  final DateTime schedule;
  final int capacity;
  final int duration;
  final String description;
  final int availableSlots;
  final String? status;

  GymClassModel({
    required this.id,
    required this.name,
    required this.instructor,
    required this.schedule,
    required this.capacity,
    required this.duration,
    required this.description,
    required this.availableSlots,
    this.status,
  });

  factory GymClassModel.fromJson(Map<String, dynamic> json) {
    final booking = json['my_confirmed_booking'];

    return GymClassModel(
      id: json['id'],
      name: json['name'],
      instructor: json['instructor'],
      schedule: DateTime.parse(json['schedule']),
      capacity: json['capacity'],
      duration: json['duration'],
      description: json['description'],
      availableSlots: json['available_slots'],
      status: booking != null ? booking['status'] as String : null,
    );
  }
}
