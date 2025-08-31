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
  final DateTime releaseDate;
  final BookCategory category;
  BookStatus status;
  final BookType type;

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

// ========== MEMBER ENUM ==============
enum MemberStatus { active, nonActive, suspended }

enum MemberPosition { professor, student }

// ========== MEMBER CLASS =============
class Member {
  final String id;
  final String name;
  final String email;
  final String major;
  final MemberPosition position;
  MemberStatus status;
  double penalty;
  final List<String> _borrowedBookIDs = [];
  final Map<String, DateTime> _borrowDates = {};

  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.major,
    required this.position,
    this.penalty = 0,
    required this.status,
  }) : assert(email.contains("@"), "Email must contain @");

  List<String> get borrowedBookIDs => List.unmodifiable(_borrowedBookIDs);

  int get maxBorrowLimit => position == MemberPosition.student ? 5 : 10;

  int get borrowDuration => position == MemberPosition.student ? 14 : 30;

  void borrowBook(String bookId, DateTime borrowDate) {
    if (_borrowedBookIDs.contains(bookId)) {
      throw Exception("⚠ Member already borrowed book with ID ($bookId)");
    }

    if (_borrowedBookIDs.length >= maxBorrowLimit) {
      throw Exception(
        "⚠ Member has reached maximum borrow limit of $maxBorrowLimit books",
      );
    }

    _borrowedBookIDs.add(bookId);
    _borrowDates[bookId] = borrowDate;
  }

  void returnBook(String bookId) {
    if (!_borrowedBookIDs.contains(bookId)) {
      throw Exception("⚠ Member hasn't borrowed book with ID ($bookId)");
    }

    _borrowedBookIDs.remove(bookId);
    _borrowDates.remove(bookId);
  }

  void addPenalty(double amount) {
    penalty += amount;
  }

  bool get canBorrow => status == MemberStatus.active && penalty <= 20000;

  DateTime? getBorrowDate(String bookId) => _borrowDates[bookId];
}

// ======================= 📦 BORROW SYSTEM =======================
class BorrowRecord {
  final String id;
  final DateTime borrowDate;
  final DateTime dueDate;
  final Book book;
  final Member member;
  DateTime? returnDate;
  double? penalty;

  BorrowRecord({
    required this.id,
    required this.borrowDate,
    required this.dueDate,
    required this.book,
    required this.member,
  });
}

class Reservation {
  final String id;
  final Member member;
  final Book book;
  final DateTime reservationDate;
  DateTime? fulfillmentDate;

  Reservation({
    required this.id,
    required this.member,
    required this.book,
    required this.reservationDate,
    this.fulfillmentDate,
  });
}

// ======================= 🏛 LIBRARY MANAGEMENT =======================
class LibraryManagement {
  final List<Book> _books = [];
  final List<Member> _members = [];
  final List<BorrowRecord> _borrowRecords = [];
  final List<Reservation> _reservations = [];
  final Map<String, List<Reservation>> _bookReservations = {};

  // 📖 GET BOOK DATA
  Book getBook(String id) {
    return _books.firstWhere(
      (b) => b.id == id,
      orElse: () => throw Exception("⚠ Book with ID $id not found"),
    );
  }

  // 👤 GET MEMBER DATA
  Member getMember(String id) {
    return _members.firstWhere(
      (m) => m.id == id,
      orElse: () => throw Exception("⚠ Member with ID $id not found"),
    );
  }

  // ➕ ADD BOOK
  void addBook(Book book) {
    if (_books.any((b) => b.id == book.id)) {
      throw Exception("⚠ Book with ID ${book.id} already exists");
    }
    _books.add(book);
    print("📚 Book '${book.title}' added");
  }

  // ➕ ADD MEMBER
  void addMember(Member member) {
    if (_members.any((m) => m.id == member.id)) {
      throw Exception("⚠ Member with ID ${member.id} already exists");
    }
    _members.add(member);
    print("👤 Member '${member.name}' added");
  }

  // ---------------- SEARCH FUNCTIONS ----------------
  List<Book> searchByTitle(String title) {
    final keyword = title.toLowerCase();
    return _books
        .where((b) => b.title.toLowerCase().contains(keyword))
        .toList();
  }

