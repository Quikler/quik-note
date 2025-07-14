class Note {
  final int? id;
  final String title;
  final String? content;
  final DateTime creationTime;

  const Note(this.id, this.title, this.content, this.creationTime);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'creationTime': creationTime.toString(),
    };
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, content: $content, creationTime: $creationTime}';
  }

  Note.fromJson(Map<String, dynamic> json)
    : id = json["id"],
      title = json["title"],
      content = json["content"],
      creationTime = DateTime.parse(json["creationTime"]);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'creationTime': creationTime.toString(),
    };
  }
}
