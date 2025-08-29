enum BookCategory {
  science,
  technology,
  literature,
  psychology,
  religion,
  language,
  romance,
}

enum BookStatus { available, booked, reference }

enum BookType { physique, digital }

// ======================= 📖 BOOK CLASS =======================
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

// ======================= 💻 DIGITAL BOOK =======================
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

// ======================= 📕 PHYSICAL BOOK =======================
class PhysiqueBook extends Book {
  final String shelfLocation;
  final String seriesNumber;

  PhysiqueBook({
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

// ======================= 👤 MEMBER ENUM =======================
enum MemberStatus { active, nonActive, suspended }

enum MemberPosition { professors, student }

// ======================= 👤 MEMBER CLASS =======================
class Member {
  final String id;
  final String name;
  final String email;
  final String major;
  MemberPosition position;
  MemberStatus status;
  int totalDay;
  double penalty;
  List<String> bookIDs = [];

  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.major,
    required this.position,
    this.penalty = 0,
    required this.status,
    this.totalDay = 0,
  }) : assert(email.contains("@gmail.com"), "Email must contain @gmail.com");

  void addBook(String id) {
    if (bookIDs.contains(id)) {
      throw Exception("⚠️ Member already borrowed book with ID ($id)");
    }
    bookIDs.add(id);
    print("✅ Book added to borrowed history");
  }

  void addPenalty({required totalDays}) {
    penalty += totalDays * 2000;
  }
}

// ======================= 📦 BORROW SYSTEM =======================
class BorrowSystem {
  DateTime borrowDate;
  Book book;
  Member member;

  BorrowSystem({
    required this.borrowDate,
    required this.book,
    required this.member,
  });
}

class returnHistory {
  DateTime returnDate;
  Book book;
  Member member;

  returnHistory({
    required this.returnDate,
    required this.book,
    required this.member,
  });
}

// ======================= 🏛️ LIBRARY MANAGEMENT =======================
class LibraryManagement {
  List<Book> _book = [];
  List<Member> _member = [];
  List<BorrowSystem> _borrow = [];
  List<returnHistory> _return = [];

  // ------------- ADDED DATA SECTION ------------------

  // 📖 GET BOOK DATA
  Book getBookData(String id) {
    return _book.firstWhere(
      (b) => b.id == id,
      orElse: () => throw Exception("⚠️ Book not found"),
    );
  }

  // 👤 GET MEMBER DATA
  Member getMemberData(String id) {
    return _member.firstWhere(
      (m) => m.id == id,
      orElse: () => throw Exception("⚠️ Member not found"),
    );
  }

  // ➕ ADD BOOK
  void addBook(Book book) {
    if (_book.any((b) => b.id == book.id)) {
      throw Exception("⚠️ Book with ID (${book.id}) already exists");
    }
    _book.add(book);
    print("📚 Book '${book.title}' added");
  }

  // ➕ ADD MEMBER
  void addMember(Member member) {
    if (_member.any((m) => m.id == member.id)) {
      throw Exception("⚠️ Member with ID (${member.id}) already exists");
    }
    _member.add(member);
    print("👤 Member '${member.name}' added");
  }

  // ---------------- SEARCH FUNCTIONS ----------------
  List<Book> getBookByTitle(String title) {
    return _book
        .where((b) => b.title.toLowerCase().contains(title.toLowerCase()))
        .toList();
  }

  List<Book> getBookByAuthor(String author) {
    return _book
        .where((b) => b.author.toLowerCase().contains(author.toLowerCase()))
        .toList();
  }

  List<Book> getBookByCategory(String category) {
    try {
      var categoryEnum = BookCategory.values.firstWhere(
        (c) => c.name.toLowerCase() == category.toLowerCase(),
      );
      return _book.where((b) => b.category == categoryEnum).toList();
    } catch (e) {
      return []; // kalau kategori tidak ditemukan
    }
  }

