import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/news_article.dart';

class NewsService {
  static const String _baseUrl = 'https://api.currentsapi.services/v1';
  static const String _apiKey = 'c_--PikMtvpyTIz8wb7_uRuX7-w2PWMLu7NpUYpvmeyYLCZH';

  // static const List<String> _healthKeywords = [
  //   'drug addiction health',
  //   'addiction treatment',
  //   'rehabilitation medicine',
  //   'substance abuse health',
  //   'recovery health',
  //   'mental health addiction',
  //   'addiction medicine',
  //   'drug treatment health',
  //   'rehabilitation therapy',
  //   'addiction recovery health'
  // ];

  static Future<List<NewsArticle>> getHealthNews() async {
    try {
      //final keywordString = _healthKeywords.join(' OR ');
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/search?&category=health&language=en&apiKey=$_apiKey'
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = (data['news'] as List)
            .map((article) => NewsArticle.fromJson(article))
            .toList();
        return articles;
      } else {
        throw Exception('Failed to load health news');
      }
    } catch (e) {
      throw Exception('Error fetching health news: $e');
    }
  }
} 