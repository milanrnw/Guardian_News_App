import 'package:mynewsapp/models/section/section_model.dart';

class SectionMainModel {
  final List<SectionModel> results;

  SectionMainModel({
    required this.results,
  });

  factory SectionMainModel.fromJson(Map<String, dynamic> json) =>
      SectionMainModel(
        results: List<SectionModel>.from(
            json["results"].map((x) => SectionModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
