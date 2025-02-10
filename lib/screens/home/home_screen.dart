import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/brand/brand_provider.dart';
import 'package:shop_app/provider/category/category_provider.dart';

import 'components/categories.dart';
import 'components/discount_banner.dart';
import 'components/home_header.dart';
import 'components/popular_product.dart';
import 'components/special_offers.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
  }

  Future<void> _fetchInitialData() async {
    try {
      await Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      await Provider.of<BrandProvider>(context, listen: false).fetchBrands();
    } catch (e) {
      debugPrint("Gagal mengambil kategori: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      await Provider.of<BrandProvider>(context, listen: false).fetchBrands();
    } catch (e) {
      debugPrint("Gagal merefresh kategori: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _refreshData,
              displacement: 50,
              child: const SingleChildScrollView(
                padding:  EdgeInsets.symmetric(vertical: 16),
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                  HomeHeader(),
                  DiscountBanner(),
                  Categories(),
                  SpecialOffers(),
                  SizedBox(height: 20),
                  PopularProducts(),
                  SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // Indikator Refresh Lottie
            if (_isLoading)
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                    child: Center(
                    child: Lottie.asset(
                      'assets/lottie/loading-2.json',
                      width: 50,
                      height: 50,
                    ),
                  ),
                )
              ),
          ],
        ),
      ),
    );
  }
}