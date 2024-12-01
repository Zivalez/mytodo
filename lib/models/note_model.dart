class Note {  
  String id;  
  String title;  
  String content;  
  String createdAt;  
  String lastEdited;  
  String type; // Tambahkan field type  

  Note({  
    required this.id,  
    required this.title,  
    required this.content,  
    required this.createdAt,  
    required this.lastEdited,  
    this.type = 'note', // Default value 'note'  
  });  

  factory Note.fromJson(Map<String, dynamic> json) {  
    return Note(  
      id: json['id'],  
      title: json['title'],  
      content: json['content'],  
      createdAt: json['createdAt'],  
      lastEdited: json['lastEdited'],  
      type: json['type'] ?? 'note', // Tambahkan parsing type  
    );  
  }  

  Map<String, dynamic> toJson() {  
    return {  
      'id': id,  
      'title': title,  
      'content': content,  
      'createdAt': createdAt,  
      'lastEdited': lastEdited,  
      'type': type, // Tambahkan type ke JSON  
    };  
  }  
}