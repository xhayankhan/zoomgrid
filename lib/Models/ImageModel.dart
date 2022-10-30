// To parse this JSON data, do
//
//     final imageModel = imageModelFromJson(jsonString);

import 'dart:convert';

ImageModel imageModelFromJson(String str) => ImageModel.fromJson(json.decode(str));

String imageModelToJson(ImageModel data) => json.encode(data.toJson());

class ImageModel {
  ImageModel({
    this.the0,
  });

  dynamic the0;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
    the0: json["0"],
  );

  Map<String, dynamic> toJson() => {
    "0": the0,
  };
}
