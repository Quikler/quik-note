import 'package:flutter/material.dart';
import 'package:quik_note/data/db.dart';
import 'package:quik_note/models/note.dart';

class NotesListModel extends ChangeNotifier {
  List<Note> notes = [];

  Future<void> assignFromDb() async {
    notes = await getNotes();
    notifyListeners();
  }

  void deleteAndInsertStartNote(Note note) {
    notes.removeWhere((n) => n.id == note.id);
    notes.insert(0, note);
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

  void deleteNote(int id) {
    notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
