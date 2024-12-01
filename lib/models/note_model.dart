class Note {  
  String id;  
  String title;  
  String content;  
  String createdAt;  
  String lastEdited;  

  Note({  
    required this.id,  
    required this.title,  
    required this.content,  
    required this.createdAt,  
    required this.lastEdited,  
  });  

  factory Note.fromJson(Map<String, dynamic> json) {  
    return Note(  
      id: json['id'],  
      title: json['title'],  
      content: json['content'],  
      createdAt: json['createdAt'],  
      lastEdited: json['lastEdited'],
    );  
  }  

  Map<String, dynamic> toJson() {  
    return {  
      'id': id,  
      'title': title,  
      'content': content,  
      'createdAt': createdAt,  
      'lastEdited': lastEdited,  
    };  
  }  
}