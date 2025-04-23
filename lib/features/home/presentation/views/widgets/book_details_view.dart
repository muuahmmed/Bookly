import 'package:flutter/material.dart';
import 'package:bookly/core/utils/styles.dart';
import 'package:bookly/features/home/domain_layer/entities/book_entity.dart';
import '../../../../../constants.dart';
import 'book_preview.dart';

class BookDetailView extends StatelessWidget {
  final BookEntity book;

  const BookDetailView({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: kPrimaryColor,
              pinned: true,
              expandedHeight: 50,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        kPrimaryColor.withOpacity(0.8),
                        kPrimaryColor.withOpacity(0.2),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _BookCoverLarge(book: book),
                    const SizedBox(height: 24),
                    _BookDetails(book: book),
                    const SizedBox(height: 24),
                    _ActionButtons(book: book),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookCoverLarge extends StatelessWidget {
  final BookEntity book;

  const _BookCoverLarge({required this.book});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            book.image ?? '',
            fit: BoxFit.cover,
            errorBuilder:
                (_, __, ___) => Container(
                  color: Colors.grey[800],
                  child: Center(
                    child: Icon(Icons.book, color: Colors.grey[600], size: 60),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}

class _BookDetails extends StatelessWidget {
  final BookEntity book;

  const _BookDetails({required this.book});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          book.title,
          style: Styles.titleMedium.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          book.author ?? 'Unknown Author',
          style: Styles.titleMedium.copyWith(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 28),
            const SizedBox(width: 8),
            Text(
              book.rate?.toStringAsFixed(1) ?? '0.0',
              style: Styles.titleMedium.copyWith(fontSize: 18),
            ),
            const SizedBox(width: 16),
            Text(
              '(${book.reviews ?? 0} reviews)',
              style: Styles.titleMedium.copyWith(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
          style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.6),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final BookEntity book;

  const _ActionButtons({required this.book});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () {
                // Handle purchase action
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text(
                    '19.99€',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () => _openBookPreview(context, book),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.orangeAccent, Colors.deepOrangeAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text(
                    'Free Preview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openBookPreview(BuildContext context, BookEntity book) {
    // You'll need to implement this based on how you want to show the preview
    // Here are two common approaches:

    // 1. Open a web view with the book preview URL
    //
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => WebViewScreen(
    //       url: book.previewUrl ?? 'https://books.google.com/books?id=${book.id}&pg=PA1',
    //       title: 'Preview: ${book.title}',
    //     ),
    //   ),
    // );

    // 2. Open a custom preview screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookPreviewScreen(book: book)),
    );
  }
}
