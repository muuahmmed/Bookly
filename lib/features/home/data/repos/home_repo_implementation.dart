import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:untitled5/core/errors/failure.dart';
import 'package:untitled5/features/home/domain_layer/entities/book_entity.dart';
import '../../../../core/utils/api_services.dart';
import '../../domain_layer/models/book_model/item.dart';
import '../../domain_layer/repos/home_repo.dart';
import '../data_sources/home_local_data_source.dart';
import '../data_sources/home_remote_data_source.dart'; // Add this import

class HomeRepoImpl extends HomeRepo {
  final HomeRemoteDataSource homeRemoteDataSource;
  final HomeLocalDataSource homeLocalDataSource;
  final ApiServices apiServices;

  HomeRepoImpl({
    required this.homeRemoteDataSource,
    required this.homeLocalDataSource,
    required this.apiServices,
  });

  BookEntity _convertItemToEntity(Item item) {
    return BookEntity(
      image: item.volumeInfo?.imageLinks?.thumbnail,
      title: item.volumeInfo?.title ?? 'No Title',
      author: item.volumeInfo?.authors?.join(', ') ?? 'Unknown',
      rate: item.volumeInfo?.averageRating?.toDouble() ?? 0.0,
      price: item.saleInfo?.listPrice?.amount?.toDouble() ?? 0.0,
      reviews: item.volumeInfo?.ratingsCount ?? 0,
      bookId: item.id ?? '',
      previewUrl: item.accessInfo?.webReaderLink,
    );
  }

  @override
  Future<Either<Failure, List<BookEntity>>> fetchFeaturedBooks() async {
    try {
      final localBooks = homeLocalDataSource.fetchFeaturedBooks();
      if (localBooks.isNotEmpty) {
        return right(localBooks);
      }

      final remoteBooks = await homeRemoteDataSource.fetchFeaturedBooks();
      await homeLocalDataSource.cacheFeaturedBooks(remoteBooks);
      return right(remoteBooks);
    } on DioException catch (e) {
      return left(NetworkException('Network error: ${e.message}'));
    } on HiveError catch (e) {
      return left(CacheException('Cache error: ${e.message}'));
    } catch (e) {
      return left(ServiceException('Failed to fetch featured books: $e'));
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> fetchNewestBooks() async {
    try {
      final localBooks = homeLocalDataSource.fetchNewestBooks();
      if (localBooks.isNotEmpty) {
        return right(localBooks);
      }

      final remoteBooks = await homeRemoteDataSource.fetchNewestBooks();
      return right(remoteBooks);
    } on DioException catch (e) {
      return left(NetworkException('Network error: ${e.message}'));
    } on HiveError catch (e) {
      return left(CacheException('Cache error: ${e.message}'));
    } catch (e) {
      return left(ServiceException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> searchBooks(String query) async {
    try {
      final data = await apiServices.get(
        endPoint: 'volumes?q=$query&maxResults=40',
      );

      final books = (data['items'] as List)
          .map((json) => _convertItemToEntity(Item.fromJson(json)))
          .toList();

      return Right(books);
    } on DioException catch (e) {
      return Left(NetworkException('Search failed: ${e.message}'));
    }
  }
}
