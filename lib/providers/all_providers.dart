import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_with_todolist/models/todo_model.dart';
import 'package:riverpod_with_todolist/providers/todo_list_manager.dart';
import 'package:uuid/uuid.dart';

final todoListProvider = StateNotifierProvider<TodoListManager, List<TodoModel>>((ref) => TodoListManager(
      [
        TodoModel(id: const Uuid().v4(), description: 'Spora git'),
        TodoModel(id: const Uuid().v4(), description: 'Ders çalış'),
        TodoModel(id: const Uuid().v4(), description: 'Alışveriş yap'),
        TodoModel(id: const Uuid().v4(), description: 'Kitap oku'),
      ],
    ));

final unCompletedTodoCount = Provider<int>(
  (ref) {
    final allTodo = ref.watch(todoListProvider);
    final count = allTodo.where((todoModel) => todoModel.completed).length;
    return count;
  },
);

final currentTodoProvider = Provider<TodoModel>((ref) => throw UnimplementedError()
    //return TodoModel(id: '', description: '');
    );

final todoListFilter = StateProvider<TodoListFilter>((ref) => TodoListFilter.all);

final filterTodoList = Provider<List<TodoModel>>(
  (ref) {
    final filter = ref.watch(todoListFilter);
    final todoList = ref.watch(todoListProvider);

    switch (filter) {
      case TodoListFilter.all:
        return todoList;
      case TodoListFilter.completed:
        return todoList.where((element) => element.completed).toList();
      case TodoListFilter.active:
        return todoList.where((element) => !element.completed).toList();
    }
  },
);

enum TodoListFilter { all, active, completed }
