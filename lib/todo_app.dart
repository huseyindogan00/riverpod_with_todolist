import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_with_todolist/future_provider.dart';
import 'package:riverpod_with_todolist/models/todo_model.dart';
import 'package:riverpod_with_todolist/providers/all_providers.dart';
import 'package:riverpod_with_todolist/widget/title_widget.dart';
import 'package:riverpod_with_todolist/widget/todo_list_item_widget.dart';
import 'package:riverpod_with_todolist/widget/toolbar_widget.dart';

class TodoApp extends ConsumerWidget {
  TodoApp({super.key});

  final newTodoController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var todoList = ref.watch<List<TodoModel>>(filterTodoList);
    print('scafold çalıştı');
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: ListView(
          children: [
            const TitleWidget(),
            TextField(
              controller: newTodoController,
              decoration: const InputDecoration(labelText: 'Neler yapacaksın bugün'),
              onSubmitted: (newTodo) {
                ref.read(todoListProvider.notifier).addTodo(newTodo);
                newTodoController.clear();
              },
            ),
            const SizedBox(height: 20),
            ToolbarWidget(),
            todoList.isEmpty
                ? Center(
                    heightFactor: 25,
                    child: Text(
                      'Herhangi bir görev bulunamadı',
                      style: TextStyle(color: Colors.amber.shade800),
                    ))
                : const SizedBox(),
            for (var i = 0; i < todoList.length; i++)
              Dismissible(
                key: ValueKey(todoList[i].id),
                child: ProviderScope(
                    overrides: [currentTodoProvider.overrideWithValue(todoList[i])],
                    child: const TodoListItemsWidget()),
                onDismissed: (_) {
                  ref.read(todoListProvider.notifier).remove(todoList[i]);
                },
              ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const FutureProviderExample();
                    },
                  ));
                },
                child: const Text('Future provider example')),
          ],
        ),
      ),
    );
  }
}
