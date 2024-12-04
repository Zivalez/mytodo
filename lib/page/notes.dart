import 'package:flutter/material.dart';
import 'package:mytodo/widgets/color_loader4.dart'; 
import '../models/note_model.dart';  
import 'package:mytodo/service/notes_service.dart';  
import 'package:mytodo/page/notedetailscreen.dart'; 
import 'package:intl/intl.dart'; 

class NotesScreen extends StatefulWidget {  
  const NotesScreen({Key? key}) : super(key: key);  

  @override  
  _NotesScreenState createState() => _NotesScreenState();  
}  

class _NotesScreenState extends State<NotesScreen> {  
  final NotesService _notesService = NotesService();  
  final TextEditingController _titleController = TextEditingController();  
  final TextEditingController _contentController = TextEditingController();  

  bool _isSelectionMode = false;
  Set<String> _selectedNoteIds = {};

  void _toggleSelectionMode(Note note) {  
    setState(() {  
      if (_selectedNoteIds.contains(note.id)) {  
        _selectedNoteIds.remove(note.id);  
      } else {  
        _selectedNoteIds.add(note.id);  
      }  

      _isSelectionMode = _selectedNoteIds.isNotEmpty;  
    });  
  }  

  void _selectAllNotes() {  
    setState(() {  
      if (_selectedNoteIds.length == _notes.length) {   
        _selectedNoteIds.clear();  
        _isSelectionMode = false;  
      } else {  
        _selectedNoteIds = _notes.map((note) => note.id).toSet();  
        _isSelectionMode = true;  
      }  
    });  
  }  

  Future<void> _deleteSelectedNotes() async {  
    // Tampilkan konfirmasi dialog  
    bool? confirmDelete = await showDialog(  
      context: context,  
      builder: (context) => AlertDialog(  
        title: Text('Hapus Catatan'),  
        content: Text('Apakah Anda yakin ingin menghapus ${_selectedNoteIds.length} catatan?'),  
        actions: [  
          TextButton(  
            onPressed: () => Navigator.of(context).pop(false),  
            child: Text('Batal'),  
          ),  
          ElevatedButton(  
            onPressed: () => Navigator.of(context).pop(true),  
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),  
            child: Text('Hapus'),  
          ),  
        ],  
      ),  
    );  

