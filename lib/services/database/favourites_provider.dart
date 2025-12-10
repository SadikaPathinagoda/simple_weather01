import 'package:flutter/foundation.dart';
import 'package:simple_weather01/services/database/db_helper.dart';
import 'package:simple_weather01/services/database/record.dart';

class FavouritesProvider extends ChangeNotifier {
  final DbHelper _db = DbHelper.instance;

  List<Record> favourites = [];

  Future<void> loadFavourites() async {
    favourites = await _db.getAllRecords();
    notifyListeners();
  }

  Future<void> addFavourite(Record record) async {
    await _db.insertRecord(record);
    await loadFavourites();
  }

  Future<void> updateFavourite(Record record) async {
    await _db.updateRecord(record);
    await loadFavourites();
  }

  Future<void> deleteFavourite(int id) async {
    await _db.deleteRecord(id);
    await loadFavourites();
  }
}
