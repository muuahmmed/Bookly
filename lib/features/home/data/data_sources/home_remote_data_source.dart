import 'package:hive/hive.dart';
import 'package:bookly/features/home/domain_layer/entities/book_entity.dart';
import '../../../../core/utils/api_services.dart';
import '../../domain_layer/models/book_model/item.dart';

abstract class HomeRemoteDataSource {
  Future<List<BookEntity>> fetchFeaturedBooks();
  Future<List<BookEntity>> fetchNewestBooks();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiServices apiServices;

  HomeRemoteDataSourceImpl({required this.apiServices});

  BookEntity _convertItemToEntity(Item item) {
    String? thumbnail;
    if (item.volumeInfo?.imageLinks != null) {
      thumbnail = item.volumeInfo?.imageLinks?.thumbnail ??
          item.volumeInfo?.imageLinks?.smallThumbnail;
    }

    return BookEntity(
      image: thumbnail,
      title: item.volumeInfo?.title ?? 'No Title',
      author: item.volumeInfo?.authors?.join(', ') ?? 'Unknown',
      rate: item.volumeInfo?.averageRating?.toDouble() ?? 0.0,
      price: item.saleInfo?.listPrice?.amount?.toDouble() ?? 0.0,
      reviews: item.volumeInfo?.ratingsCount ?? 0,
      bookId: item.id ?? '',
    );
  }

  @override
  Future<List<BookEntity>> fetchFeaturedBooks() async {
    try {
      final data = await apiServices.get(
        endPoint: 'volumes?Filter=free-ebooks&q=programming',
      );

      if (data['items'] == null) {
        throw Exception('No items found in response');
      }

      final items = (data['items'] as List).map((json) {
        try {
          return Item.fromJson(json);
        } catch (e) {
          throw Exception('Failed to parse item: $e');
        }
      }).toList();

      final books = items.map(_convertItemToEntity).toList();
      await saveData(books, 'featured_box');
      return books;
    } catch (e) {
      throw Exception('Failed to fetch featured books: $e');
    }
  }

  @override
  Future<List<BookEntity>> fetchNewestBooks() async {
    try {
      final data = await apiServices.get(
        endPoint: 'volumes?Filter=free-ebooks&Sorting=newest&q=programming',
      );

      return (data['items'] as List)
          .map((json) => _convertItemToEntity(Item.fromJson(json)))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch newest books: $e');
    }
  }

  Future<void> saveData(List<BookEntity> books, String boxName) async {
    final box = await Hive.openBox<BookEntity>(boxName);
    await box.clear();
    await box.addAll(books);
  }
}
