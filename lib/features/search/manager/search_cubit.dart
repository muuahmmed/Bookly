import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled5/features/home/domain_layer/entities/book_entity.dart';
import '../../../core/utils/api_services.dart';
import '../../home/data/data_sources/home_local_data_source.dart';
import '../../home/data/data_sources/home_remote_data_source.dart';
import '../../home/data/repos/home_repo_implementation.dart';
import '../data/fetch_data.dart';
part 'search_states.dart';

class SearchCubit extends Cubit<SearchStates> {
  FetchSearchResultsUseCase fetchSearchResultsUseCase;

  SearchCubit(this.fetchSearchResultsUseCase) : super(SearchInitial()) {
    fetchSearchResultsUseCase = FetchSearchResultsUseCase(
      HomeRepoImpl(
        homeRemoteDataSource: HomeRemoteDataSourceImpl(
          apiServices: ApiServices(Dio()),
        ),
        homeLocalDataSource: HomeLocalDataSourceImpl(),
        apiServices: ApiServices(Dio()),
      ),
    );
  }

  Future<void> fetchSearchResults(String query) async {
    emit(SearchLoading());
    final result = await fetchSearchResultsUseCase(query);
    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (books) => emit(SearchSuccess(books)),
    );
  }

  void clearResults() {
    emit(SearchInitial());
  }
}
