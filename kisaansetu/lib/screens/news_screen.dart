import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/news_api_service.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsApiService _newsApiService = NewsApiService();
  List<NewsArticle> _newsArticles = [];
  bool _isLoading = true;
  String _selectedCategory = "All";

  // categories
  final List<String> categories = [
    "All",
    "Crops",
    "Farming Tech",
    "Weather",
    "Organic Farming",
    "Market Trends",
  ];

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  void _fetchNews() async {
    setState(() => _isLoading = true);

    try {
      final news = await _newsApiService.fetchFilteredNews(_selectedCategory);
      setState(() {
        _newsArticles = news;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching news: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agriculture News")),
      body: Column(
        children: [
          // Category Selection
          Container(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children:
                  categories.map((category) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                          _fetchNews();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _selectedCategory == category
                                  ? Colors.green
                                  : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color:
                                _selectedCategory == category
                                    ? Colors.white
                                    : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          // News List
          Expanded(
            child:
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      itemCount: _newsArticles.length,
                      itemBuilder: (context, index) {
                        final article = _newsArticles[index];
                        return Card(
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            leading:
                                article.imageUrl != null
                                    ? Image.network(
                                      article.imageUrl!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                    : Icon(Icons.image_not_supported),
                            title: Text(article.title, maxLines: 2),
                            subtitle: Text(
                              article.description ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          DetailedNewsScreen(article: article),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}