  // ---------------- OUTPUT FUNCTION ----------------
  void printBooks({
    required String searchType,
    required String keyword,
    required List<Book> books,
  }) {
    if (books.isEmpty) {
      print("⚠️ No book found for $searchType [$keyword]");
      return;
    }

    print("\n🔍 Search Result ($searchType = '$keyword')");
    print("==========================================");
    for (var item in books) {
      print("📘 Title       : ${item.title}");
      print("✍️  Author      : ${item.author}");
      print("🏷️  Category    : ${item.category?.name}");
      print("📅 Release Date: ${item.releaseDate}");
      print("------------------------------------------");
    }
  }

  // ----------------- BORROW SECTION ---------------------

  BorrowSystem getBorrow({required String memberID}) {
    return _borrow.firstWhere(
      (b) => b.member.id == memberID,
      orElse: () =>
          throw Exception("Member with ID [$memberID] doesn't borrow any book"),
    );
  }

  // 🔑 BORROW BOOK
  void borrowBook({
    required String memberID,
    required String bookID,
    required DateTime borrowDate,
  }) {
    var member = getMemberData(memberID);
    var book = getBookData(bookID);

    if (member.penalty > 20000)
      throw Exception("Member with more than 20.000 penalty can't borrow book");

    if (member.bookIDs.contains(book.id)) {
      throw Exception("⚠️ ${member.name} already borrowed ${book.title}");
    }

    if (member.status == MemberStatus.suspended) {
      throw Exception("⛔ Suspended member can't borrow books");
    }

    if (book.status == BookStatus.reference)
      throw Exception("Book with reference status can't borrowed");

    if (book.status == BookStatus.booked) throw Exception("Book is booked");

    int borrowWithinPeriod = _borrow
        .where(
          (b) =>
              b.member == member &&
              borrowDate.difference(b.borrowDate).inDays.abs() <=
                  (member.position == MemberPosition.student ? 14 : 30),
        )
        .length;

    if (member.position == MemberPosition.student && borrowWithinPeriod >= 5) {
      throw Exception("⚠️ Students can borrow max 5 books within 14 days");
    }

    if (member.position == MemberPosition.professors &&
        borrowWithinPeriod >= 10) {
      throw Exception("⚠️ Professors can borrow max 10 books within 30 days");
    }

    var newBorrowed = BorrowSystem(
      borrowDate: borrowDate,
      book: book,
      member: member,
    );
    _borrow.add(newBorrowed);
    member.bookIDs.add(bookID);

    if (book.type == BookType.physique) book.status = BookStatus.booked;

    print("📖 '${book.title}' borrowed by ${member.name}");
  }

  // 📜 CHECK BORROW HISTORY
  void checkBorrowHistory(String memberID) {
    if (_member.isEmpty) throw Exception("⚠️ No member added");
    if (_book.isEmpty) throw Exception("⚠️ No book added");
    if (_borrow.isEmpty) throw Exception("⚠️ No borrow history");

    var member = getMemberData(memberID);
    var books = _book.where((b) => member.bookIDs.contains(b.id)).toList();

    print("\n📜 Borrowed History of ${member.name}");
    print("=====================================");
    for (var item in books) {
      print("📘 Title       : ${item.title}");
      print("✍️  Author      : ${item.author}");
      print("🏷️  Category    : ${item.category?.name}");
      print("📅 Release Date: ${item.releaseDate}");
      print("📊 Status      : ${item.status?.name}");
      print("📂 Type        : ${item.type?.name}");
      print("-------------------------------------");
    }
    // .name this is a special propertie in Dart enum, .name is used for show real variable name in enum when it called
  }

  // ----------------- RETURN SECTION -------------------

  void historyReturn({required String memberID}) {
    if (_return.isEmpty) throw Exception("No return history");

    var member = getMemberData(memberID);
    var history = _return.where((r) => r.member.id == memberID).toList();

    if (history.isEmpty)
      throw Exception("${member.name} doesn't have return book history");

    print("\nRETURN HISTORY by ${member.name}");
    print("================================");
    for (var item in history) {
      print("- DATE   : ${item.returnDate}");
      print("Title    : ${item.book.title}");
      print("Category : ${item.book.category?.name}");
      print("Release Date : ${item.book.releaseDate}");
      print("Status       : ${item.book.status?.name}");
      print("Type         : ${item.book.type?.name}");
      print("------------------------------------");
    }
  }

