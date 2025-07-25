import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/models/notifiers/notes_list_model.dart';
import 'package:quik_note/widgets/app_bar.dart';
import 'package:quik_note/widgets/notes_list.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'pages/create_note_form_page.dart';
import 'wrappers/main_wrapper.dart';

final appBarStyle = SystemUiOverlayStyle(
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);

Future main() async {
  // Initialize FFI
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    AnnotatedRegion<SystemUiOverlayStyle>(
      value: appBarStyle,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NotesListModel()),
        ], // TODO: make this shit not global across whole app if possible of course
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final homePageStateKey = GlobalKey<_MyHomePageState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(systemOverlayStyle: appBarStyle),
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
            Expanded(child: NotesList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Material(child: CreateNoteFormPage()),
            ),
          );
        },
        tooltip: 'Add note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
