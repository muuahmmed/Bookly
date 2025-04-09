import 'package:dartz/dartz.dart';
import 'package:bookly/core/errors/failure.dart';
import 'package:bookly/features/home/domain_layer/entities/book_entity.dart';
import '../../domain_layer/repos/home_repo.dart';
import '../data_sources/home_local_data_source.dart';
import '../data_sources/home_remote_data_source.dart';

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
      final booksList = homeLocalDataSource.fetchFeaturedBooks();
      if (booksList.isNotEmpty) {
        return right(booksList);
      }

      final remoteBooks = await homeRemoteDataSource.fetchFeaturedBooks();
      return right(remoteBooks);
    } on NetworkException catch (e) {
      return left(NetworkException('Network error: ${e.message}'));
    } on CacheException catch (e) {
      return left(CacheException('Cache error: ${e.message}'));
    } on ServiceException catch (e) {
      return left(ServiceException('Service error: ${e.message}'));
    } catch (e) {
      return left(ServiceException('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> fetchNewestBooks() async {
    try {
      final booksList = homeLocalDataSource.fetchNewestBooks();
      if (booksList.isNotEmpty) {
        return right(booksList);
      }

      final remoteBooks = await homeRemoteDataSource.fetchNewestBooks();
      return right(remoteBooks);
    } on NetworkException catch (e) {
      return left(NetworkException('Network error: ${e.message}'));
    } on CacheException catch (e) {
      return left(CacheException('Cache error: ${e.message}'));
    } on ServiceException catch (e) {
      return left(ServiceException('Service error: ${e.message}'));
    } catch (e) {
      return left(ServiceException('Unexpected error: $e'));
    }
  }
}
