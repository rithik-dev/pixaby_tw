class PixabyImage {
  String id;
  String type;
  String tags;
  String previewURL;
  String largeImageURL;
  int views;
  int downloads;
  int likes;
  int comments;

  PixabyImage({
    required this.id,
    required this.type,
    required this.tags,
    required this.previewURL,
    required this.largeImageURL,
    required this.views,
    required this.downloads,
    required this.likes,
    required this.comments,
  });

  static PixabyImage fromJson(Map<String, dynamic> json) {
    return PixabyImage(
      id: json['id'].toString(),
      type: json['type'],
      tags: json['tags'],
      previewURL: json['previewURL'],
      largeImageURL: json['largeImageURL'],
      views: json['views'],
      downloads: json['downloads'],
      likes: json['likes'],
      comments: json['comments'],
    );
  }
}
