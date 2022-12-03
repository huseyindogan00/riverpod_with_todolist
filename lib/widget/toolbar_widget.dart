import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_with_todolist/providers/all_providers.dart';

class ToolbarWidget extends ConsumerWidget {
  ToolbarWidget({super.key});

  var _currentFilter = TodoListFilter.all;

  Color changeTextColor(TodoListFilter filter) {
    return _currentFilter == filter ? Colors.orange : Colors.black12;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedCount = ref.watch(unCompletedTodoCount);
    _currentFilter = ref.watch<TodoListFilter>(todoListFilter);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text('$completedCount görev tamamlandı')),
        Tooltip(
          message: 'All Todos',
          child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: _currentFilter == TodoListFilter.all ? Colors.orange : Colors.black,
              ),
              onPressed: () {
                ref.read(todoListFilter.notifier).state = TodoListFilter.all;
              },
              child: const Text('All')),
        ),
        Tooltip(
          message: 'Only Uncompleted Todos',
          child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: _currentFilter == TodoListFilter.active ? Colors.orange : Colors.black,
              ),
              onPressed: () {
                ref.read(todoListFilter.notifier).state = TodoListFilter.active;
              },
              child: const Text('Active')),
        ),
        Tooltip(
          message: 'Only Completed Todos',
          child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: _currentFilter == TodoListFilter.completed ? Colors.orange : Colors.black,
              ),
              onPressed: () {
                ref.read(todoListFilter.notifier).state = TodoListFilter.completed;
              },
              child: const Text('Completed')),
        ),
      ],
    );
  }
}
