import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final String apiUrl = 'https://6735a0a75995834c8a936f0e.mockapi.io/api/v5/tasks';
  final TextEditingController _taskController = TextEditingController();
  List<Map<String, dynamic>> _tasks = [];
  int totalTasks = 100;
  int completedTasks = 0;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  // Fetch tasks dari api
  Future<void> fetchTasks() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      setState(() {
        _tasks = List<Map<String, dynamic>>.from(json.decode(response.body));
        completedTasks = _tasks.where((task) => task['completed'] == true).length;
      });
    } else {
      print("Gagal memuat tugas");
    }
  }

  void showMaxTasksReachedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Material(
              type: MaterialType.transparency,
              child: AlertDialog(
                title: Center(child: Text("Peringatan")),
                content: Text(
                  "Maksimal tugas tercapai. Tidak bisa menambah tugas baru.",
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  // Tugas baru
  Future<void> addTask(String task) async {
    if (_tasks.length >= totalTasks) {
      showMaxTasksReachedDialog();
      return;
    }
    final response = await http.post(Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"task": task, "completed": false}));
    if (response.statusCode == 201) {
      fetchTasks();
      _taskController.clear();
    } else {
      print("Gagal menambah tugas");
    }
  }

  // Complete tugas status
  Future<void> toggleTaskCompletion(String id, bool isCompleted) async {
    final response = await http.put(Uri.parse('$apiUrl/$id'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"completed": isCompleted}));
    if (response.statusCode == 200) {
      fetchTasks();  // Refresh the task list after updating
    } else {
      print("Gagal memperbarui status tugas");
    }
  }

  // Edit tugas
  Future<void> editTask(String id, String newTask) async {
    final response = await http.put(Uri.parse('$apiUrl/$id'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"task": newTask}));
    if (response.statusCode == 200) {
      fetchTasks();
    } else {
      print("Gagal mengedit tugas");
    }
  }

  // Hapus tugas
  Future<void> deleteTask(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 200) {
      fetchTasks();
    } else {
      print("Gagal menghapus tugas");
    }
  }

  // popup dialog kalo edit
  void showEditDialog(String id, String currentTask) {
    final TextEditingController editController = TextEditingController(text: currentTask);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Tugas"),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(labelText: "Edit tugas"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                if (editController.text.isNotEmpty) {
                  editTask(id, editController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  // konfirmasi sebelum hapus
  void showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Hapus"),
          content: Text("Apakah Anda yakin ingin menghapus tugas ini?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Tidak"),
            ),
            ElevatedButton(
              onPressed: () {
                deleteTask(id);
                Navigator.of(context).pop();
              },
              child: Text("Ya"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalTaskCount = _tasks.length;
    int remainingTasks = totalTaskCount - completedTasks;

    return Scaffold(
      appBar: AppBar(
        title: Text('My To-Do List'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _taskController,
                    decoration: InputDecoration(labelText: 'Masukkan tugas'),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_taskController.text.isNotEmpty) {
                      addTask(_taskController.text);
                    }
                  },
                  child: Text('Tambahkan'),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text("Maksimal 100 Tugas"),
            SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text("$totalTaskCount/$totalTasks"),
            ),
            SizedBox(height: 20),
            Text("Belum Selesai $remainingTasks/$totalTaskCount"),
            Text("Selesai $completedTasks/$totalTaskCount"),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 0),
                        leading: Checkbox(
                          value: task['completed'] ?? false,
                          onChanged: (value) {
                            toggleTaskCompletion(task['id'], value!);
                          },
                        ),
                        title: Text(task['task']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {
                                showEditDialog(task['id'], task['task']);
                              },
                              child: Text("UBAH"),
                            ),
                            SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                showDeleteConfirmationDialog(task['id']);
                              },
                              child: Text("HAPUS"),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
