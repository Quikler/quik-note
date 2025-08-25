import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/models/notifiers/app_bar_model.dart';
import 'package:quik_note/models/notifiers/current_page_model.dart';
import 'package:quik_note/models/notifiers/notes_list_model.dart';
import 'package:quik_note/pages/create_todo_form_page.dart';
import 'package:quik_note/pages/pages_enum.dart';
import 'package:quik_note/widgets/app_bar.dart';
import 'package:quik_note/widgets/bottom_bar.dart';

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
          ChangeNotifierProvider(create: (_) => AppBarModel()),
          ChangeNotifierProvider(create: (_) => CurrentPageModel()),
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

class _MyHomePageState extends State<MyHomePage> {
  void _handlePopOfPopScope(bool didPop, Object? result) {
    final appBarContext = context.read<AppBarModel>();
    if (appBarContext.mode == AppBarMode.select) {
      appBarContext.toggleMode(AppBarMode.initial);
      return;
    }

    Navigator.maybePop(context);
  }

  void _handleFloatingButtonPressed() {
    final currentPageContext = context.read<CurrentPageModel>();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            Material(child: currentPageContext.currentPage!.formPageToNavigate),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<CurrentPageModel>().initPage(PagesEnum.notes);
  }

  @override
  Widget build(BuildContext context) {
    final appBarContext = context.watch<AppBarModel>();
    bool canPop = appBarContext.mode == AppBarMode.initial;

    final currentPageContext = context.watch<CurrentPageModel>();

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: _handlePopOfPopScope,
      child: Scaffold(
        bottomNavigationBar: BottomBar(),
        body: MainWrapper(
          child: Column(
            children: [
              Align(alignment: Alignment.topCenter, child: AppBarWidget()),
              Expanded(child: currentPageContext.currentPage!.widget!),
              //Expanded(
              //child: CarouselSlider(
              //disableGesture: true,
              //items: carouselPages,
              //options: CarouselOptions(
              //height: double.infinity,
              //viewportFraction: 1,
              //enableInfiniteScroll: false,
              //),
              //),
              //),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _handleFloatingButtonPressed,
          tooltip: currentPageContext.currentPage!.navigateTooltip,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
