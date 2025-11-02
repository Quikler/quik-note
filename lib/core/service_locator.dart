import 'package:quik_note/core/note_cache.dart';
import 'package:quik_note/core/todo_cache.dart';
import 'package:quik_note/repositories/note_repository.dart';
import 'package:quik_note/repositories/note_repository_impl.dart';
import 'package:quik_note/repositories/todo_repository.dart';
import 'package:quik_note/repositories/todo_repository_impl.dart';
import 'package:quik_note/services/note_form_service.dart';
import 'package:quik_note/services/todo_form_service.dart';
import 'package:quik_note/viewmodels/app_bar_viewmodel.dart';
import 'package:quik_note/viewmodels/navigation_viewmodel.dart';
import 'package:quik_note/viewmodels/note_form_viewmodel.dart';
import 'package:quik_note/viewmodels/notes_viewmodel.dart';
import 'package:quik_note/viewmodels/todo_form_viewmodel.dart';
import 'package:quik_note/viewmodels/todos_viewmodel.dart';

class ServiceLocator {
  ServiceLocator._();
  static final Map<Type, dynamic> _services = {};
  static bool _isInitialized = false;
  static void setup() {
    if (_isInitialized) return;
    _registerSingleton<TodoCache>(TodoCache());
    _registerSingleton<NoteCache>(NoteCache());
    _registerSingleton<NoteRepository>(const NoteRepositoryImpl());
    _registerSingleton<TodoRepository>(const TodoRepositoryImpl());
    _registerSingleton<TodoFormService>(
      TodoFormService(get<TodoRepository>(), get<TodoCache>()),
    );
    _registerSingleton<NoteFormService>(
      NoteFormService(get<NoteRepository>(), get<NoteCache>()),
    );
    _registerFactory<NotesViewModel>(
      () => NotesViewModel(get<NoteRepository>()),
    );
    _registerFactory<TodosViewModel>(
      () => TodosViewModel(get<TodoRepository>()),
    );
    _registerFactory<AppBarViewModel>(() => AppBarViewModel());
    _registerFactory<NavigationViewModel>(() => NavigationViewModel());
    _registerFactory<TodoFormViewModel>(
      () => TodoFormViewModel(get<TodoFormService>()),
    );
    _registerFactory<NoteFormViewModel>(
      () => NoteFormViewModel(get<NoteFormService>()),
    );
    _isInitialized = true;
  }

  static void _registerSingleton<T>(T instance) {
    _services[T] = instance;
  }

  static void _registerFactory<T>(T Function() factory) {
    _services[T] = factory;
  }

  static T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception(
        'Service of type $T is not registered. '
        'Did you forget to call ServiceLocator.setup()?',
      );
    }
    if (service is T Function()) {
      return service();
    }
    return service as T;
  }

  static bool isRegistered<T>() {
    return _services.containsKey(T);
  }

  static void reset() {
    _services.clear();
    _isInitialized = false;
  }

  static void replace<T>(T instance) {
    _services[T] = instance;
  }

  static void replaceFactory<T>(T Function() factory) {
    _services[T] = factory;
  }
}
