class ArticlesModel{
  final int userId;
  final int id;
  final String title;
  final String body;

  ArticlesModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory ArticlesModel.fromJson(Map<String,dynamic> json){
    return ArticlesModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }
}