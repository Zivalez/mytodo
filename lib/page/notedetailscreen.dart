import 'package:flutter/material.dart';  
import '../models/note_model.dart';  
import '../service/notes_service.dart';  
import 'package:intl/intl.dart';  

class NoteDetailScreen extends StatefulWidget {  
  final Note note;  

  const NoteDetailScreen({Key? key, required this.note}) : super(key: key);  

  @override  
  _NoteDetailScreenState createState() => _NoteDetailScreenState();  
}  

class _NoteDetailScreenState extends State<NoteDetailScreen> {  
  final NotesService _notesService = NotesService();  
  late TextEditingController _contentController;  
  late TextEditingController _titleController;  
  bool _isEditingContent = false;  
  late Note _currentNote; // Tambahkan variabel untuk menyimpan catatan saat ini  

  @override  
  void initState() {  
    super.initState();  
    // Inisialisasi dengan menggunakan widget.note sebagai _currentNote  
    _currentNote = widget.note;  
    _contentController = TextEditingController(text: _currentNote.content);  
    _titleController = TextEditingController(text: _currentNote.title);  
  }  

  @override  
  void dispose() {  
    _contentController.dispose();  
    _titleController.dispose();  
    super.dispose();  
  }  

  // Method untuk menampilkan dialog edit judul  
  void _showEditTitleDialog() {  
    _titleController.text = _currentNote.title;  

    showDialog(  
      context: context,  
      builder: (context) {  
        return AlertDialog(  
          title: Text("Edit Title"),  
          content: TextField(  
            controller: _titleController,  
            decoration: InputDecoration(labelText: "Title"),  
          ),  
          actions: [  
            TextButton(  
              onPressed: () {  
                Navigator.of(context).pop();  
              },  
              child: Text("Cancel"),  
            ),  
            ElevatedButton(  
              onPressed: () async {  
                if (_titleController.text.isNotEmpty) {  
                  try {  
                    Note updatedNote = await _notesService.updateNote(  
                      _currentNote.id,  
                      _titleController.text,  
                      _currentNote.content, // Konten tetap sama  
                    );  

                    setState(() {  
                      _currentNote = updatedNote; // Perbarui _currentNote dengan data terbaru  
                      _titleController.text = updatedNote.title;  
                    });  

                    Navigator.of(context).pop(); // Tutup dialog  
                  } catch (e) {  
                    ScaffoldMessenger.of(context).showSnackBar(  
                      SnackBar(content: Text('Failed to update title: $e')),  
                    );  
                  }  
                }  
              },  
              child: Text("Save"),  
            ),  
          ],  
        );  
      },  
    );  
  }  

  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        title: Text(_currentNote.title), // Gunakan _currentNote  
        backgroundColor: Colors.deepOrange,  
        actions: [  
          IconButton(  
            icon: Icon(Icons.edit),  
            onPressed: _showEditTitleDialog,  
          ),  
        ],  
      ),  
      body: Padding(  
        padding: const EdgeInsets.all(16.0),  
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,  
          children: [  
            Text(  
              'Dibuat pada: ${_formatDateTime(_currentNote.createdAt)}',  
              style: TextStyle(color: Colors.grey),  
            ),  
            SizedBox(height: 8),  
            Text(  
              'Terakhir diedit: ${_formatDateTime(_currentNote.lastEdited)}', // Gunakan lastEdited  
              style: TextStyle(color: Colors.grey),  
            ),  
            SizedBox(height: 16),  
            GestureDetector(  
              onTap: () {  
                setState(() {  
                  _isEditingContent = true;  
                });  
              },  
              child: _isEditingContent  
                  ? TextField(  
                      controller: _contentController,  
                      maxLines: null,  
                      keyboardType: TextInputType.multiline,  
                      decoration: InputDecoration(  
                        labelText: "Edit Content",  
                        border: OutlineInputBorder(),  
                      ),  
                    )  
                  : Text(  
                      _currentNote.content, // Gunakan _currentNote  
                      style: TextStyle(fontSize: 18),  
                    ),  
            ),  
            if (_isEditingContent)  
              Row(  
                mainAxisAlignment: MainAxisAlignment.end,  
                children: [  
                  TextButton(  
                    onPressed: () {  
                      setState(() {  
                        _isEditingContent = false;  
                        _contentController.text = _currentNote.content;  
                      });  
                    },  
                    child: Text("Cancel"),  
                  ),  
                  SizedBox(width: 8),  
                  ElevatedButton(  
                    onPressed: () async {  
                      if (_contentController.text.isNotEmpty) {  
                        try {  
                          Note updatedNote = await _notesService.updateNote(  
                            _currentNote.id,  
                            _currentNote.title,  
                            _contentController.text,  
                          );  

                          setState(() {  
                            _currentNote = updatedNote; // Perbarui _currentNote dengan data terbaru  
                            _contentController.text = updatedNote.content;  
                            _isEditingContent = false;  
                          });  
                        } catch (e) {  
                          ScaffoldMessenger.of(context).showSnackBar(  
                            SnackBar(content: Text('Failed to update note: $e')),  
                          );  
                        }  
                      }  
                    },  
                    child: Text("Save"),  
                  ),  
                ],  
              ),  
          ],  
        ),  
      ),  
    );  
  }  

  // Helper method to format datetime  
  String _formatDateTime(String dateTimeString) {  
    try {  
      DateTime dateTime = DateTime.parse(dateTimeString);  
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);  
    } catch (e) {  
      return dateTimeString.isNotEmpty ? dateTimeString : 'Unknown date';  
    }  
  }  
}