class PastOrder {
  final Map<String, int> items;
  final String status;
  final DateTime orderDate;

  PastOrder({
    required this.items,
    required this.status,
    required this.orderDate,
  });
}
