// search_model.dart
import 'dart:convert' as convert;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:comic_log_app/enum/book_status.dart';
import 'package:comic_log_app/model/books_model.dart';
import 'package:comic_log_app/repository/books_repository.dart';
import 'package:comic_log_app/model/card_model.dart';

class BookSearchService extends ChangeNotifier {
  String text = ''; // TextFieldの値を受け取ります

  List<BooksModel> searchResultList = []; // 検索結果が渡されます

  // booksテーブルリポジトリの初期化.
  BooksRepository _booksRepository = new BooksRepository();

  // 検索の中身
  Future<void> searchByTitle() async {
    requestRakutenBooksAPI(this.text);
  }

  // 検索の中身
  Future<void> searchInRakuten() async {
    await requestRakutenNewIssueAPI();
  }

  Future<void> requestGoogleBooksAPI(title) async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url =
        'https://www.googleapis.com/books/v1/volumes?q=${title}&maxResults=40&startIndex=0';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var itemCount = jsonResponse['totalItems'];
      var itemList = jsonResponse['items'];
      print('Number of books about http: $itemCount.');

      itemList.forEach((element) {
        var volumeInfo = element['volumeInfo'];
        if (volumeInfo['title'].toString().contains(title) &&
            volumeInfo['imageLinks'] != null) {
          BooksModel card = new BooksModel(
              createDate: DateTime.now(),
              deleteFlg: false,
              modifiedDate: DateTime.now(),
              status: BookStatus.NotSet);
          card.title = volumeInfo['title'];
          card.author = volumeInfo['authors'].toString();
          card.itemCaption = volumeInfo['description'];
          card.salesDate = volumeInfo['publishedDate'];

          // サムネイル
          var url = volumeInfo['imageLinks']['thumbnail'].toString();
          if (url.contains('http:')) {
            url = url.replaceAll('http:', 'https:');
          }
          card.largeImageUrl = url;
          searchResultList.add(card);
        }
      });
      notifyListeners(); // これを実行すると再描画される
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> requestRakutenBooksAPI(title) async {
    // This example uses the Rakuten Books API to search for books about http.
    // https://webservice.rakuten.co.jp/api/booksbooksearch
    var url =
        'https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?applicationId=1013299307452449948&title=${title}&hits=30&page=1&outOfStockFlag=1&size=9&sort=%2BreleaseDate';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var itemCount = jsonResponse['count'];
      var itemList = jsonResponse['Items'];
      print('Number of books about http: $itemCount.');

      if (itemList != null) {
        itemList.forEach((element) async {
          var item = element['Item'];
          if (item['title'].toString().contains(title) &&
              item['largeImageUrl'] != null) {
            BooksModel card = new BooksModel(
                createDate: DateTime.now(),
                deleteFlg: false,
                modifiedDate: DateTime.now(),
                status: BookStatus.NotSet);
            card.title = item['title'];
            card.author = item['author'];
            card.isbn = item['isbn'];
            card.itemCaption = "";
            card.salesDate = _splitSaleDate(item['salesDate']);

            // サムネイル
            var url = item['largeImageUrl'];
            if (url.contains('http:')) {
              url = url.replaceAll('http:', 'https:');
            }
            card.largeImageUrl = url;

            // ステータス
            var _book = await _booksRepository.getByISBN(item['isbn']);
            card.status = _book != null ? _book.status : BookStatus.NotSet;

            searchResultList.add(card);
            // searchResultList.sort((a,b) => a.isbn.compareTo(b.isbn));
            notifyListeners(); // これを実行すると再描画される
          }
        });
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> requestRakutenNewIssueAPI() async {
    // リストをクリア
    searchResultList.clear();

    final now = DateTime.now();
    String year = now.year.toString();
    String month = now.month.toString().padLeft(2, "0");

    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url =
        'https://books.rakuten.co.jp/event/book/comic/calendar/${year}/${month}/js/booklist.json';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      String responseBody = convert.utf8.decode(response.bodyBytes);
      var jsonResponse = convert.jsonDecode(responseBody);
      var itemList = jsonResponse['list'];

      itemList = itemList.sublist(0, 30); // とりあえず30件で切る

      itemList.forEach((element) {
        print('Request success with status: ${element.toString()}.');
        BooksModel card = new BooksModel(
            createDate: DateTime.now(),
            deleteFlg: false,
            modifiedDate: DateTime.now(),
            status: BookStatus.NotSet);
        card.title = element[5];
        card.author = element[7];
        // card.thumbnail = volumeInfo['imageLinks']['thumbnail'];
        // card.description = volumeInfo['description'];
        card.salesDate =
            _splitSaleDateOnlyDay(now.year, now.month, element[20]);
        card.publisherName = element[10];
        card.isbn = element[3].toString();
        searchResultList.add(card);
      });
      notifyListeners(); // これを実行すると再描画される
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<BookCard> requestOpenDB(String isbn) async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url = 'https://api.openbd.jp/v1/get?isbn=${isbn}';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      BookCard card = new BookCard();
      var jsonResponse = convert.jsonDecode(response.body)[0];
      var summary = jsonResponse['summary'];
      var onix = jsonResponse['onix'];

      card.isbn = summary['isbn'];
      card.title = summary['title'];
      card.publishedDate = summary['pubdate'];
      card.authors = summary['author'];
      card.thumbnail = summary['cover'];

      // サムネイル
      var url = summary['cover'].toString();
      if (url.contains('http:')) {
        url = url.replaceAll('http:', 'https:');
      }
      card.thumbnail = url;

      var descList = onix['CollateralDetail']['TextContent'];
      descList.forEach((element) {
        if (card.description == null ||
            element['Text'] > card.description.length) {
          card.description = element['Text'];
        }
      });
      return Future<BookCard>.value(card);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  DateTime _splitSaleDate(String saleDate) {
    try {
      var list = saleDate.split(new RegExp(r"年|月|日"));
      int year = int.tryParse(list[0]);
      int month = int.tryParse(list[1]);
      int day = int.tryParse(list[2]);
      if (day != null) {
        return DateTime(year, month, day);
      } else {
        return DateTime(year, month);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  DateTime _splitSaleDateOnlyDay(int year, int month, String saleDate) {
    try {
      var list = saleDate.split(new RegExp(r"月|日"));
      int day = int.tryParse(list[1]);
      if (day != null) {
        return DateTime(year, month, day);
      } else {
        return DateTime(year, month);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void insertBook(int index) {
    if (searchResultList.elementAt(index) != null && searchResultList.elementAt(index).status == BookStatus.NotSet) {
      if (_booksRepository != null) {
        try {
          // DB登録
          searchResultList.elementAt(index).status = BookStatus.NotPurchased;
          _booksRepository.insert(searchResultList.elementAt(index));
        } catch (e) {
          print("Error: insert books. [Title: ${searchResultList.elementAt(index).title}]");
        }
      }
    }
  }
}
