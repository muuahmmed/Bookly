import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain_layer/use_cases/fetch_featured_books_use_case.dart';
import 'featured_states.dart';

class FeaturedCubit extends Cubit<FeaturedStates> {
  final FetchFeaturedBooksUseCase _fetchFeaturedBooksUseCase;

  FeaturedCubit(this._fetchFeaturedBooksUseCase) : super(FeaturedInitial());

  Future<void> fetchFeaturedBooks() async {
    emit(FeaturedLoading());

    try {
      final result = await _fetchFeaturedBooksUseCase();

      result.fold(
        (failure) {
          emit(FeaturedError(failure.message));
        },
        (books) {
          emit(FeaturedSuccess(books));
        },
      );
    } catch (e) {
      emit(FeaturedError('Unexpected error occurred: $e'));
    }
  }
}
