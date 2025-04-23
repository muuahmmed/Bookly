import 'package:flutter/material.dart';
import '../../../domain_layer/entities/book_entity.dart';

class BookPreviewScreen extends StatelessWidget {
  final BookEntity book;

  const BookPreviewScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview: ${book.title}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.menu_book, size: 60),
            const SizedBox(height: 20),
            Text(
              'Preview of ${book.title}',
              style: const TextStyle(fontSize: 20),
            ),
            // Here you would implement your actual preview content
            // This could be a PDF viewer, web view, or custom content
          ],
        ),
      ),
    );
  }
}