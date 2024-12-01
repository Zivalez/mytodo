import 'dart:convert';  
import 'package:http/http.dart' as http;  
import '../models/note_model.dart';  

class NotesService {  
  static const String baseUrl = 'https://6735a0a75995834c8a936f0e.mockapi.io/api/v5/items';  

  Future<List<Note>> fetchNotes() async {  
    try {  
      final response = await http.get(Uri.parse('$baseUrl?type=note'));  
      
      if (response.statusCode == 200) {  
        List<dynamic> body = json.decode(response.body);  
        return body.map((dynamic item) => Note.fromJson(item)).toList();  
      } else {  
        throw Exception('Failed to load notes: ${response.statusCode}');  
      }  
    } catch (e) {  
      throw Exception('Network error: $e');  
    }  
  }  

  Future<Note> createNote(String title, String content) async {  
    try {  
      // Ambil semua catatan terlebih dahulu  
      final notes = await fetchNotes();  

      // Periksa jumlah catatan  
      if (notes.length >= 50) {  
        throw Exception('Maksimal 50 catatan telah tercapai');  
      }  

      String currentTime = DateTime.now().toIso8601String();  
      Map<String, dynamic> newNoteData = {  
        'title': title,  
        'content': content,  
        'createdAt': currentTime,  
        'lastEdited': currentTime,  
        'type': 'note',  
      };  

      final response = await http.post(  
        Uri.parse(baseUrl),  
        body: json.encode(newNoteData),  
        headers: {'Content-Type': 'application/json'},  
      );  

      if (response.statusCode == 201) {  
        return Note.fromJson(json.decode(response.body));  
      } else {  
        throw Exception('Gagal membuat catatan');  
      }  
    } catch (e) {  
      throw Exception('Error membuat catatan: $e');  
    }  
  }

  // Method tambahan: Hapus catatan  
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
        'lastEdited': currentTime, // Pastikan ini diperbarui  
        'type': 'note', // Pastikan type tetap note  
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