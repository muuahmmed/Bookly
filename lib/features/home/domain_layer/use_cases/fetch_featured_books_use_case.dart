import 'package:untitled5/features/home/domain_layer/entities/book_entity.dart'
    show BookEntity;
import 'package:untitled5/features/home/domain_layer/repos/home_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class FetchFeaturedBooksUseCase extends UseCase<List<BookEntity>, NoParam> {
  final HomeRepo homeRepo;

  FetchFeaturedBooksUseCase(this.homeRepo);
  @override
  Future<Either<Failure, List<BookEntity>>> call([NoParam? params]) async {
    return await homeRepo.fetchFeaturedBooks();
  }
}

class NoParam {}
