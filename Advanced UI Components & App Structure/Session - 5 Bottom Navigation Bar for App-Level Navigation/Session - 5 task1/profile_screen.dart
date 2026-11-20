
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Avatar
            const CircleAvatar(
              radius: 55,
              backgroundColor: Colors.orange,
              child: Text(
                'R',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Student Name
            const Text(
              'Rushita',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // Student Class
            const Text(
              'Flutter',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            // Canteen Card
            Card(
              elevation: 3,
              color: Colors.orange.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const ListTile(
                contentPadding: EdgeInsets.all(15),

                leading: Icon(
                  Icons.credit_card,
                  size: 35,
                  color: Colors.orange,
                ),

                title: Text('Canteen Card Number'),

                subtitle: Text(
                  'CN-1042',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Student Details Heading
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Student Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Dietary Preference
            const Card(
              child: ListTile(
                leading: Icon(
                  Icons.restaurant,
                  color: Colors.orange,
                ),
                title: Text('Dietary Preference'),
                subtitle: Text('Vegetarian'),
              ),
            ),

            // Favourite Item
            const Card(
              child: ListTile(
                leading: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                title: Text('Favourite Item'),
                subtitle: Text('Masala Dosa'),
              ),
            ),

            // Hostel Block
            const Card(
              child: ListTile(
                leading: Icon(
                  Icons.home,
                  color: Colors.orange,
                ),
                title: Text('Hostel Block'),
                subtitle: Text('Block B'),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
