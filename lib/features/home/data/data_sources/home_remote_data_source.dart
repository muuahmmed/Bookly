import 'package:hive/hive.dart';
import 'package:bookly/features/home/domain_layer/entities/book_entity.dart';
import '../../../../core/utils/api_services.dart';
import '../models/book_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<BookEntity>> fetchFeaturedBooks();
  Future<List<BookEntity>> fetchNewestBooks();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiServices apiServices;

  HomeRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<List<BookEntity>> fetchFeaturedBooks() async {
    var data = await apiServices.getFeaturedBooks(
      endPoint: 'volumes?Filter=free-ebooks&q=programming',
    );
    List<BookEntity> books = [];
    for (var bookMap in data['items']) {
      books.add(BookModel.fromJson(bookMap));
    }
    saveData(books, 'featured_box');
    return books;
  }

  void saveData(List<BookEntity> books, String boxName) {
    var box = Hive.box('featured_box');
    box.addAll(books);
  }

  @override
  Future<List<BookEntity>> fetchNewestBooks() async {
    var data = await apiServices.getFeaturedBooks(
      endPoint: 'volumes?Filter=free-ebooks&Sorting=newest&q=programming',
    );
    List<BookEntity> books = [];
    for (var bookMap in data['items']) {
      books.add(BookModel.fromJson(bookMap));
    }
    return books;
  }
}