  List<Book> searchByAuthor(String author) {
    final keyword = author.toLowerCase();
    return _books
        .where((b) => b.author.toLowerCase().contains(keyword))
        .toList();
  }

  List<Book> searchByCategory(BookCategory category) {
    return _books.where((b) => b.category == category).toList();
  }

  // ---------------- OUTPUT FUNCTION ----------------
  void printBooks(
    List<Book> books, {
    String searchType = "",
    String keyword = "",
  }) {
    if (books.isEmpty) {
      print(
        "⚠ No books found${searchType.isNotEmpty ? " for $searchType" : ""}${keyword.isNotEmpty ? " '$keyword'" : ""}",
      );
      return;
    }

    print(
      "\n🔍 Search Results${searchType.isNotEmpty ? " ($searchType" : ""}${keyword.isNotEmpty ? " '$keyword')" : ""}",
    );
    print("=" * 50);
    for (var book in books) {
      print("📘 Title       : ${book.title}");
      print("✍  Author      : ${book.author}");
      print("🏷  Category    : ${book.category.name}");
      print("📅 Release Date: ${book.releaseDate}");
      print("📋 Status      : ${book.status.name}");
      print("📂 Type        : ${book.type.name}");
      print("-" * 50);
    }
  }

  // ----------------- BORROW SECTION ---------------------
  void borrowBook({
    required String memberId,
    required String bookId,
    required DateTime borrowDate,
  }) {
    final member = getMember(memberId);
    final book = getBook(bookId);

    // Validasi member
    if (!member.canBorrow) {
      throw Exception(
        "⛔ Member cannot borrow books. Status: ${member.status}, Penalty: ${member.penalty}",
      );
    }

    // Validasi buku
    if (book.status != BookStatus.available) {
      throw Exception("⚠ Book '${book.title}' is not available for borrowing");
    }

    if (book.status == BookStatus.reference) {
      throw Exception("⚠ Reference books cannot be borrowed");
    }

    // Hitung due date
    final dueDate = borrowDate.add(Duration(days: member.borrowDuration));

    // Buat record peminjaman
    final borrowRecord = BorrowRecord(
      id: "BOR-${_borrowRecords.length + 1}",
      borrowDate: borrowDate,
      dueDate: dueDate,
      book: book,
      member: member,
    );

    // Update status
    book.status = BookStatus.booked;
    member.borrowBook(bookId, borrowDate);
    _borrowRecords.add(borrowRecord);

    print("📖 '${book.title}' borrowed by ${member.name}. Due date: $dueDate");
  }

  // 📜 CHECK BORROW HISTORY
  void printBorrowHistory(String memberId) {
    final member = getMember(memberId);
    final records = _borrowRecords
        .where((r) => r.member.id == memberId)
        .toList();

    if (records.isEmpty) {
      print("⚠ No borrow history found for ${member.name}");
      return;
    }

    print("\n📜 Borrow History for ${member.name}");
    print("=" * 50);
    for (var record in records) {
      final returned = record.returnDate != null;
      final status = returned ? "Returned" : "Borrowed";
      final returnInfo = returned
          ? "Returned: ${record.returnDate}"
          : "Due: ${record.dueDate}";

      print("📘 ${record.book.title} - $status");
      print("   Borrowed: ${record.borrowDate}");
      print("   $returnInfo");
      if (record.penalty != null && record.penalty! > 0) {
        print("   Penalty: Rp${record.penalty}");
      }
      print("-" * 30);
    }
  }

