class Expense {
  int? id;
  String title;
  double amount;
  String category;
  String date;
  String? note;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });

  // Convert Expense object into Map for SQLite
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
      'note': note,
    };

    // Preserve original ID when restoring or updating
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  // Convert SQLite Map into Expense object
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      date: map['date'] as String,
      note: map['note'] as String?,
    );
  }
}
