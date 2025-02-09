class NotificationModel {
  String title;
  String description;
  DateTime date;

  NotificationModel({required this.title, required this.description, required this.date});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']), // Conversion de String à DateTime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(), // Conversion de DateTime à String
    };
  }
}
