class Note {
  final int? id;
  final String? title;
  final String? content;
  final DateTime creationTime;
  final DateTime? lastEditedTime;

  const Note(
    this.id,
    this.title,
    this.content,
    this.creationTime,
    this.lastEditedTime,
  );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'creationTime': creationTime.toString(),
      'lastEditedTime': lastEditedTime?.toString(),
    };
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, content: $content, creationTime: $creationTime, lastEditedTime: $lastEditedTime}';
  }
}
