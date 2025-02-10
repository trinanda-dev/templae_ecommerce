import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/category/category_provider.dart';
import 'package:shop_app/screens/all_categories/all_categories_screen.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    // Tampilkan widget kosong jika tidak ada kategori
    if (categoryProvider.categories.isEmpty) {
      return const SizedBox();
    }

    // Ambil maksimal 4 kategori pertama
    final displayedCategories = categoryProvider.categories.take(4).toList();

    // Tambahkan kategori "More"
    final categoriesToShow = [
      ...displayedCategories,
      {
        'nama': 'More',
        'id' : -1,
        'icon': 'assets/icons/Discover.svg'
      }
    ];

    return Padding(
    padding: const EdgeInsets.all(20),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categoriesToShow.length,
          (index) => CategoryCard(
            category: categoriesToShow[index],
            press: () {
              if (categoriesToShow[index]['id'] == -1) {
                Navigator.push(
                  context, 
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: const AllCategoriesScreen(),
                  ),
                );
              } else {
                // Tambahkan navigasi ke halaman produk kategori
              }
            },
          ),
        ),
      ),
    ),
  );
  }
}

class CategoryCard extends StatelessWidget {
  final Map<String, dynamic> category;
  final GestureTapCallback press;

  const CategoryCard({
    super.key,
    required this.category,
    required this.press,
  });

  String _getIconPath(String categoryName) {
    const iconMap = {
      'Taman': 'assets/icons/Discover.svg',
      'Renovasi Rumah': 'assets/icons/Discover.svg',
      'Perkakas': 'assets/icons/Discover.svg',
      'Baterai': 'assets/icons/Discover.svg',
      'More': 'assets/icons/Discover.svg',
    };
    return iconMap[categoryName] ?? 'assets/icons/Discover.svg';
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = category['nama'];
    final isMoreCategory = category['id'] == -1;

    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: isMoreCategory 
                    ? Colors.grey[200]
                    : const Color(0xFFFFECDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                _getIconPath(categoryName),
                colorFilter: isMoreCategory
                    ? const ColorFilter.mode(
                        Colors.grey, BlendMode.srcIn)
                    : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              categoryName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}