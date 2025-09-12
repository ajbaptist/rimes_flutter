import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> articleData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String title = articleData['title'] ?? "No Title";
    final String body = articleData['body'] ?? "No Content";

    return Scaffold(
      appBar: AppBar(title: const Text("Article Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(body, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
