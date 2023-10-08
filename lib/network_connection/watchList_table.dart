import 'package:cloud_firestore/cloud_firestore.dart';

class WatchListTable{

  addMovieItemToWatchList(String userId, MovieItem movieItem) async {
    final collectionRef = FirebaseFirestore.instance.collection('watchList').doc(userId);
    final newItem = {
      'movieId': movieItem.movieId,
      'movieTitle': movieItem.movieTitle,
      'mediaType': movieItem.mediaType,
      'posterPath': movieItem.posterPath,
    };

    final querySnapshot = await collectionRef.collection('items').where('movieId', isEqualTo: movieItem.movieId).get();

    if (querySnapshot.docs.isNotEmpty) {
      // Movie with the same ID already exists in the watchlist
      return 'Already in watchlist';
    } else {
      // Movie does not exist in the watchlist, add it
      await collectionRef.collection('items').add(newItem);
      return 'Added to watchlist';
    }
  }
  
  Future<List<MovieItem>> getMovieItemsFromWatchList(String userId) async {
    final collectionRef = FirebaseFirestore.instance.collection('watchList').doc(userId);

    final querySnapshot = await collectionRef.collection('items').get();

    final items = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return MovieItem(data['movieId'], data['movieTitle'],data['mediaType'], data['posterPath']);
    }).toList();

    return items;
  }

  Future<String> deleteMovieItemFromWatchList(String userId, int movieId) async {
    final collectionRef = FirebaseFirestore.instance.collection('watchList').doc(userId);

    final querySnapshot = await collectionRef.collection('items').where('movieId', isEqualTo: movieId).get();

    if (querySnapshot.docs.isNotEmpty) {
      // Movie with the specified ID exists in the watchlist, delete it
      final docId = querySnapshot.docs.first.id;
      await collectionRef.collection('items').doc(docId).delete();
      return 'Movie removed from watchlist';
    } else {
      // Movie with the specified ID is not found in the watchlist
      return 'Movie not found in watchlist';
    }
  }

  Future<String> deleteAllItemsFromWatchList(String userId) async {
    final collectionRef = FirebaseFirestore.instance.collection('watchList').doc(userId);

    final querySnapshot = await collectionRef.collection('items').get();

    if (querySnapshot.docs.isNotEmpty) {
      // Delete all movie items from the watchlist
      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return 'All movies removed from watchlist';
    } else {
      // No movie items found in the watchlist
      return 'Watchlist is already empty';
    }
  }
  
}

class MovieItem {
  final int movieId;
  final String movieTitle;
  final String mediaType;
  final String posterPath;

  MovieItem(this.movieId,this.movieTitle, this.mediaType, this.posterPath, );
}
