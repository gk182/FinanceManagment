import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_category_page.dart';
import 'package:finance_managment/utils/user_helper.dart';
import 'package:finance_managment/constant/app_colors.dart';
class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userId = UserHelper.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: AppColors.OceanBlue,
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
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.whiteBackground,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
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
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final doc = categories[index];
                        final data = doc.data() as Map<String, dynamic>;

                        return GestureDetector(
                          onLongPress: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Delete Category"),
                                content: Text("Are you sure you want to delete '${data['name']}'?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .collection('categories')
                                  .doc(doc.id)
                                  .delete();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.LightBlue,
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