  void returnBook({
    required String memberID,
    required String bookID,
    required DateTime returnDate,
  }) {
    var borrow = getBorrow(memberID: memberID);

    if (!_borrow.any((b) => b.member.id == memberID))
      throw Exception("Member with ID ($memberID) doesn't have borrow history");

    if (!_borrow.any((b) => b.book.id == bookID))
      throw Exception("Book with ID ($memberID) doesn't have borrow history");

    var member = getMemberData(memberID);
    var book = getBookData(bookID);

    if (!member.bookIDs.contains(bookID))
      throw Exception("${member.name} doesn't have book borrowed");

    if (borrow.borrowDate.day > returnDate.day)
      throw Exception("Return date should be after borrow date");

    int totalDay = borrow.borrowDate.day - returnDate.day;

    member.addPenalty(totalDays: totalDay);
    book.status = BookStatus.available;
    member.bookIDs.remove(bookID);

    var returnRecord = returnHistory(
      returnDate: returnDate,
      book: book,
      member: member,
    );

    _return.add(returnRecord);

    _borrow.remove(borrow);
    print("${member.name} no longer booked [${book.title}]");
  }
}

void main() {
  try {
    var management = LibraryManagement();

    var digitalBook1 = DigitalBook(
      id: "B001",
      title: "September",
      author: "Angga",
      releaseDate: DateTime(2019, 9, 23, 20, 00),
      category: BookCategory.romance,
      status: BookStatus.available,
      type: BookType.digital,
      format: "PDF",
      fileSize: 200,
      link: "https://example.com",
    );

    var physiqueBook1 = PhysiqueBook(
      id: "B002",
      title: "Beautiful in White",
      author: "Angga",
      releaseDate: DateTime(2018, 11, 11, 20, 00),
      category: BookCategory.romance,
      status: BookStatus.available,
      type: BookType.physique,
      shelfLocation: "R1-0001",
      seriesNumber: "2",
    );

    var physiqueBook2 = PhysiqueBook(
      id: "B003",
      title: "As Beautiful as September",
      author: "Angga",
      releaseDate: DateTime(2018, 5, 11, 20, 00),
      category: BookCategory.romance,
      status: BookStatus.available,
      type: BookType.physique,
      shelfLocation: "R1-0001",
      seriesNumber: "2",
    );

    management.addBook(digitalBook1);
    management.addBook(physiqueBook1);
    management.addBook(physiqueBook2);

    var member1 = Member(
      id: "M001",
      name: "Wina",
      email: "wina23@gmail.com",
      major: "Medicine",
      position: MemberPosition.student,
      status: MemberStatus.active,
    );

    management.addMember(member1);

    management.borrowBook(
      memberID: member1.id,
      bookID: digitalBook1.id,
      borrowDate: DateTime.now(),
    );

    management.borrowBook(
      memberID: member1.id,
      bookID: physiqueBook1.id,
      borrowDate: DateTime.now(),
    );

    management.returnBook(
      memberID: member1.id,
      bookID: digitalBook1.id,
      returnDate: DateTime.now(),
    );

    management.checkBorrowHistory(member1.id);
    management.historyReturn(memberID: member1.id);

    var byTitle = management.getBookByTitle("beautiful");
    management.printBooks(
      searchType: "Title",
      keyword: "beautiful",
      books: byTitle,
    );

    var byAuthor = management.getBookByAuthor("angga");
    management.printBooks(
      searchType: "Author",
      keyword: "angga",
      books: byAuthor,
    );

    var byCategory = management.getBookByCategory(BookCategory.romance.name);
    management.printBooks(
      searchType: "Category",
      keyword: BookCategory.romance.name,
      books: byCategory,
    );
  } catch (e) {
    print(e);
  }
}
