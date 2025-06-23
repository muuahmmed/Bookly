import 'package:dartz/dartz.dart';
import 'package:untitled5/core/errors/failure.dart';
import 'package:untitled5/features/home/domain_layer/entities/book_entity.dart';
import 'package:untitled5/features/home/domain_layer/repos/home_repo.dart';


class FetchSearchResultsUseCase {
  final HomeRepo homeRepo;

  FetchSearchResultsUseCase(this.homeRepo);

  Future<Either<Failure, List<BookEntity>>> call(String query) async {
    return await homeRepo.searchBooks(query);
  }
}
