import 'package:flutter/material.dart';
import 'package:quik_note/data/db.dart';
import 'package:quik_note/models/note.dart';

class NotesListModel extends ChangeNotifier {
  List<Note> notes = [];
  List<Note> bufferNotes = [];
  List<Note> starredNotes = [];

  Map<int, Note> selectedNotes = {};

  void toggleSelected(Note note) {
    if (selectedNotes.containsKey(note.id)) {
      selectedNotes.remove(note.id);
    } else {
      selectedNotes[note.id!] = note;
    }

    notifyListeners();
  }

  void clearSelected() {
    selectedNotes.clear();
    notifyListeners();
  }

  bool isInSearchMode = false;
  bool isInStarMode = false;

  Map<int, int> contentIndexes = {};
  Map<int, int> titleIndexes = {};

  void initTest() {
    notes = [
      Note(1, "test", "test", DateTime.now(), null),
      Note(
        2,
        "test2",
        "test2",
        DateTime.now().subtract(const Duration(days: 1)),
        null,
      ),
      Note(
        3,
        "test3",
        "test3",
        DateTime.now().subtract(const Duration(days: 7)),
        null,
      ),
      Note(
        4,
        "test4",
        "test4",
        DateTime.now().subtract(const Duration(days: 30)),
        null,
      ),
      Note(
        5,
        "test5",
        "test5",
        DateTime.now().subtract(const Duration(days: 228)),
        null,
      ),
      Note(
        6,
        "test6",
        "test6",
        DateTime.now().subtract(const Duration(days: 369)),
        null,
      ),
      Note(
        7,
        "test7",
        "test7",
        DateTime.now().subtract(const Duration(days: 1488)),
        null,
      ),
      Note(
        8,
        "test8",
        "test8",
        DateTime.now().subtract(const Duration(days: 69)),
        null,
      ),
    ];

    notes.sort((a, b) => b.creationTime.compareTo(a.creationTime));
  }

  Future<void> getFromDb() async {
    bufferNotes = notes = await getNotes();
    notifyListeners();
  }

  Future<void> getStarredFromDb() async {
    starredNotes = await getNotes("starred = 1");
    notifyListeners();
  }

  //Future<void> whereFromDb() async {
  //notes = await getNotes("starred = 1");
  //notifyListeners();
  //}

  void assignFromBuffer() {
    notes = bufferNotes;
    notifyListeners();
  }

  void deleteAndInsertStartNote(Note note) {
    notes.removeWhere((n) => n.id == note.id);
    notes.insert(0, note);
    notifyListeners();
  }

  void whereInBuffer(bool Function(Note) predicate) {
    notes = bufferNotes.where(predicate).toList();
    notifyListeners();
  }

  void updateNote(Note note) {
    final indexOfNote = notes.indexWhere((n) => n.id == note.id);
    notes[indexOfNote] = note;
    notifyListeners();
  }

  void insertStartNote(Note note) {
    notes.insert(0, note);
    notifyListeners();
  }

  void insertNote(Note note) {
    notes.add(note);
    notifyListeners();
  }

  void deleteNotes(List<int> ids) {
    for (var i = 0; i < ids.length; i++) {
      notes.removeWhere((n) => n.id == ids[i]);
    }
  }

  void deleteNote(int id) {
    notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