    if (confirmDelete == true) {  
      try {  
        for (String id in _selectedNoteIds) {  
          await _notesService.deleteNote(id);  
        }  

        await _fetchNotes();  

        setState(() {  
          _selectedNoteIds.clear();  
          _isSelectionMode = false;  
        });  

        _showSnackBar('${_selectedNoteIds.length} catatan berhasil dihapus');  
      } catch (e) {  
        _showSnackBar('Gagal menghapus catatan', isError: true);  
      }  
    }  
  }  

  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: _isSelectionMode  
          ? AppBar(  
              leading: IconButton(  
                icon: Icon(Icons.close),  
                onPressed: () {  
                  setState(() {  
                    _selectedNoteIds.clear();  
                    _isSelectionMode = false;  
                  });  
                },  
              ),  
              title: Text('${_selectedNoteIds.length} dipilih'),  
              actions: [  
                IconButton(  
                  icon: Icon(Icons.select_all),  
                  onPressed: _selectAllNotes,  
                ),  
                IconButton(  
                  icon: Icon(Icons.delete, color: Colors.red),  
                  onPressed: _deleteSelectedNotes,  
                ),  
              ],  
              backgroundColor: Colors.deepOrange.shade200,  
            )  
          : AppBar(  
              centerTitle: true,            
              title: const Text('Notes'),  
              backgroundColor: Colors.deepOrange,  
            ),  
      body: Column(  
        children: [  
          Expanded(  
            child: RefreshIndicator(
              onRefresh: _fetchNotes,   
              child: _isLoading
                  ? Center(child: ColorLoader4())  
                  : _buildNotesList(),
            ),  
          ),  
        ],  
      ),  
      floatingActionButton: _isSelectionMode   
          ? null   
          : FloatingActionButton(  
              heroTag: 'FABNote',  
              onPressed: _showAddNoteBottomSheet,  
              child: Icon(Icons.add),  
              backgroundColor: Colors.deepOrange,  
            ),  
    );  
  }

  Widget _createNotesListView() {  
    if (_notes.isEmpty) {  
      return ListView(  
        physics: AlwaysScrollableScrollPhysics(),   
        children: [  
          Center(  
            child: Text(  
              'No notes found',  
              style: TextStyle(fontSize: 18, color: Colors.grey),  
            ),  
          ),  
        ],  
      );  
    }  

    return ListView.separated(  
      physics: AlwaysScrollableScrollPhysics(),   
      itemCount: _notes.length,  
      separatorBuilder: (context, index) => Divider(  
        color: Colors.grey.shade300,  
        thickness: 1,  
        indent: 16,  
        endIndent: 16,  
      ),  
      itemBuilder: (context, index) {  
        final note = _notes[index];  
        final isSelected = _selectedNoteIds.contains(note.id);  
        
        return Dismissible(  
          key: Key(note.id),  
          background: Container(color: Colors.red),  
          onDismissed: (direction) {  
            setState(() {  
              _notes.removeAt(index);  
            });  
          },  
          child: ListTile(  
            tileColor: isSelected   
              ? Colors.deepOrange.withOpacity(0.2)   
              : null,  
            
            leading: _isSelectionMode  
              ? Checkbox(  
                  value: isSelected,  
                  onChanged: (bool? value) => _toggleSelectionMode(note),  
                  activeColor: Colors.deepOrange,  
                )  
              : null,  
            
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),  
            title: Text(  
              note.title,   
              style: TextStyle(fontWeight: FontWeight.bold),  
            ),  
            subtitle: Text(  
              note.content,  
              maxLines: 1,  
              overflow: TextOverflow.ellipsis,  
            ),  
            trailing: Column(  
              mainAxisAlignment: MainAxisAlignment.center,  
              crossAxisAlignment: CrossAxisAlignment.end,  
              children: [  
                Text(  
                  _formatLastEdited(note.lastEdited),  
                  style: TextStyle(  
                    fontSize: 12,  
                    color: Colors.grey.shade600,  
                  ),  
                ),  
              ],  
            ),  
                        onLongPress: () {  
              setState(() {  
                _isSelectionMode = true;  
                _selectedNoteIds.add(note.id);  
              });  
            },  
            
            onTap: _isSelectionMode   
              ? () => _toggleSelectionMode(note)  
              : () async {  
                  final updatedNote = await Navigator.push(  
                    context,  
                    MaterialPageRoute(  
                      builder: (context) => NoteDetailScreen(note: note),  
                    ),  
                  );  

                  await _fetchNotes();  

                  if (updatedNote != null) {  
                    setState(() {  
                      int index = _notes.indexWhere((n) => n.id == updatedNote.id);  
                      if (index != -1) {  
                        _notes[index] = updatedNote;  
                      }  
                    });  
                  }  
                },  
          ),  
        );  
      },  
    );  
  }
  
  List<Note> _notes = [];  
  bool _isLoading = false;  
  String _errorMessage = '';  

  @override  
  void initState() {  
    super.initState();  
    _fetchNotes();  
  }  

  Future<void> _fetchNotes() async {  
    setState(() {  
      _isLoading = true;  
      _errorMessage = '';  
    });  

    try {  
      final notes = await _notesService.fetchNotes();  
      setState(() {    
        _notes = notes..sort((a, b) =>   
          DateTime.parse(b.lastEdited).compareTo(DateTime.parse(a.lastEdited))  
        );  
        _isLoading = false;  
      });  
    } catch (e) {  
      setState(() {  
        _errorMessage = e.toString();  
        _isLoading = false;  
      });  
    }  
  }

  Future<void> _addNote() async {  
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {  
      _showSnackBar('Judul dan konten harus diisi', isError: true);  
      return;  
    }  
 
    if (_notes.length >= 50) {  
      _showSnackBar('Maksimal 50 catatan telah tercapai', isError: true);  
      return;  
    }  

    try {  
      final newNote = await _notesService.createNote(  
        _titleController.text,  
        _contentController.text,  
      );  
      
      setState(() {   
        _notes.insert(0, newNote);  
        _titleController.clear();  
        _contentController.clear();  
      });  

      _showSnackBar('Catatan berhasil ditambahkan');  
    } catch (e) {  
      _showSnackBar('Gagal menambahkan catatan', isError: true);  
    }  
  }  
 
  void _showSnackBar(String message, {bool isError = false}) {  
    ScaffoldMessenger.of(context).showSnackBar(  
      SnackBar(  
        content: Text(message),  
        backgroundColor: isError ? Colors.red : Colors.green,  
      ),  
    );  
  }  

  void _showAddNoteBottomSheet() {  
    showModalBottomSheet(  
      context: context,  
      isScrollControlled: true,  
      shape: RoundedRectangleBorder(  
        borderRadius: BorderRadius.vertical(  
          top: Radius.circular(20),  
        ),  
      ),  
      builder: (context) => Padding(  
        padding: EdgeInsets.only(  
          bottom: MediaQuery.of(context).viewInsets.bottom,  
          top: 20,  
          left: 20,  
          right: 20,  
        ),  
        child: Column(  
          mainAxisSize: MainAxisSize.min,  
          crossAxisAlignment: CrossAxisAlignment.stretch,  
          children: [  
            Text(  
              'Buat Catatan Baru',  
              style: TextStyle(  
                fontSize: 20,  
                fontWeight: FontWeight.bold,  
                color: Colors.deepOrange,  
              ),  
              textAlign: TextAlign.center,  
            ),  
            SizedBox(height: 16),  
            TextField(  
              controller: _titleController,  
              decoration: InputDecoration(  
                labelText: 'Judul Catatan',  
                prefixIcon: Icon(Icons.title, color: Colors.deepOrange),  
                border: OutlineInputBorder(  
                  borderRadius: BorderRadius.circular(10),  
                ),  
                focusedBorder: OutlineInputBorder(  
                  borderRadius: BorderRadius.circular(10),  
                  borderSide: BorderSide(color: Colors.deepOrange, width: 2),  
                ),  
              ),  
              maxLength: 40,
            ),  
            SizedBox(height: 16),  
            TextField(  
              controller: _contentController,  
              maxLines: 4,  
              decoration: InputDecoration(  
                labelText: 'Isi Catatan',  
                prefixIcon: Icon(Icons.notes, color: Colors.deepOrange),  
                border: OutlineInputBorder(  
                  borderRadius: BorderRadius.circular(10),  
                ),  
                focusedBorder: OutlineInputBorder(  
                  borderRadius: BorderRadius.circular(10),  
                  borderSide: BorderSide(color: Colors.deepOrange, width: 2),  
                ),  
              ),  
            ),  
            SizedBox(height: 16),  
            ElevatedButton(  
              onPressed: () {  
                _addNote();  
                Navigator.pop(context);  
              },  
              style: ElevatedButton.styleFrom(  
                backgroundColor: Colors.deepOrange,  
                padding: EdgeInsets.symmetric(vertical: 12),  
                shape: RoundedRectangleBorder(  
                  borderRadius: BorderRadius.circular(10),  
                ),  
              ),  
              child: Text(  
                'Add Note',  
                style: TextStyle(  
                  fontSize: 16,  
                  fontWeight: FontWeight.bold,  
                ),  
              ),  
            ),  
            SizedBox(height: 16),  
          ],  
        ),  
      ),  
    );  
  }  

  Widget _buildAlternativeView(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        centerTitle: true,
        title: Text('Notes(Beta)'),  
        backgroundColor: Colors.deepOrange,  
      ),  
      body: Column(  
        children: [   
 
          if (_errorMessage.isNotEmpty)  
            Padding(  
              padding: const EdgeInsets.all(8.0),  
              child: Text(  
                _errorMessage,  
                style: TextStyle(color: Colors.red),  
              ),  
            ),  

          Expanded(  
            child: RefreshIndicator(  
              onRefresh: _fetchNotes,   
              child: _isLoading  
                  ? Center(child: CircularProgressIndicator())  
                  : _createNotesListView(),  
            ),  
          ),  
        ],  
      ),  
      floatingActionButton: FloatingActionButton(  
        heroTag: 'FABNote',
        onPressed: _showAddNoteBottomSheet,  
        child: Icon(Icons.add),  
        backgroundColor: Colors.deepOrange,  
      ),  
    );  
  }  

  Widget _buildNotesList() {  
    if (_notes.isEmpty) {  
      return ListView(  
        physics: AlwaysScrollableScrollPhysics(),   
        children: [  
          Center(  
            child: Text(  
              'No notes found',  
              style: TextStyle(fontSize: 18, color: Colors.grey),  
            ),  
          ),  
        ],  
      );  
    }  

    return ListView.separated(  
      physics: AlwaysScrollableScrollPhysics(),   
      itemCount: _notes.length,  
      separatorBuilder: (context, index) => Divider(  
        color: Colors.grey.shade300,  
        thickness: 1,  
        indent: 16,  
        endIndent: 16,  
      ),  
      itemBuilder: (context, index) {  
        final note = _notes[index];  
        
        String formattedLastEdited = _formatLastEdited(note.lastEdited);  
        
        return Dismissible(  
          key: Key(note.id),  
          background: Container(color: Colors.red),  
          onDismissed: (direction) {  
            setState(() {  
              _notes.removeAt(index);  
            });  
          },  
          child: ListTile(  
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),  
            title: Text(  
              note.title,   
              style: TextStyle(fontWeight: FontWeight.bold),  
            ),  
            subtitle: Text(  
              note.content,  
              maxLines: 1,  
              overflow: TextOverflow.ellipsis,  
            ),  
            trailing: Column(  
              mainAxisAlignment: MainAxisAlignment.center,  
              crossAxisAlignment: CrossAxisAlignment.end,  
              children: [  
                Text(  
                  formattedLastEdited,  
                  style: TextStyle(  
                    fontSize: 12,  
                    color: Colors.grey.shade600,  
                  ),  
                ),  
              ],  
            ),  
            onTap: () async {  
              final updatedNote = await Navigator.push(  
                context,  
                MaterialPageRoute(  
                  builder: (context) => NoteDetailScreen(note: note),  
                ),  
              );  

              await _fetchNotes();  

              if (updatedNote != null) {  
                print('Updated Note: ${updatedNote.id}, ${updatedNote.title}, ${updatedNote.content}');  

                setState(() {  
                  int index = _notes.indexWhere((n) => n.id == updatedNote.id);  
                  if (index != -1) {  
                    _notes[index] = updatedNote;  
                  }  
                });  
              }  
            },  
          ),  
        );  
      },  
    );  
  }  
 
  String _formatLastEdited(String lastEditedString) {  
    try {  
      DateTime lastEdited = DateTime.parse(lastEditedString);  
      DateTime now = DateTime.now();  
      
      Duration difference = now.difference(lastEdited);  
      
      if (difference.inMinutes < 1) {  
        return 'baru saja';  
      } else if (difference.inHours < 1) {  
        return '${difference.inMinutes}m yang lalu';  
      } else if (difference.inDays < 1) {  
        return '${difference.inHours}j yang lalu';  
      } else if (difference.inDays < 7) {  
        return '${difference.inDays}h yang lalu';  
      } else {   
        return DateFormat('dd/MM/yy').format(lastEdited);  
      }  
    } catch (e) {  
      return 'Unknown';  
    }  
  }
}