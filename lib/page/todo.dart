import 'package:flutter/material.dart';  
import 'package:http/http.dart' as http;  
import 'dart:convert';  

class TodoPage extends StatefulWidget {  
  @override  
  _TodoPageState createState() => _TodoPageState();  
}  

class _TodoPageState extends State<TodoPage> {  
  final String apiUrl = 'https://6735a0a75995834c8a936f0e.mockapi.io/api/v5/items';  
  final TextEditingController _taskController = TextEditingController();  
  List<Map<String, dynamic>> _tasks = [];  
  int totalTasks = 50;  
  int completedTasks = 0;  

  @override  
  void initState() {  
    super.initState();  
    fetchTasks();  
  }  

  // Fetch tasks dari api  
  Future<void> fetchTasks() async {  
    try {  
      final response = await http.get(Uri.parse(apiUrl));  
      
      if (response.statusCode == 200) {  
        setState(() {  
          // Filter hanya item dengan type "todo"  
          _tasks = List<Map<String, dynamic>>.from(  
            json.decode(response.body)  
              .where((item) => item['type'] == 'todo')  
              .toList()  
          );  
          
          completedTasks = _tasks.where((task) => task['completed'] == true).length;  
        });  
      } else {  
        print("Gagal memuat tugas: ${response.statusCode}");  
      }  
    } catch (e) {  
      print("Error fetching tasks: $e");  
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
    
    try {  
      final response = await http.post(  
        Uri.parse(apiUrl),  
        headers: {"Content-Type": "application/json"},  
        body: json.encode({  
          "task": task,   
          "completed": false,  
          "type": "todo",  
          "createdAt": DateTime.now().toIso8601String(),  
          "lastEdited": DateTime.now().toIso8601String()  
        })  
      );  

      if (response.statusCode == 201) {  
        // Tambahkan di akhir list, bukan di awal  
        final newTask = json.decode(response.body);  
        
        setState(() {  
          _tasks.insert(0, { 
            'id': newTask['id'],  
            'task': newTask['task'],  
            'completed': false,  
            'type': 'todo'  
          });  
          
          completedTasks = _tasks.where((task) => task['completed'] == true).length;  
        });  

        _taskController.clear();  
      } else {  
        print("Gagal menambah tugas: ${response.statusCode}");  
      }  
    } catch (e) {  
      print('Error adding task: $e');  
    }  
  }

  // Complete tugas status  
  Future<void> toggleTaskCompletion(String id, bool isCompleted) async {  
    final response = await http.put(  
      Uri.parse('$apiUrl/$id'),  
      headers: {"Content-Type": "application/json"},  
      body: json.encode({"completed": isCompleted})  
    );  
    
    if (response.statusCode == 200) {  
      setState(() {  
        // Temukan index task yang spesifik  
        int index = _tasks.indexWhere((task) => task['id'] == id);  
        if (index != -1) {  
          // Update hanya completed status pada task tersebut  
          _tasks[index]['completed'] = isCompleted;  
          
          // Perbarui hitungan completed tasks  
          completedTasks = _tasks.where((task) => task['completed'] == true).length;  
        }  
      });  
    } else {  
      print("Gagal memperbarui status tugas");  
    }  
  }

  // Edit tugas  
  Future<void> editTask(String id, String newTask) async {  
    final response = await http.put(  
      Uri.parse('$apiUrl/$id'),  
      headers: {"Content-Type": "application/json"},  
      body: json.encode({"task": newTask})  
    );  
    
    if (response.statusCode == 200) {  
      setState(() {  
        // Temukan index task yang spesifik  
        int index = _tasks.indexWhere((task) => task['id'] == id);  
        if (index != -1) {  
          // Update hanya task pada index tersebut  
          _tasks[index]['task'] = newTask;  
        }  
      });  
    } else {  
      print("Gagal mengedit tugas");  
    }  
  }

  // Hapus tugas  
  Future<void> deleteTask(String id) async {  
    final response = await http.delete(Uri.parse('$apiUrl/$id'));  
    
    if (response.statusCode == 200) {  
      setState(() {  
        // Hapus task berdasarkan id  
        _tasks.removeWhere((task) => task['id'] == id);  
        
        // Perbarui hitungan completed tasks  
        completedTasks = _tasks.where((task) => task['completed'] == true).length;  
      });  
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
        centerTitle: true,
        title: Text('My To-Do List'),  
        backgroundColor: Colors.deepOrange,  
      ),  
      body: Padding(  
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),  
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,  
          children: [  
            // Hapus baris Row untuk input tugas  

            SizedBox(height: 8),  
            Text("Maksimal 50 Tugas"),  
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
              child: ListView.separated(  
                itemCount: _tasks.length,  
                separatorBuilder: (context, index) => Divider(),  
                itemBuilder: (context, index) {  
                  final task = _tasks[index];  
                  return ListTile(  
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
                  );  
                },  
              ),  
            ),  
          ],  
        ),  
      ),  
      floatingActionButton: FloatingActionButton(  
        heroTag: 'FABTask',
        onPressed: _showAddTaskBottomSheet,  
        child: Icon(Icons.add),  
        backgroundColor: Colors.deepOrange,  
      ),  
    );  
  }  

  // Tambahkan method baru untuk menampilkan bottom sheet  
  void _showAddTaskBottomSheet() {  
    showDialog(  
      context: context,  
      builder: (BuildContext context) {  
        return AlertDialog(  
          title: Text("Tambah Tugas Baru"),  
          content: TextField(  
            controller: _taskController,  
            decoration: InputDecoration(labelText: "Masukkan tugas"),  
          ),  
          actions: [  
            TextButton(  
              onPressed: () {  
                Navigator.of(context).pop();  
                _taskController.clear(); // Bersihkan controller saat batal  
              },  
              child: Text("Batal"),  
            ),  
            ElevatedButton(  
              onPressed: () {  
                if (_taskController.text.isNotEmpty) {  
                  addTask(_taskController.text);  
                  Navigator.of(context).pop();  
                  _taskController.clear(); // Bersihkan controller setelah tambah  
                }  
              },  
              child: Text("Tambah"),  
            ),  
          ],  
        );  
      },  
    );  
  }
}