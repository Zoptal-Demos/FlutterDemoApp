// To parse this JSON data, do
//
//     final bookingListModel = bookingListModelFromJson(jsonString);

import 'dart:convert';

BookingListModel bookingListModelFromJson(String str) => BookingListModel.fromJson(json.decode(str));

String bookingListModelToJson(BookingListModel data) => json.encode(data.toJson());

class BookingListModel {
  bool status;
  int code;
  String message;
  List<BookingList>? bookingList;

  BookingListModel({
    required this.status,
    required this.code,
    required this.message,
     this.bookingList,
  });

  factory BookingListModel.fromJson(Map<String, dynamic> json)  {
    if(json["status"] == true){
      return BookingListModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        bookingList: List<BookingList>.from(json["data"].map((x) => BookingList.fromJson(x))),
      );
    }else{
      return BookingListModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
      );
    }
  }

  Map<String, dynamic> toJson()  {
    if(status){
      return {
        "status": status,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(bookingList!.map((x) => x.toJson())),
      };
    }else{
      return {
        "status": status,
        "code": code,
        "message": message,
      };
    }
  }
}

class BookingList {
  String id;
  String modelId;
  String title;
  String desc;
  dynamic onDate;
  String month;
  dynamic startDate;
  DateTime createdAt;
  DateTime updatedAt;


  BookingList({
    required this.id,
    required this.modelId,
    required this.title,
    required this.desc,
    required this.onDate,
    required this.month,
    required this.startDate,
    required this.createdAt,
    required this.updatedAt,

  });

  factory BookingList.fromJson(Map<String, dynamic> json) => BookingList(
    id: json["_id"],
    modelId: json["modelId"],
    title: json["title"],
    desc: json["desc"],
    onDate: json["onDate"],
    month: json["month"],
    startDate: json["startDate"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),

  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "modelId": modelId,
    "title": title,
    "desc": desc,
    "onDate": onDate,
    "month": month,
    "startDate": startDate,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),

  };
}
