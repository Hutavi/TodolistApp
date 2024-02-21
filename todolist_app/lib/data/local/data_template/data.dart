import 'package:todolist_app/models/task_model.dart';

List<TaskModel> taskList = [
  TaskModel(
    id: '1',
    title: 'Task 1',
    description:
        'Description of Task 1 Description of Task 1 Description of Task 1 Description of Task 1 Description of Task 1 Description of Task 1',
    startDateTime: '2024-02-12 08:30', // Ngày 12/02/2024 lúc 8:30
    stopDateTime: '2024-02-12 10:00', // Ngày 12/02/2024 lúc 10:00
    completed: false,
  ),
  TaskModel(
    id: '2',
    title: 'Task 2',
    description: 'Description of Task 2',
    startDateTime: '2024-02-13 09:00', // Ngày 13/02/2024 lúc 9:00
    stopDateTime: '2024-02-13T11:00', // Ngày 13/02/2024 lúc 11:00
    completed: true,
  ),
];
