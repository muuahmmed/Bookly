import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookly/constants.dart';
import 'package:bookly/core/utils/assets.dart';
import 'package:bookly/core/utils/styles.dart';
import 'package:bookly/features/home/domain_layer/entities/book_entity.dart';
import 'package:bookly/features/home/presentation/manager/featured/featured_cubit.dart';
import 'package:bookly/features/home/presentation/manager/featured/featured_states.dart';
import 'package:bookly/features/home/presentation/manager/newest/newest_cubit.dart';
import 'package:bookly/features/home/presentation/manager/newest/newest_states.dart';
import 'package:bookly/features/search/presentation/views/search_view.dart';
import 'book_details_view.dart';

class HomeViewModel extends StatefulWidget {
  const HomeViewModel({super.key});

  @override
  State<HomeViewModel> createState() => _HomeViewModelState();
}

class _HomeViewModelState extends State<HomeViewModel> {
  @override
  void initState() {
    super.initState();
    // Fetch data when widget initializes
    context.read<FeaturedCubit>().fetchFeaturedBooks();
    context.read<NewestCubit>().fetchNewestBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<FeaturedCubit>().fetchFeaturedBooks();
          await context.read<NewestCubit>().fetchNewestBooks();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: kPrimaryColor,
              floating: true,
              title: const _AppBarTitle(),
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

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Bookly',
      style: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
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
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchView()),
      ),
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
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: _BookCoverPlaceholder(),
        ),
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
            const Icon(
              Icons.error_outline,
              color: Colors.redAccent,
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
              onPressed: () => context.read<FeaturedCubit>().fetchFeaturedBooks(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
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
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _BookCover(book: books[index]),
        ),
      ),
    );
  }
}

class _BookCover extends StatelessWidget {
  final BookEntity book;

  const _BookCover({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToBookDetails(context, book),
      child: AspectRatio(
        aspectRatio: 2.7 / 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: book.image != null
                  ? NetworkImage(book.image!)
                  : const AssetImage(AssetsData.logo) as ImageProvider,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToBookDetails(BuildContext context, BookEntity book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailView(book: book),
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[800],
        ),
        child: const Center(
          child: Icon(Icons.book, color: Colors.grey, size: 40),
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
      child: Text('Best Seller', style: Styles.titleMedium),
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
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is NewestError) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 8),
                  Text('Error loading books', style: Styles.titleMedium),
                  Text(state.error, style: Styles.titleMedium),
                  TextButton(
                    onPressed: () => context.read<NewestCubit>().fetchNewestBooks(),
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
        return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
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
    return GestureDetector(
      onTap: () => _navigateToBookDetails(context, book),
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
                  style: Styles.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  book.author ?? 'Unknown Author',
                  style: Styles.titleMedium.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '\$${book.price?.toStringAsFixed(2) ?? '0.00'}',
                      style: Styles.titleMedium,
                    ),
                    const Spacer(),
                    const Icon(Icons.star, color: Colors.yellow, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      book.rate?.toStringAsFixed(1) ?? '0.0',
                      style: Styles.titleMedium,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${book.reviews ?? 0})',
                      style: Styles.titleMedium.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToBookDetails(BuildContext context, BookEntity book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailView(book: book),
      ),
    );
  }
}

class _BookCoverSmall extends StatelessWidget {
  final BookEntity book;

  const _BookCoverSmall({required this.book});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 120,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          book.image ?? '',
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[800],
            child: const Center(
              child: Icon(Icons.book, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}