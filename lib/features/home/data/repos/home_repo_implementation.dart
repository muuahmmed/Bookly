import 'package:dartz/dartz.dart';
import 'package:bookly/core/errors/failure.dart';
import 'package:bookly/features/home/domain_layer/entities/book_entity.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../../domain_layer/repos/home_repo.dart';
import '../data_sources/home_local_data_source.dart';
import '../data_sources/home_remote_data_source.dart';
import 'home_repo_implementation.dart' as homeRemoteDataSource;

class HomeRepoImpl extends HomeRepo {
  final HomeRemoteDataSource homeRemoteDataSource;
  final HomeLocalDataSource homeLocalDataSource;

  HomeRepoImpl({
    required this.homeRemoteDataSource,
    required this.homeLocalDataSource,
  });

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
}

  // @override
  // Future<Either<Failure, List<BookEntity>>> fetchSimilarBooks({
  //   required String category,
  // }) async {
  //   try {
  //     final remoteBooks = await homeRemoteDataSource.fetchSimilarBooks(
  //       category: category,
  //     );
  //     return right(remoteBooks as List<BookEntity>);
  //   } on DioException catch (e) {
  //     return left(NetworkException('Network error: ${e.message}'));
  //   } on HiveError catch (e) {
  //     return left(CacheException('Cache error: ${e.message}'));
  //   } catch (e) {
  //     return left(ServiceException('Unexpected error: $e'));
  //   }
  // }