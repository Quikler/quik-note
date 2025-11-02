import 'package:quik_note/core/cache_service.dart';
import 'package:quik_note/models/note.dart';

class NoteCache extends InMemoryCacheService<int, Note> {
  static final NoteCache _instance = NoteCache._internal();
  factory NoteCache() => _instance;
  NoteCache._internal();
}
