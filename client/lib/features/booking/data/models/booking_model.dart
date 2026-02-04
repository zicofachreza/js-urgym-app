class BookingModel {
  final String id;
  final String status;
  final DateTime bookingDate;
  final DateTime? cancelledAt;
  final String className;
  final DateTime schedule;
  final String instructor;
  final int duration;
  final int capacity;

  BookingModel({
    required this.id,
    required this.status,
    required this.bookingDate,
    required this.cancelledAt,
    required this.className,
    required this.schedule,
    required this.instructor,
    required this.duration,
    required this.capacity,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      status: json['status'],
      bookingDate: DateTime.parse(json['booking_date']),
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'])
          : null,
      className: json['gym_class']['name'],
      schedule: DateTime.parse(json['gym_class']['schedule']),
      instructor: json['gym_class']['instructor'],
      duration: json['gym_class']['duration'],
      capacity: json['gym_class']['capacity'],
    );
  }
}
