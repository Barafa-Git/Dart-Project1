enum BookCategory {
  science,
  technology,
  litelature,
  psychology,
  religion,
  language,
}

enum BookStatus { available, booked, ordered }

enum BookType { physique, digital }

class Book {
  final String id;
  final String title;
  final String author;
  DateTime releaseDate;
  BookCategory? category;
  BookStatus? status;
  BookType? type;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.releaseDate,
    required this.category,
    required this.status,
    required this.type,
  });
}

class DigitalBook extends Book {
  final String format;
  final double fileSize;
  final String link;

  DigitalBook({
    required super.id,
    required super.title,
    required super.author,
    required super.releaseDate,
    required super.category,
    required super.status,
    required super.type,
    required this.format,
    required this.fileSize,
    required this.link,
  });
}

class physiqueBook extends Book {
  final String shelfLocation;
  final String seriesNumber;

  physiqueBook({
    required super.id,
    required super.title,
    required super.author,
    required super.releaseDate,
    required super.category,
    required super.status,
    required super.type,
    required this.shelfLocation,
    required this.seriesNumber,
  });
}

class Member {}

class LibraryManagement {}

void main() {}
