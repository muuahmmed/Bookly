import 'package:bookly/features/home/domain_layer/entities/book_entity.dart'
    show BookEntity;
import 'package:bookly/features/home/domain_layer/repos/home_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import 'fetch_featured_books_use_case.dart';

class FetchNewestBooksUseCase extends UseCase<List<BookEntity>, NoParam> {
  final HomeRepo homeRepo;

  FetchNewestBooksUseCase(this.homeRepo);
  @override
  Future<Either<Failure, List<BookEntity>>> call([NoParam? params]) async {
    return await homeRepo.fetchNewestBooks();
  }
}

class NoParam {}
