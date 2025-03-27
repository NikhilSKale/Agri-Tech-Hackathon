import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsApiService {
  static const String apiKey = "5a81b673171f4a339728a27500a2dc53"; // Replace with your actual API key
  static const String baseUrl = "https://newsapi.org/v2/everything";

  // Fetch filtered news based on the selected category
  Future<List<NewsArticle>> fetchFilteredNews(String selectedCategory) async {
    // Define category-specific search terms
    final Map<String, String> categoryKeywords = {
      "All": "agriculture OR farming OR crops OR agritech OR pesticides OR irrigation",
      "Crops": "crops OR plantation OR harvest OR yield OR farming",
      "Farming Tech": "agritech OR precision farming OR smart agriculture OR AI in farming",
      "Weather": "agriculture weather OR monsoon OR drought OR rainfall OR climate change",
      "Organic Farming": "organic farming OR natural farming OR sustainable agriculture",
      "Market Trends": "agriculture market OR crop prices OR MSP OR agri business",
    };

    // Get keywords based on selected category
    final String query = categoryKeywords[selectedCategory] ?? categoryKeywords["All"]!;

    final String url =
        "$baseUrl?q=$query&language=en&sortBy=publishedAt&apiKey=$apiKey";

    print("Fetching news for category: $selectedCategory from URL: $url"); // Debugging

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('articles')) {
        final List articles = data['articles'];
        return articles.map((json) => NewsArticle.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load news: ${response.statusCode}');
    }
  }
}