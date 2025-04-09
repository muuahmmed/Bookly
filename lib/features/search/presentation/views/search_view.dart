import 'package:flutter/material.dart';
import 'package:bookly/features/search/presentation/views/search_view_model.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SearchViewBody());
  }
}