  // ----------------- RETURN SECTION -------------------
  void returnBook({
    required String memberId,
    required String bookId,
    required DateTime returnDate,
  }) {
    final member = getMember(memberId);
    final book = getBook(bookId);

    // Cek apakah member meminjam buku ini
    if (!member.borrowedBookIDs.contains(bookId)) {
      throw Exception("⚠ ${member.name} hasn't borrowed '${book.title}'");
    }

    // Cari record peminjaman yang aktif
    final borrowRecord = _borrowRecords.firstWhere(
      (r) =>
          r.member.id == memberId &&
          r.book.id == bookId &&
          r.returnDate == null,
      orElse: () => throw Exception("⚠ No active borrow record found"),
    );

    // Hitung denda jika terlambat
    double penalty = 0;
    if (returnDate.isAfter(borrowRecord.dueDate)) {
      final lateDays = returnDate.difference(borrowRecord.dueDate).inDays;
      penalty = lateDays * 2000;

      if (penalty > 0) {
        member.addPenalty(penalty);
        borrowRecord.penalty = penalty;
        print("⚠ Late return penalty: Rp$penalty");
      }
    }

    // Update record dan status
    borrowRecord.returnDate = returnDate;
    book.status = BookStatus.available;
    member.returnBook(bookId);

    // Cek jika ada reservasi untuk buku ini
    _fulfillReservations(book);

    print("✅ '${book.title}' returned by ${member.name}");
  }

  // ----------------- RESERVATION SECTION -------------------
  void reserveBook({
    required String memberId,
    required String bookId,
    required DateTime reservationDate,
  }) {
    final member = getMember(memberId);
    final book = getBook(bookId);

    // Validasi buku harus dipinjam
    if (book.status != BookStatus.booked) {
      throw Exception(
        "⚠ Book '${book.title}' is available for immediate borrowing",
      );
    }

    // Cek apakah member sudah mereservasi buku ini
    if (_reservations.any(
      (r) =>
          r.member.id == memberId &&
          r.book.id == bookId &&
          r.fulfillmentDate == null,
    )) {
      throw Exception(
        "⚠ ${member.name} already has an active reservation for '${book.title}'",
      );
    }

    // Buat reservasi
    final reservation = Reservation(
      id: "RES-${_reservations.length + 1}",
      member: member,
      book: book,
      reservationDate: reservationDate,
    );

    _reservations.add(reservation);

    // Tambahkan ke antrian reservasi buku
    if (!_bookReservations.containsKey(bookId)) {
      _bookReservations[bookId] = [];
    }
    _bookReservations[bookId]!.add(reservation);

    print("✅ Reservation added for ${member.name} on '${book.title}'");
  }

  // Helper method untuk memenuhi reservasi
  void _fulfillReservations(Book book) {
    final bookId = book.id;
    final reservations = _bookReservations[bookId] ?? [];

    if (reservations.isNotEmpty) {
      final nextReservation = reservations.first; // Mengambil reservasi pertama
      nextReservation.fulfillmentDate = DateTime.now();

      // Notifikasi atau proses pemenuhan reservasi
      print(
        "📩 Notification: '${book.title}' is now available for ${nextReservation.member.name}",
      );

      // Hapus dari antrian
      reservations.removeAt(0);
    }
  }

  // 📜 PRINT RESERVATION HISTORY
  void printReservationHistory() {
    if (_reservations.isEmpty) {
      print("⚠ No reservations found");
      return;
    }

    print("\n📋 Reservation History");
    print("=" * 50);
    for (var reservation in _reservations) {
      final status = reservation.fulfillmentDate != null
          ? "Fulfilled"
          : "Active";
      print("📘 ${reservation.book.title} - ${reservation.member.name}");
      print("   Reserved: ${reservation.reservationDate}");
      print("   Status: $status");
      if (reservation.fulfillmentDate != null) {
        print("   Fulfilled: ${reservation.fulfillmentDate}");
      }
      print("-" * 30);
    }
  }

  // 📊 PRINT LIBRARY STATS
  void printLibraryStats() {
    print("\n📊 Library Statistics");
    print("=" * 50);
    print("📚 Total Books: ${_books.length}");
    print("👤 Total Members: ${_members.length}");
    print(
      "📖 Borrowed Books: ${_borrowRecords.where((r) => r.returnDate == null).length}",
    );
    print(
      "⏰ Active Reservations: ${_reservations.where((r) => r.fulfillmentDate == null).length}",
    );

    final totalPenalty = _members.fold<double>(
      0,
      (sum, member) => sum + member.penalty,
    );
    print("💰 Total Penalties: Rp$totalPenalty");
  }
}

