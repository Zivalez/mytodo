import 'dart:convert';  
import 'package:http/http.dart' as http;  
import '../models/note_model.dart';  

class NotesService {  
  // URL API untuk operasi catatan  
  static const String baseUrl = 'https://6735a0a75995834c8a936f0e.mockapi.io/api/v5/notes';  

  // Method untuk mengambil semua catatan  
  Future<List<Note>> fetchNotes() async {  
    try {  
      final response = await http.get(Uri.parse(baseUrl));  
      
      if (response.statusCode == 200) {  
        // Parsing JSON menjadi list of Notes  
        List<dynamic> body = json.decode(response.body);  
        return body.map((dynamic item) => Note.fromJson(item)).toList();  
      } else {  
        // Lempar exception jika gagal  
        throw Exception('Failed to load notes: ${response.statusCode}');  
      }  
    } catch (e) {  
      // Tangani error koneksi  
      throw Exception('Network error: $e');  
    }  
  }  

  // Method untuk membuat catatan baru  
  Future<Note> createNote(String title, String content) async {  
    try {  
      String currentTime = DateTime.now().toIso8601String();  
      Map<String, dynamic> newNoteData = {  
        'title': title,  
        'content': content,  
        'createdAt': currentTime,  
        'lastEdited': currentTime, // Set lastEdited sama dengan createdAt  
      };  

      final response = await http.post(  
        Uri.parse(baseUrl),  
        body: json.encode(newNoteData),  
        headers: {'Content-Type': 'application/json'},  
      );  

      if (response.statusCode == 201) {  
        return Note.fromJson(json.decode(response.body));  
      } else {  
        print('Response status: ${response.statusCode}');  
        print('Response body: ${response.body}');  
        throw Exception('Failed to create note');  
      }  
    } catch (e) {  
      throw Exception('Error creating note: $e');  
    }  
  }

  // Method tambahan: Hapus catatan (opsional)  
  Future<void> deleteNote(String id) async {  
    try {  
      final response = await http.delete(Uri.parse('$baseUrl/$id'));  
      
      if (response.statusCode != 200) {  
        throw Exception('Failed to delete note: ${response.statusCode}');  
      }  
    } catch (e) {  
      throw Exception('Network error: $e');  
    }  
  }  

// Metode untuk memperbarui catatan  
  Future<Note> updateNote(String id, String title, String content) async {  
    try {  
      String currentTime = DateTime.now().toIso8601String();  
      Map<String, dynamic> updateData = {  
        'id': id,  
        'title': title,  
        'content': content,  
        'lastEdited': currentTime // Pastikan ini diperbarui  
      };  

      final response = await http.put(  
        Uri.parse('$baseUrl/$id'),  
        body: json.encode(updateData),  
        headers: {'Content-Type': 'application/json'},  
      );  

      if (response.statusCode == 200) {  
        return Note.fromJson(json.decode(response.body));  
      } else {  
        print('Response status: ${response.statusCode}');  
        print('Response body: ${response.body}');  
        throw Exception('Failed to update note');  
      }  
    } catch (e) {  
      throw Exception('Error updating note: $e');  
    }  
  }
}