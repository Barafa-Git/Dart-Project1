// Book ENUM

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
  int stock;
  DateTime releaseDate;
  BookCategory? category;
  BookStatus? status;
  BookType? type;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.stock = 0,
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
    super.stock = 0,
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
    super.stock = 0,
    required super.category,
    required super.status,
    required super.type,
    required this.shelfLocation,
    required this.seriesNumber,
  });
}

// Member ENUM
enum MemberStatus { active, nonActive, suspended }

enum MemberPosition { professors, student }

class Member {
  final String id;
  final String name;
  final String email;
  final String major;
  MemberPosition position;
  MemberStatus status;
  int totalDay;
  List<String> bookIDs = [];

  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.major,
    required this.position,
    required this.status,
    this.totalDay = 0,
  });

  void addBook(String id) {
    if (bookIDs.contains(id))
      throw Exception("Member already borrowed book with ID ($id)");
    bookIDs.add(id);
    print("Book added to borrowed history");
  }
}

class borrowSystem {
  DateTime borrowDate;
  int quantity;
  Book book;
  Member member;

  borrowSystem({
    required this.borrowDate,
    required this.quantity,
    required this.book,
    required this.member,
  }) : assert(quantity > 0, "Borrow Quantity can't be nagative");
}

class LibraryManagement {
  List<Book> _book = [];
  List<Member> _member = [];
  List<borrowSystem> _borrow = [];

  Book getBookData(String id) {
    return _book.firstWhere(
      (b) => b.id == id,
      orElse: () => throw Exception("Book not found"),
    );
  }

  Member getMemberData(String id) {
    return _member.firstWhere(
      (m) => m.id == id,
      orElse: () => throw Exception("Member not found"),
    );
  }

  void addBook(Book book) {
    if (_book.contains(book.id)) throw Exception("Book Already Added");

    _book.add(book);
    print("Book added");
  }

  void addMember(Member member) {
    if (_member.contains(member.id)) throw Exception("Member Already Added");

    _member.add(member);
    print("member added");
  }

  void borrowBook({
    required String memberID,
    required String bookID,
    required DateTime borrowDate,
    required int quantity,
  }) {
    var member = getMemberData(memberID);
    var book = getBookData(bookID);

    if (member.bookIDs.contains(book.id))
      throw Exception("${member.name} already borrow ${book.title}");
  }
}

void main() {}
