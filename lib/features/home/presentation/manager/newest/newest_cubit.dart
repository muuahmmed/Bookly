import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain_layer/use_cases/fetch_newest_books_use_cse.dart';
import 'newest_states.dart';

class NewestCubit extends Cubit<NewestStates> {
  final FetchNewestBooksUseCase _fetchNewestBooksUseCase;

  NewestCubit(this._fetchNewestBooksUseCase) : super(NewestInitial());

  Future<void> fetchNewestBooks() async {
    emit(NewestLoading());

    try {
      final result = await _fetchNewestBooksUseCase();

      result.fold(
        (failure) {
          emit(NewestError(failure.message));
        },
        (books) {
          emit(NewestSuccess(books));
        },
      );
    } catch (e) {
      emit(NewestError('Unexpected error occurred: $e'));
    }
  }
}
