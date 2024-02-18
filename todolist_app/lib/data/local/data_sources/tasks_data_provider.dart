import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist_app/models/task_model.dart';
import 'package:todolist_app/utils/constants.dart';
import 'package:todolist_app/utils/exception_handler.dart';

class TaskDataProvider {
  List<TaskModel> tasks = [];
  SharedPreferences? prefs;

  TaskDataProvider(this.prefs);

  Future<List<TaskModel>> getTasks() async {
    try {
      final List<String>? savedTasks = prefs!.getStringList(Constants.taskKey);
      if (savedTasks != null) {
        tasks = savedTasks
            .map((taskJson) => TaskModel.fromJson(json.decode(taskJson)))
            .toList();
        tasks.sort((a, b) {
          if (a.completed == b.completed) {
            return 0;
          } else if (a.completed) {
            return 1;
          } else {
            return -1;
          }
        });
      }
      return tasks;
    } catch (e) {
      throw Exception(handleException(e));
    }
  }

  DateTime parseDateTime(String dateTimeString) {
    // Loại bỏ bất kỳ ký tự khoảng trắng không nhìn thấy nào từ cuối chuỗi
    String sanitizedDateTimeString = dateTimeString.trim();
    // Loại bỏ khoảng trắng sau số phút trước chuỗi "PM" nếu có
    sanitizedDateTimeString = sanitizedDateTimeString.replaceAll(
        " ", " "); // Loại bỏ khoảng trắng không nhìn thấy
    // Phân tích chuỗi ngày tháng và trả về đối tượng DateTime
    return DateFormat("M/d/yyyy h:mm a").parse(sanitizedDateTimeString);
  }

  bool isToday(TaskModel task) {
    DateTime now = DateTime.now();
    DateTime taskDate = parseDateTime(task.startDateTime);
    return now.year == taskDate.year &&
        now.month == taskDate.month &&
        now.day == taskDate.day;
  }

  Future<List<TaskModel>> sortTasks(int sortOption) async {
    switch (sortOption) {
      case 0:
        tasks.sort((a, b) {
          DateTime dateA = parseDateTime(a.startDateTime);
          DateTime dateB = parseDateTime(b.startDateTime);
          return dateA.compareTo(dateB);
        });
        break;
      case 1:
        tasks.sort((a, b) {
          if (!a.completed && b.completed) {
            return 1;
          } else if (a.completed && !b.completed) {
            return -1;
          }
          return 0;
        });
        break;
      case 2:
        tasks.sort((a, b) {
          if (a.completed == b.completed) {
            return 0;
          } else if (a.completed) {
            return 1;
          } else {
            return -1;
          }
        });
        break;

      case 3:
        // Filter tasks for today
        tasks = tasks.where((task) => isToday(task)).toList();
        break;
      case 4:
        // Return all tasks
        tasks = await getTasks();
        break;
    }
    return tasks;
  }

  Future<void> createTask(TaskModel taskModel) async {
    try {
      tasks.add(taskModel);
      final List<String> taskJsonList =
          tasks.map((task) => json.encode(task.toJson())).toList();
      await prefs!.setStringList(Constants.taskKey, taskJsonList);
    } catch (exception) {
      throw Exception(handleException(exception));
    }
  }

  Future<List<TaskModel>> updateTask(TaskModel taskModel) async {
    try {
      tasks[tasks.indexWhere((element) => element.id == taskModel.id)] =
          taskModel;
      tasks.sort((a, b) {
        if (a.completed == b.completed) {
          return 0;
        } else if (a.completed) {
          return 1;
        } else {
          return -1;
        }
      });
      final List<String> taskJsonList =
          tasks.map((task) => json.encode(task.toJson())).toList();
      prefs!.setStringList(Constants.taskKey, taskJsonList);
      return tasks;
    } catch (exception) {
      throw Exception(handleException(exception));
    }
  }

  Future<List<TaskModel>> deleteTask(TaskModel taskModel) async {
    try {
      tasks.remove(taskModel);
      final List<String> taskJsonList =
          tasks.map((task) => json.encode(task.toJson())).toList();
      prefs!.setStringList(Constants.taskKey, taskJsonList);
      return tasks;
    } catch (exception) {
      throw Exception(handleException(exception));
    }
  }

  Future<List<TaskModel>> searchTasks(String keywords) async {
    var searchText = keywords.toLowerCase();
    List<TaskModel> matchedTasked = tasks;
    return matchedTasked.where((task) {
      final titleMatches = task.title.toLowerCase().contains(searchText);
      final descriptionMatches =
          task.description.toLowerCase().contains(searchText);
      return titleMatches || descriptionMatches;
    }).toList();
  }
}
