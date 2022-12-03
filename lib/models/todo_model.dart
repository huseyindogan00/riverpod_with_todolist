class TodoModel {
  final String id;
  final String description;
  bool completed;

  TodoModel({required this.id, required this.description, this.completed = false});
}
