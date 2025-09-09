class Notes {
  late int noteId;
  late double contentSize;
  late String noteDate;
  late String noteTime;
  late String noteTitle;
  late String noteContent;
  late String contentType;
  late int contentIndex;
  late String noteImageUrl;
  late int noteColor;
  late int userUid;
  late String createdBy;
  late String fontStyle;
  late String fontWeight;
  late String? noteRecord;
  Notes(
      {required this.noteId,
      required this.noteTitle,
      required this.noteContent,
      required this.noteImageUrl,
      required this.contentIndex,
      required this.contentType,
      required this.noteColor,
      required this.createdBy,
      required this.userUid,
      required this.contentSize,
      required this.noteDate,
      required this.noteTime,
      required this.fontStyle,
      required this.fontWeight,
      this.noteRecord});
  Notes.fromJson(Map<String, Object?> json)
      : noteId = json['noteId'] as int,
        noteTitle = json['noteTitle'] as String,
        noteContent = json['noteContent'] as String,
        contentType = json['contentType'] as String,
        contentIndex = json['contentIndex'] as int,
        noteImageUrl = json['noteImageUrl'] as String,
        noteColor = json['noteColor'] as int,
        contentSize = json['contentSize'] as double,
        noteTime = json['noteTime'] as String,
        noteDate = json['noteDate'] as String,
        fontStyle = json['fontStyle'] as String,
        fontWeight = json['fontWeight'] as String,
        noteRecord = json['noteRecord'] as String?;
}
