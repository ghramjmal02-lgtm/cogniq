class Note {
  final int? id;
  final String title;
  final String content;
  final String subject;
  final String createdAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.subject,
    required this.createdAt,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      subject: map['subject'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'subject': subject,
      'created_at': createdAt,
    };
  }
}
