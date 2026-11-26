class Expense {
  int? id;
  String title;
  double amount;
  String category;
  String date;

  // Constructor
  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  // Convert Expense object into Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
    };

    // Add id only when it is not null
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  // Convert Map into Expense object
  static Expense fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      date: map['date'] as String,
    );
  }
}
