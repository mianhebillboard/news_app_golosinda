// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math'; // Import for Random selection
import 'package:badges/badges.dart' as badges;
import 'package:news_app/globals.dart';
import 'package:news_app/photo_card.dart';
import 'package:news_app/pull_to_refesh.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark, // Dark mode theme
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
        splashFactory: NoSplash.splashFactory,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List news = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=tesla&from=2025-01-21&sortBy=publishedAt&apiKey=c97f69fc2b5d4820a900c8590071311f'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        news = data['articles'] ?? []; // Ensure it's always a list
      });

      debugPrint(news.toString());
    } else {
      debugPrint('Failed to load news: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    var randomPost =
        news.isNotEmpty ? news[Random().nextInt(news.length)] : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        toolbarHeight: 65,
        title: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Image.network(
                  'https://www.dropbox.com/scl/fi/4euteo8exev1ubtm02gl2/newstoday-primary-logo.png?rlkey=7rj3z86rqxy8ebuitn4wk16um&st=4drsoazb&dl=1',
                  height: 50,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: badges.Badge(
                  badgeContent: const Text(
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.red,
                  ),
                  child: const Icon(Icons.notifications, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      body: PullToRefresh(
        onRefresh: fetchNews,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: SizedBox(
              width: screenPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: secondaryHeight),

                  // Featured News Card
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                    child: SizedBox(
                      height: 300,
                      width: screenPadding(context),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        child: Stack(
                          children: [
                            // Background Image
                            if (randomPost != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  randomPost['urlToImage'] ??
                                      "https://www.dropbox.com/scl/fi/90g3ny43ia6al3g63cgii/newstoday-secondary-logo.png?rlkey=n6xf7ph8gavo6figh22md48ph&st=f3zr6qsv&dl=1",
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                            // Gradient Overlay
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black87,
                                    Colors.black26,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),

                            // Featured Label
                            const Positioned(
                              top: 20,
                              left: 16,
                              child: Text(
                                'Featured',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // Save icon
                            Positioned(
                              top: 20,
                              right: 16,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12, // Lighter shadow
                                      blurRadius: 3, // Softer blur
                                      spreadRadius: 1, // Minimal spread
                                      offset: Offset(1,
                                          2), // Slightly below and to the right
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.bookmark,
                                  color: Colors.red,
                                  size: 30, // Adjust size as needed
                                ),
                              ),
                            ),

                            // Title & Description
                            Positioned(
                              bottom: 48,
                              left: 16,
                              right: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    randomPost?['title'] ?? 'No Title',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    randomPost?['author'] ?? 'Unknown Author',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[300],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // Source info (Logo and name)
                            Positioned(
                              bottom: 16,
                              left: 16,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        50), // Slightly rounded corners
                                    child: Image.network(
                                      'https://www.google.com/s2/favicons?domain=${randomPost?['source']?['name']?.toLowerCase().replaceAll(' ', '')}.com&sz=32',
                                      width: 20, // Small favicon size
                                      height: 20,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.public,
                                            size: 20,
                                            color:
                                                Colors.grey); // Fallback icon
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                      width: 8), // Space between logo and text
                                  Text(
                                    randomPost?['source']?['name'] ??
                                        'Unknown Source', // Extracts the source name
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70, // Subtle color
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: secondaryHeight),

                  // Related News Section
                  SizedBox(
                    width: screenPadding(context),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [SectionTitle(title: "Related news")],
                    ),
                  ),
                  SizedBox(height: primaryHeight),

                  // Horizontal Scrollable List
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      itemCount: news.length > 5 ? 5 : news.length,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        var post = news[index];
                        return Row(
                          children: [
                            PhotoCard(
                              imageUrl: post['urlToImage'] ??
                                  "https://www.dropbox.com/scl/fi/90g3ny43ia6al3g63cgii/newstoday-secondary-logo.png?rlkey=n6xf7ph8gavo6figh22md48ph&st=f3zr6qsv&dl=1",
                              name: post['title'] ?? '',
                              description: post['author'] ?? 'Unknown Author',
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  SizedBox(height: secondaryHeight),

                  // More News Section
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [SectionTitle(title: "More news")],
                  ),
                  SizedBox(height: primaryHeight),

                  // Vertical News List
                  ListView.builder(
                    itemCount: news.length > 5 ? 5 : news.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var post = news[index];

                      return Card(
                        margin: EdgeInsets.only(bottom: primaryHeight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.blueGrey[900],
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  post['urlToImage'] ??
                                      'https://www.dropbox.com/scl/fi/90g3ny43ia6al3g63cgii/newstoday-secondary-logo.png?rlkey=n6xf7ph8gavo6figh22md48ph&st=hnnlhagz&dl=1',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(post['title'] ?? 'No Title',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    SizedBox(height: smallHeight),
                                    Text(post['author'] ?? 'Unknown Author',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[400]),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
