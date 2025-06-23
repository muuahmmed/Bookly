
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled5/constants.dart';
import 'package:untitled5/core/utils/styles.dart';
import 'package:untitled5/features/home/domain_layer/entities/book_entity.dart';
import 'package:untitled5/features/home/presentation/manager/featured/featured_cubit.dart';
import 'package:untitled5/features/home/presentation/manager/featured/featured_states.dart';
import 'package:untitled5/features/home/presentation/manager/newest/newest_cubit.dart';
import 'package:untitled5/features/home/presentation/manager/newest/newest_states.dart';
import 'package:untitled5/features/search/presentation/views/search_view.dart';
import 'package:shimmer/shimmer.dart';
import 'book_details_view.dart';

class HomeViewModel extends StatefulWidget {
  const HomeViewModel({super.key});

  @override
  State<HomeViewModel> createState() => _HomeViewModelState();
}

class _HomeViewModelState extends State<HomeViewModel> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 100 && !_showAppBarTitle) {
      setState(() => _showAppBarTitle = true);
    } else if (_scrollController.offset <= 100 && _showAppBarTitle) {
      setState(() => _showAppBarTitle = false);
    }
  }

  Future<void> _loadData() async {
    await context.read<FeaturedCubit>().fetchFeaturedBooks();
    await context.read<NewestCubit>().fetchNewestBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: RefreshIndicator(
        color: Colors.deepOrangeAccent,
        backgroundColor: kPrimaryColor,
        onRefresh: _loadData,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: kPrimaryColor,
              floating: true,
              elevation: 0,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 24, bottom: 16),
                    child: Text(
                      'Bookly',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              actions: const [_SearchButton()],
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            const SliverToBoxAdapter(child: _FeaturedBooksSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            const SliverToBoxAdapter(child: _BestSellerTitle()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            const _BestSellerListSection(),
          ],
        ),
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search, color: Colors.white, size: 28),
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => const SearchView(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      tooltip: 'Search Books',
    );
  }
}

class _FeaturedBooksSection extends StatelessWidget {
  const _FeaturedBooksSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeaturedCubit, FeaturedStates>(
      builder: (context, state) {
        if (state is FeaturedLoading) {
          return const _FeaturedBooksLoading();
        } else if (state is FeaturedError) {
          return _FeaturedBooksError(error: state.error);
        } else if (state is FeaturedSuccess) {
          return _FeaturedBooksList(books: state.books);
        }
        return const _FeaturedBooksLoading();
      },
    );
  }
}

class _FeaturedBooksLoading extends StatelessWidget {
  const _FeaturedBooksLoading();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: _BookCoverPlaceholder(),
          );
        },
      ),
    );
  }
}

class _FeaturedBooksError extends StatelessWidget {
  final String error;

  const _FeaturedBooksError({required this.error});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.redAccent.withOpacity(0.8),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Couldn\'t Load Featured Books',
              style: Styles.titleMedium.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getUserFriendlyError(error),
              style: Styles.titleMedium.copyWith(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed:
                  () => context.read<FeaturedCubit>().fetchFeaturedBooks(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                elevation: 2,
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getUserFriendlyError(String error) {
    if (error.contains('NetworkException')) {
      return 'Please check your internet connection and try again.';
    } else if (error.contains('CacheException')) {
      return 'There was an issue loading saved books.';
    }
    return 'Something went wrong. Please try again later.';
  }
}

class _FeaturedBooksList extends StatelessWidget {
  final List<BookEntity> books;

  const _FeaturedBooksList({required this.books});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _BookCover(book: books[index]),
      ),
    );
  }
}

class _BookCover extends StatelessWidget {
  final BookEntity book;

  const _BookCover({required this.book});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'featured_${book.bookId}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (_, __, ___) => BookDetailView(book: book),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          },
          child: AspectRatio(
            aspectRatio: 2.7 / 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
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
                      child: Icon(
                        Icons.book,
                        color: Colors.grey[600],
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BookCoverPlaceholder extends StatelessWidget {
  const _BookCoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.7 / 4,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.grey[700]!,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }
}

class _BestSellerTitle extends StatelessWidget {
  const _BestSellerTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Text(
            'Best Seller',
            style: Styles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const Spacer(),
          Text(
            'See All',
            style: Styles.titleMedium.copyWith(
              color: Colors.orangeAccent,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _BestSellerListSection extends StatelessWidget {
  const _BestSellerListSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewestCubit, NewestStates>(
      builder: (context, state) {
        if (state is NewestLoading) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: _BestSellerItemPlaceholder(),
              ),
              childCount: 5,
            ),
          );
        } else if (state is NewestError) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.redAccent.withOpacity(0.8),
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text('Error loading books', style: Styles.titleMedium),
                  Text(
                    state.error,
                    style: Styles.titleMedium.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => context.read<NewestCubit>().fetchNewestBooks(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        } else if (state is NewestSuccess) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                child: _BestSellerItem(book: state.books[index]),
              ),
              childCount: state.books.length,
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: _BestSellerItemPlaceholder(),
            ),
            childCount: 5,
          ),
        );
      },
    );
  }
}

class _BestSellerItem extends StatelessWidget {
  final BookEntity book;

  const _BestSellerItem({required this.book});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'bestseller_${book.bookId}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (_, __, ___) => BookDetailView(book: book),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BookCoverSmall(book: book),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: Styles.titleMedium.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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
                          '\$${book.price?.toStringAsFixed(2) ?? '0.00'}',
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
                        const SizedBox(width: 4),
                        Text(
                          '(${book.reviews ?? 0})',
                          style: Styles.titleMedium.copyWith(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
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
}

class _BestSellerItemPlaceholder extends StatelessWidget {
  const _BestSellerItemPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.grey[800],
                ),
                const SizedBox(height: 8),
                Container(width: 100, height: 16, color: Colors.grey[800]),
                const SizedBox(height: 16),
                Container(width: 60, height: 16, color: Colors.grey[800]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookCoverSmall extends StatelessWidget {
  final BookEntity book;

  const _BookCoverSmall({required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          book.image ?? '',
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => Container(
            color: Colors.grey[800],
            child: Center(child: Icon(Icons.book, color: Colors.grey[600])),
          ),
        ),
      ),
    );
  }
}