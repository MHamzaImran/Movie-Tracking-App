import 'package:cloud_firestore/cloud_firestore.dart';

class WatchListTable{

  Future<void> addMovieItemToWatchList(String userId, MovieItem movieItem) async {
    final collectionRef = FirebaseFirestore.instance.collection('watchList').doc(userId);

    final newItem = {
      'movieId': movieItem.movieId,
      'mediaType': movieItem.mediaType,
      'posterPath': movieItem.posterPath,
    };

    await collectionRef.collection('items').add(newItem);
  }

  Future<List<MovieItem>> getMovieItemsFromWatchList(String userId) async {
    final collectionRef = FirebaseFirestore.instance.collection('watchList').doc(userId);

    final querySnapshot = await collectionRef.collection('items').get();

    final items = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return MovieItem(data['movieId'], data['mediaType'], data['posterPath']);
    }).toList();

    return items;
  }



}

class MovieItem {
  final int movieId;
  final String mediaType;
  final String posterPath;

  MovieItem(this.movieId, this.mediaType, this.posterPath);
}
