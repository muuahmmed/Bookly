import 'package:hive/hive.dart';
import '../../domain_layer/entities/book_entity.dart';

abstract class HomeLocalDataSource {
  List<BookEntity> fetchFeaturedBooks();
  List<BookEntity> fetchNewestBooks();
  Future<void> cacheFeaturedBooks(List<BookEntity> books); // Add this method
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  List<BookEntity> fetchFeaturedBooks() {
    var box = Hive.box<BookEntity>('featured_box');
    return box.values.toList();
  }

  @override
  List<BookEntity> fetchNewestBooks() {
    var box = Hive.box<BookEntity>('newest_box');
    return box.values.toList();
  }

  @override
  Future<void> cacheFeaturedBooks(List<BookEntity> books) async {
    var box = await Hive.openBox<BookEntity>('featured_box'); // Open the box
    // Cache the books in the Hive box
    await box.addAll(books);
  }
}
