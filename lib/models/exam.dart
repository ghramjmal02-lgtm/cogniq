class Exam {
  final int? id;
  final String subject;
  final String date;
  final int color;

  Exam({
    this.id,
    required this.subject,
    required this.date,
    required this.color,
  });

  // تحويل من Map لـ Object
  factory Exam.fromMap(Map<String, dynamic> map) {
    return Exam(
      id: map['id'],
      subject: map['subject'],
      date: map['date'],
      color: map['color'],
    );
  }

  // تحويل من Object لـ Map
  Map<String, dynamic> toMap() {
    final map = {
      'subject': subject,
      'date': date,
      'color': color,
    };
    if (id != null) map['id'] = id!;

    return map;
  }
}
