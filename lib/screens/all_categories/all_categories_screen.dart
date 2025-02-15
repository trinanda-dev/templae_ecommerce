import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/category/category_provider.dart';
import 'package:shop_app/screens/home/components/categories.dart';
import 'package:shop_app/screens/products/category_product_screen.dart';


class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Kategori'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.8,
          ),
          itemCount: categoryProvider.categories.length,
          itemBuilder: (context, index) {
            final category = categoryProvider.categories[index];
            return CategoryCard(
              category: category,
              press: () {
                Navigator.push(
                  context, 
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: CategoryProductScreen(
                      categoryId: category['id'], 
                      categoryName: category['nama'],
                    )
                  )
                );
              },
            );
          },
        ),
      ),
    );
  }
}