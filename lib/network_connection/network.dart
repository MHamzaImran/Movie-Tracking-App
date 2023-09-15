import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  String baseUrl = "https://api.themoviedb.org";
  String apiKey = "08cc6a5bbf0076031232b4be9a30268c";
  String accessToken =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwOGNjNmE1YmJmMDA3NjAzMTIzMmI0YmU5YTMwMjY4YyIsInN1YiI6IjY0ZmNhMGVlZGI0ZWQ2MTAzMmE1OWI4MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.HBi7nKLDLmxjxUkZVpvg4X7gTtypFknwlm5s43GhDkM";

  Future<dynamic> get(String endpoint, {Map<String, String>? params}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    if (params != null && params.isNotEmpty) {
      // Add query parameters to the URI
      uri.replace(queryParameters: params);
      print(uri);
    }
    try {
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  
  // return image url
  String getImageUrl(String path, String backdrop) {
    return "$baseUrl/$path/$backdrop";
  }
}
