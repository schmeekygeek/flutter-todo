import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/classes/task.dart';
import 'package:todo/services/shared_prefs_service.dart';

class TaskModel with ChangeNotifier {

  SharedPreferences? prefs;
  String _input = '';

  List<Task> tasks = [];

  void addTask(String text, int index) async {
    tasks.insert(0, Task(text: text, isDone: false));
    saveData();
    notifyListeners();
  }

  void addTaskObject(Task task, int index) async {
    tasks.insert(index, task);
    saveData();
    notifyListeners();
  }

  void toggleDone(Task task){
    task.toggle();
    saveData();
    notifyListeners();
  }

  void removeTask(Task taskToRemove){
    tasks.remove(taskToRemove);
    saveData();
    notifyListeners();
  }

  void initPrefs() async {
    await SharedPreferencesService.init();
    prefs = SharedPreferencesService.instance;
    loadData();
    notifyListeners();
  }

  void saveData() {
    List<String>? prefList = tasks.map((task) => json.encode(task.toMap())).toList();
    prefs?.setStringList('tasks', prefList);
  }

  void loadData() {
    List<String>? prefList = prefs!.getStringList('tasks');
    if (prefList != null) {
      tasks = prefList.map((task) => Task.fromMap(json.decode(task))).toList();
    }
  }

  void setInput(String inputText) => _input = inputText;
  String getInput() => _input;
}
