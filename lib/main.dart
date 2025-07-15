import 'package:flutter/material.dart';
import 'package:quik_note/widgets/app_bar.dart';

import 'data/db.dart';
import 'forms/create_note_form.dart';
import 'models/note.dart';
import 'widgets/note.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  // Initialize FFI
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final homePageStateKey = GlobalKey<_MyHomePageState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //scaffoldBackgroundColor: Colors.black,
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: MyHomePage(key: homePageStateKey, title: 'quik-note'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  List<Note> notes = [];

  void _loadNotes() async {
    final notes = await getNotes();
    setState(() {
      this.notes = notes;
    });
  }

  Future<void> _handleDeleteNote(int? id) async {
    if (id != null) {
      setState(() {
        notes.removeWhere((n) => n.id == id);
      });

      await deleteNote(id);
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.red,
      bottomNavigationBar: Container(
        color: Colors.blue,
        child: TabBar(
          controller: tabController,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.list_alt, color: Colors.white)),
            Tab(icon: Icon(Icons.create_outlined, color: Colors.white)),
          ],
        ),
      ),
      //appBar: AppBar(
      //flexibleSpace: AppBarWidget(),
      //toolbarHeight: 180,
      //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //),
      body: Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFB083FF)],
          ),
        ),
        child: Column(
          children: [
            Align(alignment: Alignment.topCenter, child: AppBarWidget()),
            Container(
              margin: EdgeInsets.all(16),
              height: 300,
              child: TabBarView(
                controller: tabController,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: notes.map((n) {
                      return NoteWidget(
                        id: n.id,
                        title: n.title,
                        content: n.content,
                        creationTime: n.creationTime,
                        onNoteDelete: _handleDeleteNote,
                      );
                    }).toList(),
                  ),
                  CreateNoteForm(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
