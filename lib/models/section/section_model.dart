class SectionModel {
  final String id;
  final String webTitle;
  final String webUrl;
  final String apiUrl;

  SectionModel({
    required this.id,
    required this.webTitle,
    required this.webUrl,
    required this.apiUrl,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) => SectionModel(
        id: json["id"],
        webTitle: json["webTitle"],
        webUrl: json["webUrl"],
        apiUrl: json["apiUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "webTitle": webTitle,
        "webUrl": webUrl,
        "apiUrl": apiUrl,
      };
}
