import 'package:quik_note/utils/helpers.dart';

class Note {
  final int? id;
  final String? title;
  final String? content;
  final DateTime creationTime;
  final DateTime? lastEditedTime;
  final bool starred;

  const Note(
    this.id,
    this.title,
    this.content,
    this.creationTime, [
    this.lastEditedTime,
    this.starred = false,
  ]);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'creationTime': creationTime.toString(),
      'lastEditedTime': lastEditedTime?.toString(),
      'starred': starred.toInt(),
    };
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, content: $content, creationTime: $creationTime, lastEditedTime: $lastEditedTime, starred: $starred}';
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? creationTime,
    DateTime? lastEditedTime,
    bool starred = false,
  }) => Note(
    id ?? this.id,
    title ?? this.title,
    content ?? this.content,
    creationTime ?? this.creationTime,
    lastEditedTime ?? this.lastEditedTime,
    starred,
  );
}
