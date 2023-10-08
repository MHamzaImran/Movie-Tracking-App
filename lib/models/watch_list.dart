import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network_connection/watchList_table.dart';

class Watchlist extends ChangeNotifier {
  final List<MovieItem> _watchlist = [];

  List<MovieItem> get getWatchlist => _watchlist;

  int get itemCount => _watchlist.length;

  Watchlist() {
    updateListFromApi();
  }

  addToWatchlist(MovieItem item) async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (_watchlist
        .any((watchlistItem) => watchlistItem.movieId == item.movieId)) {
      return 'Already in watchlist';
    }

    _watchlist.add(item);
    WatchListTable().addMovieItemToWatchList(userId!, item);
    notifyListeners();

    return 'Added to watchlist';
  }

  removeFromWatchlist(int movieId) async {
    if (_watchlist
        .any((watchlistItem) => watchlistItem.movieId == movieId))  {
      _watchlist.removeAt(_watchlist.indexWhere((watchlistItem) => watchlistItem.movieId == movieId));
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String result = await WatchListTable()
          .deleteMovieItemFromWatchList(userId!, movieId);
      // toastBlock(result);
      notifyListeners();
    }
  }

  removeAll() async {
    _watchlist.clear();
    notifyListeners();
  }

  updateListFromApi() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    List<MovieItem> temp =
        await WatchListTable().getMovieItemsFromWatchList(userId!);
    _watchlist.clear();
    _watchlist.addAll(temp);
    notifyListeners();
  }
}
