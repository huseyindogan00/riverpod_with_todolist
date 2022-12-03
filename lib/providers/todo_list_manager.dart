import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_with_todolist/models/todo_model.dart';
import 'package:uuid/uuid.dart';

class TodoListManager extends StateNotifier<List<TodoModel>> {
  TodoListManager([List<TodoModel>? initialTodos]) : super(initialTodos ?? []);

  void addTodo(String description) {
    state = [...state, TodoModel(id: const Uuid().v4(), description: description)];
  }

  void toggle(String id) {
    state = [
      for (var todo in state)
        if (todo.id == id)
          TodoModel(
            id: todo.id,
            description: todo.description,
            completed: !todo.completed,
          )
        else
          todo
    ];

    onCompletedTodoCount();
    /* int selectedId = state.indexWhere((todoModel) => todoModel.id == id);
    state[selectedId].completed = !state[selectedId].completed; */
  }

  void edit({required String id, required String description}) {
    state = [
      for (var todo in state)
        if (todo.id == id) TodoModel(id: id, description: description, completed: todo.completed) else todo
    ];
  }

  void remove(TodoModel removeTodo) {
    state = state.where((todo) => todo.id != removeTodo.id).toList();
  }

  int onCompletedTodoCount() {
    return state.where((todoModel) => todoModel.completed == false).toList().length;
  }
}
