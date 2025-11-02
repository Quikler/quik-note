import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quik_note/core/note_cache.dart';
import 'package:quik_note/core/todo_cache.dart';
import 'package:quik_note/pages/create_note_form_page.dart';
import 'package:quik_note/pages/create_todo_form_page.dart';
import 'package:quik_note/repositories/note_repository.dart';
import 'package:quik_note/repositories/note_repository_impl.dart';
import 'package:quik_note/repositories/todo_repository.dart';
import 'package:quik_note/repositories/todo_repository_impl.dart';
import 'package:quik_note/services/note_form_service.dart';
import 'package:quik_note/services/todo_form_service.dart';
import 'package:quik_note/viewmodels/app_bar_viewmodel.dart';
import 'package:quik_note/viewmodels/navigation_viewmodel.dart';
import 'package:quik_note/viewmodels/notes_viewmodel.dart';
import 'package:quik_note/viewmodels/todos_viewmodel.dart';
import 'package:quik_note/widgets/app_bar.dart';
import 'package:quik_note/widgets/bottom_bar.dart';
import 'package:quik_note/widgets/notes_list.dart';
import 'package:quik_note/widgets/todos_list.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'wrappers/main_wrapper.dart';
const appBarStyle = SystemUiOverlayStyle(
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(
    AnnotatedRegion<SystemUiOverlayStyle>(
      value: appBarStyle,
      child: MultiProvider(
        providers: [
          // Repositories (singletons)
          Provider<NoteRepository>(
            create: (_) => const NoteRepositoryImpl(),
          ),
          Provider<TodoRepository>(
            create: (_) => const TodoRepositoryImpl(),
          ),
          // Caches (singletons)
          Provider<NoteCache>(
            create: (_) => NoteCache(),
          ),
          Provider<TodoCache>(
            create: (_) => TodoCache(),
          ),
          // Services (depend on repositories and caches)
          ProxyProvider2<NoteRepository, NoteCache, NoteFormService>(
            update: (_, repository, cache, __) => NoteFormService(repository, cache),
          ),
          ProxyProvider2<TodoRepository, TodoCache, TodoFormService>(
            update: (_, repository, cache, __) => TodoFormService(repository, cache),
          ),
          // ViewModels
          ChangeNotifierProvider<NotesViewModel>(
            create: (context) => NotesViewModel(context.read<NoteRepository>()),
          ),
          ChangeNotifierProvider<TodosViewModel>(
            create: (context) => TodosViewModel(context.read<TodoRepository>()),
          ),
          ChangeNotifierProvider<AppBarViewModel>(
            create: (_) => AppBarViewModel(),
          ),
          ChangeNotifierProvider<NavigationViewModel>(
            create: (_) => NavigationViewModel(),
          ),
        ],
        child: const MyApp(),
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
    final appBarViewModel = context.read<AppBarViewModel>();
    if (appBarViewModel.isSelectMode) {
      appBarViewModel.exitSelectMode();
      final navigationViewModel = context.read<NavigationViewModel>();
      if (navigationViewModel.isNotesPage) {
        context.read<NotesViewModel>().clearSelection();
      } else {
        context.read<TodosViewModel>().clearSelection();
      }
      return;
    }
    Navigator.maybePop(context);
  }
  void _handleFloatingButtonPressed() {
    final navigationViewModel = context.read<NavigationViewModel>();
    final formPage = navigationViewModel.isNotesPage
        ? const CreateNoteFormPage()
        : const CreateTodoFormPage();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Material(child: formPage)),
    );
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NavigationViewModel>().navigateToNotes();
      context.read<NotesViewModel>().loadNotes();
      context.read<TodosViewModel>().loadTodos();
    });
  }
  @override
  Widget build(BuildContext context) {
    final appBarViewModel = context.watch<AppBarViewModel>();
    final navigationViewModel = context.watch<NavigationViewModel>();
    final canPop = appBarViewModel.isInitialMode;
    final currentPageWidget = navigationViewModel.isNotesPage
        ? const NotesList()
        : const TodosList();
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: _handlePopOfPopScope,
      child: Scaffold(
        bottomNavigationBar: const BottomBar(),
        body: MainWrapper(
          child: Column(
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: AppBarWidget(),
              ),
              Expanded(child: currentPageWidget),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _handleFloatingButtonPressed,
          tooltip: navigationViewModel.fabTooltip,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
