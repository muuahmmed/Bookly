import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled5/core/utils/styles.dart';
import 'package:untitled5/features/home/domain_layer/entities/book_entity.dart';
import '../../../../constants.dart';
import '../../../../core/utils/api_services.dart';
import '../../../home/data/data_sources/home_local_data_source.dart';
import '../../../home/data/data_sources/home_remote_data_source.dart';
import '../../../home/data/repos/home_repo_implementation.dart';
import '../../../home/presentation/views/widgets/book_reader_view.dart';
import '../../data/fetch_data.dart';
import '../../manager/search_cubit.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => SearchCubit(
            FetchSearchResultsUseCase(
              HomeRepoImpl(
                homeRemoteDataSource: HomeRemoteDataSourceImpl(
                  apiServices: ApiServices(Dio()),
                ),
                homeLocalDataSource: HomeLocalDataSourceImpl(),
                apiServices: ApiServices(Dio()),
              ),
            ),
          ),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: _buildAppBar(context),
        body: const _SearchBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Search Books', style: TextStyle(color: Colors.white)),
    );
  }
}

class _SearchBody extends StatefulWidget {
  const _SearchBody();

  @override
  State<_SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<_SearchBody> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final List<String> _searchHistory = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_searchFocusNode.hasFocus && _searchController.text.isEmpty) {
      setState(() {});
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        context.read<SearchCubit>().fetchSearchResults(query);
        _addToSearchHistory(query);
      }
    });
  }

  void _addToSearchHistory(String query) {
    if (!_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 5) {
          _searchHistory.removeLast();
        }
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<SearchCubit>().clearResults();
    _searchFocusNode.unfocus();
  }

  void _onHistoryItemTap(String query) {
    _searchController.text = query;
    _searchFocusNode.requestFocus();
    context.read<SearchCubit>().fetchSearchResults(query);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 20),
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        hintText: 'Search by title, author, or ISBN...',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        prefixIcon: const Icon(Icons.search, color: Colors.white70),
        suffixIcon:
            _searchController.text.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white70),
                  onPressed: _clearSearch,
                )
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onChanged: _onSearchChanged,
      onSubmitted: (query) {
        if (query.isNotEmpty) {
          context.read<SearchCubit>().fetchSearchResults(query);
          _addToSearchHistory(query);
        }
      },
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<SearchCubit, SearchStates>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return _buildSearchHistory();
        } else if (state is SearchLoading) {
          return _buildLoadingIndicator();
        } else if (state is SearchError) {
          return _buildErrorState(state.message);
        } else if (state is SearchSuccess) {
          return state.books.isEmpty
              ? _buildEmptyResults()
              : _buildBooksList(state.books);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildSearchHistory() {
    if (_searchHistory.isEmpty) return _buildInitialState();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Recent Searches',
            style: Styles.titleMedium.copyWith(color: Colors.white70),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: _searchHistory.length,
            separatorBuilder: (_, __) => const Divider(color: Colors.white24),
            itemBuilder:
                (context, index) => ListTile(
                  leading: const Icon(Icons.history, color: Colors.white54),
                  title: Text(
                    _searchHistory[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.white54,
                    ),
                    onPressed:
                        () => setState(() => _searchHistory.removeAt(index)),
                  ),
                  onTap: () => _onHistoryItemTap(_searchHistory[index]),
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            color: Colors.white.withOpacity(0.3),
            size: 80,
          ),
          const SizedBox(height: 16),
          Text(
            'Search for books',
            style: Styles.titleMedium.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            'Find your next favorite book',
            style: Styles.titleMedium.copyWith(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.orangeAccent),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.redAccent.withOpacity(0.8),
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'Search failed',
            style: Styles.titleMedium.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Styles.titleMedium.copyWith(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed:
                () => context.read<SearchCubit>().fetchSearchResults(
                  _searchController.text,
                ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrangeAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            color: Colors.white.withOpacity(0.5),
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: Styles.titleMedium.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords',
            style: Styles.titleMedium.copyWith(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBooksList(List<BookEntity> books) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return _BookSearchItem(
          book: book,
          onTap: () => _navigateToBookReader(context, book),
        );
      },
    );
  }

  void _navigateToBookReader(BuildContext context, BookEntity book) {
    if (book.previewUrl == null || book.previewUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No preview available for this book'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookReaderView(book: book)),
    );
  }
}

class _BookSearchItem extends StatelessWidget {
  final BookEntity book;
  final VoidCallback onTap;

  const _BookSearchItem({required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBookCover(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: Styles.titleMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author ?? 'Unknown Author',
                      style: Styles.titleMedium.copyWith(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          book.price == null || book.price == 0
                              ? 'Free'
                              : '\$${book.price!.toStringAsFixed(2)}',
                          style: Styles.titleMedium.copyWith(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          book.rate?.toStringAsFixed(1) ?? '0.0',
                          style: Styles.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookCover() {
    return Hero(
      tag: 'search_cover_${book.bookId}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          book.image ?? '',
          width: 80,
          height: 120,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) => Container(
                width: 80,
                height: 120,
                color: Colors.grey[800],
                child: Center(
                  child: Icon(Icons.book, color: Colors.grey[600], size: 40),
                ),
              ),
        ),
      ),
    );
  }
}
