import 'package:flutter/material.dart';
import 'package:comic_log_app/enum/book_status.dart';

// booksテーブルモデルクラス
class BooksModel {
  int id; // 主キー
  bool deleteFlg; // 削除フラグ
  BookStatus status;
  String title;
  String titleKana;
  String seriesTitle;
  String seriesTitleKana;
  double seriesOrderNo;
  String author;
  String authorKana;
  String publisherName;
  String isbn;
  String itemCaption;
  String largeImageUrl;
  DateTime salesDate;
  DateTime createDate;
  DateTime modifiedDate;

  // コンストラクタ
  BooksModel({
    this.id,
    @required this.deleteFlg,
    @required this.status,
    this.title,
    this.titleKana,
    this.seriesTitle,
    this.seriesTitleKana,
    this.seriesOrderNo,
    this.author,
    this.authorKana,
    this.publisherName,
    this.isbn,
    this.itemCaption,
    this.largeImageUrl,
    this.salesDate,
    @required this.createDate,
    @required this.modifiedDate,
  });

  BooksModel.newLocationModel() {
    deleteFlg = false;
    status = BookStatus.NotSet;
    createDate = DateTime.now();
    modifiedDate = DateTime.now();
  }

  factory BooksModel.fromMap(Map<String, dynamic> json) => BooksModel(
        id: json["id"],
        deleteFlg: json["deleteFlg"] == 1 ? true : false,
        status: BookStatus.values[json["status"]],
        title: json["title"],
        titleKana: json["titleKana"],
        seriesTitle: json["seriesTitle"],
        seriesTitleKana: json["seriesTitleKana"],
        seriesOrderNo: json["seriesOrderNo"],
        author: json["author"],
        authorKana: json["authorKana"],
        publisherName: json["publisherName"],
        isbn: json["isbn"],
        itemCaption: json["itemCaption"],
        largeImageUrl: json["largeImageUrl"],
        salesDate: DateTime.parse(json["salesDate"]).toLocal(),
        createDate: DateTime.parse(json["createDate"]).toLocal(),
        modifiedDate: DateTime.parse(json["modifiedDate"]).toLocal(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "deleteFlg": deleteFlg == true ? 1 : 0,
        "status": status.index,
        "title": title,
        "titleKana": titleKana,
        "seriesTitle": seriesTitle,
        "seriesTitleKana": seriesTitleKana,
        "seriesOrderNo": seriesOrderNo,
        "author": author,
        "authorKana": authorKana,
        "publisherName": publisherName,
        "isbn": isbn,
        "itemCaption": itemCaption,
        "largeImageUrl": largeImageUrl,
        // sqliteではDate型は直接保存できないため、文字列形式で保存する
        "salesDate": createDate.toUtc().toIso8601String(),
        "createDate": createDate.toUtc().toIso8601String(),
        "modifiedDate": createDate.toUtc().toIso8601String(),
      };
}
