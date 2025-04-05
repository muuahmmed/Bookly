import 'package:flutter/material.dart';
import 'book_details_view_body.dart';

class BookDetailView extends StatelessWidget {
  const BookDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BookDetailsViewBody(),
    );
  }
}
