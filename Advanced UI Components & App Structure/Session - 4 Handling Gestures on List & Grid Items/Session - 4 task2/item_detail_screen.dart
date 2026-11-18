import 'package:flutter/material.dart';

class ItemDetailScreen extends StatefulWidget {
  final String itemName;
  final double price;
  final IconData itemIcon;

  const ItemDetailScreen({
    super.key,
    required this.itemName,
    required this.price,
    required this.itemIcon,
  });

  @override
  State<ItemDetailScreen> createState() =>
      _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {

  // Favourite status
  bool _isFavourite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Large item icon
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  _isFavourite = !_isFavourite;
                });
              },

              child: Icon(
                widget.itemIcon,
                size: 120,
                color: Colors.deepOrange,
              ),
            ),

            const SizedBox(height: 20),

            // Item name and favourite heart
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  widget.itemName,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 10),

                Icon(
                  _isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border,

                  color: _isFavourite
                      ? Colors.red
                      : Colors.grey,

                  size: 30,
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Item price
            Text(
              '₹${widget.price.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 22,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Double tap the icon to add to favourites',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
