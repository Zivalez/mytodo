import 'dart:convert';  
import 'package:http/http.dart' as http;  

class TodoService {  
  static const String baseUrl = 'https://6735a0a75995834c8a936f0e.mockapi.io/api/v5/items';  

  Future<List<dynamic>> fetchTodos() async {  
    try {  
      final response = await http.get(Uri.parse('$baseUrl?type=todo'));  
      print('Response status: ${response.statusCode}'); // Debugging  
      print('Response body: ${response.body}'); // Debugging  

      if (response.statusCode == 200) {  
        List<dynamic> body = json.decode(response.body);  
        return body;  
      } else {  
        throw Exception('Failed to load todos: ${response.statusCode}');  
      }  
    } catch (e) {  
      print('Network error: $e'); // Debugging  
      throw Exception('Network error: $e');  
    }  
  }

  Future<dynamic> createTodo(String task) async {  
    try {  
      List<dynamic> todos = await fetchTodos(); // Ambil semua todo  
      print('Current number of todos: ${todos.length}'); // Debugging  

      if (todos.length >= 50) {  
        throw Exception('Maximum limit of 50 todos reached');  
      }  

      String currentTime = DateTime.now().toIso8601String();  
      Map<String, dynamic> newTodoData = {  
        'task': task,  
        'createdAt': currentTime,  
        'lastEdited': currentTime,  
        'type': 'todo',  
      };  

      final response = await http.post(  
        Uri.parse(baseUrl),  
        body: json.encode(newTodoData),  
        headers: {'Content-Type': 'application/json'},  
      );  

      print('Response status: ${response.statusCode}'); // Debugging  
      print('Response body: ${response.body}'); // Debugging  

      if (response.statusCode == 201) {  
        return json.decode(response.body);  
      } else {  
        throw Exception('Failed to create todo');  
      }  
    } catch (e) {  
      print('Error creating todo: $e'); // Debugging  
      throw Exception('Error creating todo: $e');  
    }  
  }

  // Method untuk menghapus todo  
  Future<void> deleteTodo(String id) async {  
    try {  
      final response = await http.delete(Uri.parse('$baseUrl/$id'));  
      
      if (response.statusCode != 200) {  
        throw Exception('Failed to delete todo: ${response.statusCode}');  
      }  
    } catch (e) {  
      throw Exception('Network error: $e');  
    }  
  }  

  // Method untuk memperbarui todo  
  Future<dynamic> updateTodo(String id, String task) async {  
    try {  
      String currentTime = DateTime.now().toIso8601String();  
      Map<String, dynamic> updateData = {  
        'task': task,  
        'lastEdited': currentTime,  
        'type': 'todo', // Pastikan type tetap todo  
      };  

      final response = await http.put(  
        Uri.parse('$baseUrl/$id'),  
        body: json.encode(updateData),  
        headers: {'Content-Type': 'application/json'},  
      );  

      if (response.statusCode == 200) {  
        return json.decode(response.body); // Kembalikan todo yang diperbarui  
      } else {  
        throw Exception('Failed to update todo');  
      }  
    } catch (e) {  
      throw Exception('Error updating todo: $e');  
    }  
  }  
}