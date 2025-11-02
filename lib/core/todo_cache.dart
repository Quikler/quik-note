import 'package:quik_note/core/cache_service.dart';
import 'package:quik_note/viewmodels/todo_vm.dart';

class TodoCache extends InMemoryCacheService<int, TodoVm> {
  static final TodoCache _instance = TodoCache._internal();
  factory TodoCache() => _instance;
  TodoCache._internal();
}
