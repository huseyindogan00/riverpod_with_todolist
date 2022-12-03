// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_with_todolist/providers/all_providers.dart';

class TodoListItemsWidget extends ConsumerStatefulWidget {
  const TodoListItemsWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodoListItemsWidgetState();
}

class _TodoListItemsWidgetState extends ConsumerState<TodoListItemsWidget> {
  late FocusNode _textFocusNode;
  late TextEditingController _textController;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTodoItem = ref.watch(currentTodoProvider);
    return Focus(
      onFocusChange: (isFocused) {
        if (!isFocused) {
          _hasFocus = false;
          ref.read(todoListProvider.notifier).edit(id: currentTodoItem.id, description: _textController.text);
        }
      },
      child: ListTile(
        onTap: () {
          setState(() {
            _hasFocus = true;
            _textController.text = currentTodoItem.description;
            _textFocusNode.requestFocus();
          });
        },
        leading: Checkbox(
          value: currentTodoItem.completed,
          onChanged: (value) {
            ref.read(todoListProvider.notifier).toggle(currentTodoItem.id);
          },
        ),
        title: _hasFocus
            ? TextField(
                focusNode: _textFocusNode,
                controller: _textController,
              )
            : Text(currentTodoItem.description),
      ),
    );
  }
}
