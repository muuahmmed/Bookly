import '../../../domain_layer/entities/book_entity.dart';

abstract class FeaturedStates {}

class FeaturedInitial extends FeaturedStates {}

class FeaturedLoading extends FeaturedStates {}

class FeaturedSuccess extends FeaturedStates {
  final List<BookEntity> books;

  FeaturedSuccess(this.books);
}

class FeaturedError extends FeaturedStates {
  final String error;

  FeaturedError(this.error);
}
