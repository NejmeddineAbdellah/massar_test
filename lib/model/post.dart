class Post {
  int userId;
  int id;
  String title;
  String body;
  //int? wCount;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  Post.fromJson(Map<String, dynamic> json)
      : userId = json["userId"],
        id = json["id"],
        title = json["title"],
        body = json["body"];

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'id': id, 'title': title, 'body': body};
  }

  int getWordCount() {
    List<String> words = body.split(' ');
    return words.length;
  }
}
