class NoteModel {
  int? noteId;
  String? noteTitle;
  String? noteContent;
  String? noteImage;
  int? noteUser;

  NoteModel(
      {this.noteId,
        this.noteTitle,
        this.noteContent,
        this.noteImage,
        this.noteUser});

  NoteModel.fromJson(Map<String, dynamic> json) {
    noteId = json['note_id'];
    noteTitle = json['note_title'];
    noteContent = json['note_content'];
    noteImage = json['note_image'];
    noteUser = json['note_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['note_id'] = this.noteId;
    data['note_title'] = this.noteTitle;
    data['note_content'] = this.noteContent;
    data['note_image'] = this.noteImage;
    data['note_user'] = this.noteUser;
    return data;
  }
}