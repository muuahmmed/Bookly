import 'package:hive/hive.dart';
part 'book_entity.g.dart';

@HiveType(typeId: 0)
class BookEntity {
  final String bookId;
  @HiveField(0)
  final String? image;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String? author;
  @HiveField(3)
  final num? rate;
  @HiveField(4)
  final num? price;
  @HiveField(5)
  final int? reviews;
  @HiveField(6)
  BookEntity({
    required this.image,
    required this.title,
    required this.author,
    required this.rate,
    required this.price,
    required this.reviews,
    required this.bookId,
  });
}
