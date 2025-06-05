import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_category_page.dart';

class CategoryPage extends StatelessWidget {
  final String userId = 'testUser123'; // 👈 Tạm hardcode để test

  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00DDB5),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: const Color(0xFF90C4FF),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          showDialog(context: context, builder: (_) => const AddCategoryPage());
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFEFFFF7),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('categories')
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final categories = snapshot.data?.docs ?? [];

                    if (categories.isEmpty) {
                      return const Center(child: Text('No categories yet.'));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final data =
                            categories[index].data() as Map<String, dynamic>;

                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF90C4FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                IconData(
                                  data['iconCode'],
                                  fontFamily: data['fontFamily'],
                                ),
                                size: 30,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data['name'] ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