void main() {
  try {
    final library = LibraryManagement();

    // ------------ ADD BOOKS ---------------
    final pBook1 = PhysiqueBook(
      id: "B001",
      title: "Beautiful in White",
      author: "Angga",
      releaseDate: DateTime(2018, 11, 11),
      category: BookCategory.romance,
      status: BookStatus.available,
      type: BookType.physique,
      shelfLocation: "R1-0001",
      seriesNumber: "2",
    );

    final pBook2 = PhysiqueBook(
      id: "B002",
      title: "The Darkness of Our Brain",
      author: "Jenny",
      releaseDate: DateTime(2006, 10, 30),
      category: BookCategory.psychology,
      status: BookStatus.available,
      type: BookType.physique,
      shelfLocation: "E1-001",
      seriesNumber: "1",
    );

    final dBook1 = DigitalBook(
      id: "B003",
      title: "September",
      author: "Angga",
      releaseDate: DateTime(2019, 9, 23),
      category: BookCategory.romance,
      status: BookStatus.available,
      type: BookType.digital,
      format: "PDF",
      fileSize: 200,
      link: "https://example.com",
    );

    final dBook2 = DigitalBook(
      id: "B004",
      title: "Earthquake Technology",
      author: "Angga",
      releaseDate: DateTime(2019, 9, 23),
      category: BookCategory.technology,
      status: BookStatus.reference, // Reference book
      type: BookType.digital,
      format: "PDF",
      fileSize: 200,
      link: "https://example.com",
    );

    library.addBook(pBook1);
    library.addBook(pBook2);
    library.addBook(dBook1);
    library.addBook(dBook2);

    // ----------- ADD MEMBERS -------------
    final member1 = Member(
      id: "M001",
      name: "Wina",
      email: "wina23@gmail.com",
      major: "Medicine",
      position: MemberPosition.student,
      status: MemberStatus.active,
    );

    final member2 = Member(
      id: "M002",
      name: "Anne",
      email: "anne23@gmail.com",
      major: "Economy",
      position: MemberPosition.student,
      status: MemberStatus.active,
    );

    final professor = Member(
      id: "M003",
      name: "Dr. Smith",
      email: "smith@university.edu",
      major: "Computer Science",
      position: MemberPosition.professor,
      status: MemberStatus.active,
    );

    library.addMember(member1);
    library.addMember(member2);
    library.addMember(professor);

    // ----------- BORROW BOOKS ------------
    final now = DateTime.now();

    // Member1 borrows a book
    library.borrowBook(
      memberId: member1.id,
      bookId: pBook1.id,
      borrowDate: now,
    );

    // Member2 tries to borrow the same book (should fail)
    try {
      library.borrowBook(
        memberId: member2.id,
        bookId: pBook1.id,
        borrowDate: now,
      );
    } catch (e) {
      print("Expected error: $e");
    }

    // Member2 borrows a different book
    library.borrowBook(
      memberId: member2.id,
      bookId: dBook1.id,
      borrowDate: now,
    );

    // Professor borrows a book
    library.borrowBook(
      memberId: professor.id,
      bookId: pBook2.id,
      borrowDate: now,
    );

    // ----------- RESERVE BOOKS -----------
    // Member1 reserves the book that member2 borrowed
    library.reserveBook(
      memberId: member1.id,
      bookId: dBook1.id,
      reservationDate: now,
    );

    // ----------- RETURN BOOKS ------------
    // Return a book after 15 days (1 day late for students)
    final returnDate = now.add(Duration(days: 15));
    library.returnBook(
      memberId: member2.id,
      bookId: dBook1.id,
      returnDate: returnDate,
    );

    // ----------- PRINT INFO ------------
    library.printBorrowHistory(member2.id);
    library.printReservationHistory();
    library.printLibraryStats();

    // ----------- SEARCH BOOKS ------------
    final romanceBooks = library.searchByCategory(BookCategory.romance);
    library.printBooks(
      romanceBooks,
      searchType: "Category",
      keyword: "romance",
    );
  } catch (e) {
    print("Error: $e");
  }
}
