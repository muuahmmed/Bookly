import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/featured/featured_cubit.dart';
import '../../manager/newest/newest_cubit.dart';
import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<FeaturedCubit>().fetchFeaturedBooks();
          await context.read<NewestCubit>().fetchNewestBooks();
        },
        child: const HomeViewModel(),
      ),
    );
  }
}

//import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bookly/constants.dart';
// import 'package:bookly/core/utils/styles.dart';
// import 'package:bookly/features/home/domain_layer/entities/book_entity.dart';
// import 'package:bookly/features/home/presentation/manager/featured/featured_cubit.dart';
// import 'package:bookly/features/home/presentation/manager/featured/featured_states.dart';
// import 'package:bookly/features/home/presentation/manager/newest/newest_cubit.dart';
// import 'package:bookly/features/home/presentation/manager/newest/newest_states.dart';
// import 'package:bookly/features/search/presentation/views/search_view.dart';
//
// import 'book_details_view.dart';
//
// class HomeView extends StatelessWidget {
//   const HomeView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kPrimaryColor,
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: () async {
//             await context.read<FeaturedCubit>().fetchFeaturedBooks();
//             await context.read<NewestCubit>().fetchNewestBooks();
//           },
//           child: CustomScrollView(
//             physics: const BouncingScrollPhysics(),
//             slivers: [
//               SliverAppBar(
//                 backgroundColor: kPrimaryColor,
//                 floating: true,
//                 pinned: true,
//                 elevation: 0,
//                 title: const _AppBarTitle(),
//                 actions: const [_SearchButton()],
//                 expandedHeight: 100,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           kPrimaryColor.withOpacity(0.8),
//                           kPrimaryColor.withOpacity(0.2),
//                         ],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SliverToBoxAdapter(child: SizedBox(height: 16)),
//               const SliverToBoxAdapter(child: _FeaturedBooksSection()),
//               const SliverToBoxAdapter(child: SizedBox(height: 24)),
//               const SliverToBoxAdapter(child: _BestSellerTitle()),
//               const SliverToBoxAdapter(child: SizedBox(height: 16)),
//               const _BestSellerListSection(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _AppBarTitle extends StatelessWidget {
//   const _AppBarTitle();
//
//   @override
//   Widget build(BuildContext context) {
//     return RichText(
//       text: const TextSpan(
//         children: [
//           TextSpan(
//             text: 'Book',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 1.2,
//             ),
//           ),
//           TextSpan(
//             text: 'ly',
//             style: TextStyle(
//               color: Colors.orangeAccent,
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 1.2,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _SearchButton extends StatelessWidget {
//   const _SearchButton();
//
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: Container(
//         padding: const EdgeInsets.all(6),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.1),
//           shape: BoxShape.circle,
//           border: Border.all(color: Colors.white.withOpacity(0.3)),
//         ),
//         child: const Icon(Icons.search, color: Colors.white, size: 22),
//       ),
//       onPressed: () => Navigator.push(
//         context,
//         PageRouteBuilder(
//           pageBuilder: (_, __, ___) => const SearchView(),
//           transitionsBuilder: (_, a, __, c) =>
//               FadeTransition(opacity: a, child: c),
//         ),
//       ),
//     );
//   }
// }
//
// class _FeaturedBooksSection extends StatelessWidget {
//   const _FeaturedBooksSection();
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FeaturedCubit, FeaturedStates>(
//       builder: (context, state) {
//         if (state is FeaturedLoading) {
//           return const _FeaturedBooksLoading();
//         } else if (state is FeaturedError) {
//           return _FeaturedBooksError(error: state.error);
//         } else if (state is FeaturedSuccess) {
//           return _FeaturedBooksList(books: state.books);
//         }
//         return const SizedBox.shrink();
//       },
//     );
//   }
// }
//
// class _FeaturedBooksLoading extends StatelessWidget {
//   const _FeaturedBooksLoading();
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.3,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemCount: 5,
//         itemBuilder: (context, index) => const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 8.0),
//           child: _BookCoverPlaceholder(),
//         ),
//       ),
//     );
//   }
// }
//
// class _FeaturedBooksError extends StatelessWidget {
//   final String error;
//
//   const _FeaturedBooksError({required this.error});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.error_outline_rounded,
//               color: Colors.redAccent,
//               size: 64,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Couldn\'t Load Featured Books',
//               style: Styles.titleMedium.copyWith(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               _getUserFriendlyError(error),
//               style: Styles.titleMedium.copyWith(
//                 fontSize: 14,
//                 color: Colors.white70,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () => context.read<FeaturedCubit>().fetchFeaturedBooks(),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepOrangeAccent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 12,
//                 ),
//                 elevation: 2,
//               ),
//               child: const Text(
//                 'Try Again',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _getUserFriendlyError(String error) {
//     if (error.contains('NetworkException')) {
//       return 'Please check your internet connection and try again.';
//     } else if (error.contains('CacheException')) {
//       return 'There was an issue loading saved books.';
//     } else if (error.contains('type')) {
//       return 'Data format error. Please try again later.';
//     }
//     return 'Something went wrong. Please try again later.';
//   }
// }
//
// class _FeaturedBooksList extends StatelessWidget {
//   final List<BookEntity> books;
//
//   const _FeaturedBooksList({required this.books});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.32,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: books.length,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         separatorBuilder: (_, __) => const SizedBox(width: 12),
//         itemBuilder: (context, index) => _BookCover(book: books[index]),
//       ),
//     );
//   }
// }
//
// class _BookCover extends StatelessWidget {
//   final BookEntity book;
//
//   const _BookCover({required this.book});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _navigateToBookDetails(context, book),
//       child: AspectRatio(
//         aspectRatio: 2.7 / 4,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.3),
//                 blurRadius: 10,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: Stack(
//               children: [
//                 Image.network(
//                   book.image ?? '',
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => Container(
//                     color: Colors.grey[800],
//                     child: Center(
//                       child: Icon(
//                         Icons.book,
//                         color: Colors.grey[600],
//                         size: 40,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.transparent,
//                         Colors.black.withOpacity(0.7),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           book.title,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         if (book.author != null)
//                           Text(
//                             book.author!,
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.8),
//                               fontSize: 12,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _navigateToBookDetails(BuildContext context, BookEntity book) {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (_, __, ___) => BookDetailView(book: book),
//         transitionsBuilder: (_, a, __, c) =>
//             FadeTransition(opacity: a, child: c),
//       ),
//     );
//   }
// }
//
// class _BookCoverPlaceholder extends StatelessWidget {
//   const _BookCoverPlaceholder();
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 2.7 / 4,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           color: Colors.grey[800],
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 6,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Center(
//           child: Icon(
//             Icons.book,
//             color: Colors.grey[600],
//             size: 40,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _BestSellerTitle extends StatelessWidget {
//   const _BestSellerTitle();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'Best Seller',
//             style: Styles.titleMedium.copyWith(
//               fontWeight: FontWeight.bold,
//               fontSize: 22,
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//
//             },
//             child: Text(
//               'See All',
//               style: Styles.titleMedium.copyWith(
//                 color: Colors.orangeAccent,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _BestSellerListSection extends StatelessWidget {
//   const _BestSellerListSection();
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<NewestCubit, NewestStates>(
//       builder: (context, state) {
//         if (state is NewestLoading) {
//           return SliverList(
//             delegate: SliverChildBuilderDelegate(
//                   (_, __) => const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 12.0),
//                 child: _BestSellerItemPlaceholder(),
//               ),
//               childCount: 5,
//             ),
//           );
//         } else if (state is NewestError) {
//           return SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   const Icon(Icons.error_outline, color: Colors.red, size: 48),
//                   const SizedBox(height: 8),
//                   Text('Error loading books', style: Styles.titleMedium),
//                   Text(
//                     state.error,
//                     style: Styles.titleMedium.copyWith(color: Colors.grey),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () =>
//                         context.read<NewestCubit>().fetchNewestBooks(),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.deepOrangeAccent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         } else if (state is NewestSuccess) {
//           return SliverList(
//             delegate: SliverChildBuilderDelegate(
//                   (context, index) => Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24.0,
//                   vertical: 12.0,
//                 ),
//                 child: _BestSellerItem(book: state.books[index]),
//               ),
//               childCount: state.books.length,
//             ),
//           );
//         }
//         return const SliverToBoxAdapter(child: SizedBox.shrink());
//       },
//     );
//   }
// }
//
// class _BestSellerItemPlaceholder extends StatelessWidget {
//   const _BestSellerItemPlaceholder();
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 80,
//           height: 120,
//           decoration: BoxDecoration(
//             color: Colors.grey[800],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Center(
//             child: Icon(
//               Icons.book,
//               color: Colors.grey[600],
//             ),
//           ),
//         ),
//         const SizedBox(width: 20),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: 20,
//                 width: double.infinity,
//                 color: Colors.grey[800],
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 height: 16,
//                 width: 120,
//                 color: Colors.grey[800],
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Container(
//                     height: 16,
//                     width: 60,
//                     color: Colors.grey[800],
//                   ),
//                   const Spacer(),
//                   Container(
//                     height: 16,
//                     width: 30,
//                     color: Colors.grey[800],
//                   ),
//                   const SizedBox(width: 4),
//                   Container(
//                     height: 16,
//                     width: 40,
//                     color: Colors.grey[800],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _BestSellerItem extends StatelessWidget {
//   final BookEntity book;
//
//   const _BestSellerItem({required this.book});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _navigateToBookDetails(context, book),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.white.withOpacity(0.05),
//         ),
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _BookCoverSmall(book: book),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     book.title,
//                     style: Styles.titleMedium.copyWith(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     book.author ?? 'Unknown Author',
//                     style: Styles.titleMedium.copyWith(
//                       color: Colors.white70,
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Text(
//                         '\$${book.price?.toStringAsFixed(2) ?? '0.00'}',
//                         style: Styles.titleMedium.copyWith(
//                           color: Colors.orangeAccent,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Spacer(),
//                       const Icon(
//                         Icons.star_rounded,
//                         color: Colors.amber,
//                         size: 18,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         book.rate?.toStringAsFixed(1) ?? '0.0',
//                         style: Styles.titleMedium,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         '(${book.reviews ?? 0})',
//                         style: Styles.titleMedium.copyWith(
//                           color: Colors.grey,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _navigateToBookDetails(BuildContext context, BookEntity book) {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (_, __, ___) => BookDetailView(book: book),
//         transitionsBuilder: (_, a, __, c) =>
//             FadeTransition(opacity: a, child: c),
//       ),
//     );
//   }
// }
//
// class _BookCoverSmall extends StatelessWidget {
//   final BookEntity book;
//
//   const _BookCoverSmall({required this.book});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 80,
//       height: 120,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: Stack(
//           children: [
//             Image.network(
//               book.image ?? '',
//               fit: BoxFit.cover,
//               width: double.infinity,
//               height: double.infinity,
//               errorBuilder: (_, __, ___) => Container(
//                 color: Colors.grey[800],
//                 child: Center(
//                   child: Icon(
//                     Icons.book,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     Colors.black.withOpacity(0.7),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }