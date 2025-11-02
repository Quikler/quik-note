import 'package:quik_note/utils/helpers.dart';
class Note {
  final int? id;
  final String? title;
  final String? content;
  final DateTime creationTime;
  final DateTime? lastEditedTime;
  final bool starred;
  const Note({
    this.id,
    this.title,
    this.content,
    required this.creationTime,
    this.lastEditedTime,
    this.starred = false,
  });
  factory Note.fromMap(Map<String, Object?> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String?,
      content: map['content'] as String?,
      creationTime: DateTime.parse(map['creationTime'] as String),
      lastEditedTime: map['lastEditedTime'] != null
          ? DateTime.parse(map['lastEditedTime'] as String)
          : null,
      starred: (map['starred'] as int?) == 1,
    );
  }
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'creationTime': creationTime.toIso8601String(),
      'lastEditedTime': lastEditedTime?.toIso8601String(),
      'starred': starred.toInt(),
    };
  }
  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? creationTime,
    DateTime? lastEditedTime,
    bool? starred,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      creationTime: creationTime ?? this.creationTime,
      lastEditedTime: lastEditedTime ?? this.lastEditedTime,
      starred: starred ?? this.starred,
    );
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          content == other.content &&
          creationTime == other.creationTime &&
          lastEditedTime == other.lastEditedTime &&
          starred == other.starred;
  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      content.hashCode ^
      creationTime.hashCode ^
      lastEditedTime.hashCode ^
      starred.hashCode;
  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, creationTime: $creationTime, lastEditedTime: $lastEditedTime, starred: $starred)';
  }
}
