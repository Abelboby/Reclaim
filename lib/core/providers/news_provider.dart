import 'package:flutter/foundation.dart';
import '../models/news_article.dart';
import '../services/news_service.dart';

class NewsProvider extends ChangeNotifier {
  List<NewsArticle> _articles = [];
  bool _isLoading = false;
  String _error = '';

  List<NewsArticle> get articles => _articles;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchHealthNews() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      _articles = await NewsService.getHealthNews();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
} 