// To parse this JSON data, do
//
//     final allSectionModel = allSectionModelFromJson(jsonString);

import 'dart:convert';

import 'package:mynewsapp/models/section/section_main_model.dart';

AllSectionModel allSectionModelFromJson(String str) =>
    AllSectionModel.fromJson(json.decode(str));

String allSectionModelToJson(AllSectionModel data) =>
    json.encode(data.toJson());

class AllSectionModel {
  final SectionMainModel response;

  AllSectionModel({
    required this.response,
  });

  factory AllSectionModel.fromJson(Map<String, dynamic> json) =>
      AllSectionModel(
        response: SectionMainModel.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response.toJson(),
      };
}
