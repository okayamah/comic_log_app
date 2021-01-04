import 'package:comic_log_app/model/books_model.dart';
import 'package:comic_log_app/repository/base_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class BooksRepository extends BaseRepository {
  @override
  String get databaseName => "books_database.db";

  @override
  String get tableName => "books";

  @override
  createDatabase(Database db, int version) => db.execute(
        """
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            deleteFlg INT,
            status INT,
            title TEXT,
            titleKana TEXT,
            seriesTitle TEXT,
            seriesTitleKana TEXT,
            seriesOrderNo REAL,
            author TEXT,
            authorKana TEXT,
            publisherName TEXT,
            isbn TEXT,
            itemCaption TEXT,
            largeImageUrl TEXT,
            salesDate TEXT,
            createDate TEXT,
            modifiedDate TEXT
          )
        """,
      );

  Future<int> insert(BooksModel book) async {
    final db = await database;
    var res = await db.insert(tableName, book.toMap());
    return res;
  }

  Future<List<BooksModel>> getAll() async {
    final db = await database;
    var res = await db.query(tableName, where: 'deleteFlg = ?', whereArgs: [0]);
    List<BooksModel> list =
        res.isNotEmpty ? res.map((c) => BooksModel.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<String>> getAllString() async {
    final db = await database;
    var res = await db.query(tableName, orderBy: "salesDate ASC");
    List<BooksModel> list =
        res.isNotEmpty ? res.map((c) => BooksModel.fromMap(c)).toList() : [];
    
    List<String> books = [];
    for(BooksModel book in list) {
      books.add('id: ${book.id.toString()}, deleteFlg: ${book.deleteFlg}, status: ${book.status}, title: ${book.title}, author: ${book.author}, isbn: ${book.isbn}');
    }
    return books;
  }

  Future<BooksModel> getByISBN(String isbn) async {
    final db = await database;
    var res = await db.query(tableName, where: 'deleteFlg = ? AND isbn = ?', whereArgs: [0, isbn]);
    return res.isNotEmpty && res.length == 1 ? res.map((c) => BooksModel.fromMap(c)).toList()[0] : null;
  }

  Future<int> update(BooksModel location) async {
    final db = await database;
    var res  = await db.update(
      tableName, 
      location.toMap(),
      where: "id = ?",
      whereArgs: [location.id]  
    );
    return res;
  }

  Future<int> delete(String id) async {
    final db = await database;
    var res = db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id]
    );
    return res;
  }

  Future<int> deleteByISBN(String isbn) async {
    final db = await database;
    var res = db.delete(
      tableName,
      where: "isbn = ?",
      whereArgs: [isbn]
    );
    return res;
  }
}
