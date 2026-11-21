class PastOrder {
  final int orderNo;
  final String dateLabel;
  final int itemCount;
  final double total;
  final String status;

  PastOrder({
    required this.orderNo,
    required this.dateLabel,
    required this.itemCount,
    required this.total,
    required this.status,
  });
}
