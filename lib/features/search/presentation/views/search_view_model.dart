import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/styles.dart';
import '../../../home/presentation/views/widgets/book_details_view.dart';

class SearchViewBody extends StatefulWidget {
  const SearchViewBody({super.key});

  @override
  State<SearchViewBody> createState() => _SearchViewBodyState();
}

class _SearchViewBodyState extends State<SearchViewBody> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final List<String> _searchHistory = [];
  bool _isSearching = false;
  List<String> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus && _searchController.text.isEmpty) {
        setState(() => _isSearching = false);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _searchResults.clear();
    });
    _searchFocusNode.unfocus();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      _clearSearch();
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = List.generate(5, (index) => "Result $index for '$query'");
      if (!_searchHistory.contains(query)) {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 5) {
          _searchHistory.removeLast();
        }
      }
    });
  }

  void _onHistoryItemTap(String query) {
    _searchController.text = query;
    _performSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isSearching
                    ? _buildSearchResults()
                    : _searchHistory.isNotEmpty
                    ? _buildSearchHistory()
                    : const Center(
                  child: Text(
                    'Start typing to search...',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CupertinoSearchTextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        placeholder: 'Search...',
        placeholderStyle: const TextStyle(color: Colors.white54),
        style: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(Icons.search, color: Colors.white70),
        suffixIcon: const Icon(Icons.close, color: Colors.white70),
        backgroundColor: Colors.transparent,
        onSubmitted: _performSearch,
        onSuffixTap: _clearSearch,
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Text('No results found', style: TextStyle(color: Colors.white)),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: BestSellerViewItem(),
        );
      },
    );
  }

  Widget _buildSearchHistory() {
    return ListView.separated(
      itemCount: _searchHistory.length,
      separatorBuilder: (_, __) => const Divider(color: Colors.white24),
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.history, color: Colors.white54),
          title: Text(_searchHistory[index], style: const TextStyle(color: Colors.white)),
          onTap: () => _onHistoryItemTap(_searchHistory[index]),
        );
      },
    );
  }
}

class BestSellerViewItem extends StatelessWidget {
  const BestSellerViewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateTo(context, const BookDetailView());
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AssetsData.logo,
            width: 100,
            height: 125,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 16),
          // Wrap remaining content with Expanded to prevent overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book Title',
                  style: Styles.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  'Author Name',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('price \$', style: Styles.titleMedium),
                    const Spacer(),
                    const Icon(Icons.star, color: Colors.yellow, size: 18),
                    const SizedBox(width: 4),
                    Text('4.5', style: TextStyle(color: Colors.white)),
                    const SizedBox(width: 4),
                    Text('(123)', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
