import 'package:hive/hive.dart';
import '../../domain_layer/entities/book_entity.dart';

abstract class HomeLocalDataSource {
  List<BookEntity> fetchFeaturedBooks();
  List<BookEntity> fetchNewestBooks();
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
}
