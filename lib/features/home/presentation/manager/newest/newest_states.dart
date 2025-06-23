import '../../../domain_layer/entities/book_entity.dart';

abstract class NewestStates {}

class NewestInitial extends NewestStates {}

class NewestLoading extends NewestStates {}

class NewestSuccess extends NewestStates {
  final List<BookEntity> books;

  NewestSuccess(this.books);
}

class NewestError extends NewestStates {
  final String error;

  NewestError(this.error);
}
