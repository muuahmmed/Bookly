import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain_layer/use_cases/fetch_featured_books_use_case.dart';
import 'featured_states.dart';

class FeaturedCubit extends Cubit<FeaturedStates> {
  final FetchFeaturedBooksUseCase fetchFeaturedBooksUseCase;

  FeaturedCubit(this.fetchFeaturedBooksUseCase) : super(FeaturedInitial());

  Future<void> fetchFeaturedBooks() async {
    emit(FeaturedLoading());

    final result = await fetchFeaturedBooksUseCase();
    result.fold(
      (failure) {
        print('Error fetching books: ${failure.message}');
        emit(FeaturedError(failure.message));
      },
      (books) {
        print('Successfully fetched ${books.length} books');
        emit(FeaturedSuccess(books));
      },
    );
  }
}