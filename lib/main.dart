import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:quik_note/widgets/app_bar.dart';

import 'data/db.dart';
import 'models/note.dart';
import 'widgets/add_note_card.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'widgets/note_card.dart';
import 'wrappers/main_wrapper.dart';
import 'wrappers/main_wrapper_margin.dart';

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
  List<Note> notes = [];

  List<IntrinsicHeight> widgetNotes = [];

  void _loadNotes() async {
    //final notes = await getNotes();
    setState(() {
      notes = [
        Note(1, "Shoping List For August", "test", DateTime.now()),
        Note(2, "Random notes when iam boring", "test2", DateTime.now()),
        Note(3, "List music", "test3", DateTime.now()),
      ];

      widgetNotes = notes.map((n) {
        return IntrinsicHeight(
          child: NoteCard(
            id: n.id,
            title: n.title,
            content: n.content,
            creationTime: n.creationTime,
            onNoteDelete: (n) {},
          ),
        );
      }).toList();

      widgetNotes.add(IntrinsicHeight(child: AddNoteCard()));
      //this.notes = notes;
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
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: IntrinsicHeight(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            spacing: 8,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.folder)),
              IconButton(onPressed: () {}, icon: Icon(Icons.star)),
              IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
              IconButton(onPressed: () {}, icon: Icon(Icons.login)),
            ],
          ),
        ),
      ),
      //appBar: AppBar(
      //flexibleSpace: AppBarWidget(),
      //toolbarHeight: 180,
      //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //),
      body: MainWrapper(
        child: Column(
          children: [
            Align(alignment: Alignment.topCenter, child: AppBarWidget()),
            Expanded(
              child: MainWrapperMargin(
                child: StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 24, // add some space
                  children: widgetNotes,
                ),
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
