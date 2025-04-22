import 'package:bookly/features/home/domain_layer/entities/book_entity.dart';
import 'package:flutter/material.dart';
import 'book_details_view_body.dart';

class BookDetailView extends StatelessWidget {
  const BookDetailView({super.key, required BookEntity book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ), // Padding only from right & left
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close_outlined),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                onPressed: () {
                  // Handle search action
                },
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
            ],
          ),
        ),
      ),
      body: const BookDetailsViewBody(),
    );
  }
}
