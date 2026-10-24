class Exam {
  final int? id;
  final String subject;
  final String date;
  final int color;
  final int? collegeId;

  Exam({
    this.id,
    required this.subject,
    required this.date,
    required this.color,
    this.collegeId,
  });

  factory Exam.fromMap(Map<String, dynamic> map) {
    return Exam(
      id: map['id'],
      subject: map['subject'],
      date: map['date'],
      color: map['color'],
      collegeId: map['college_id'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'subject': subject,
      'date': date,
      'color': color,
      'college_id': collegeId,
    };
    if (id != null) map['id'] = id!;

    return map;
  }
}
