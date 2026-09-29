import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import 'widgets/amazon_header_bar.dart';
import 'widgets/category_circle_bar.dart';
import 'widgets/deal_banner_carousel.dart';
import 'widgets/deal_horizontal_strip.dart';
import 'widgets/amazon_quad_showcase.dart';
import '../products/widgets/product_card.dart';
import '../products/product_detail_screen.dart';
import '../products/add_edit_product_screen.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      if (productProvider.rawProducts.isEmpty) {
        productProvider.fetchProducts();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final allProducts = productProvider.rawProducts;
    final electronicProducts = allProducts.where((p) => p.category.toLowerCase().contains('electronic')).toList();
    final fashionProducts = allProducts.where((p) => p.category.toLowerCase().contains('clothing')).toList();
    final topRatedProducts = allProducts.where((p) => p.rating.rate >= 4.0).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Amazon & Flipkart Search Header Bar
          AmazonHeaderBar(
            authProvider: authProvider,
            searchController: _searchController,
            onSearchChanged: (val) => productProvider.setSearchQuery(val),
            onSearchSubmitted: () {
              if (widget.onNavigateTab != null) {
                widget.onNavigateTab!(1); // Jump to Explore tab
              }
            },
          ),

          // Main Scrollable Area
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => productProvider.fetchProducts(),
              child: Builder(
                builder: (context) {
                  if (productProvider.isLoading && allProducts.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // If user entered search, show live search results
                  if (productProvider.searchQuery.isNotEmpty) {
                    final searchResults = productProvider.products;
                    return ListView(
                      padding: const EdgeInsets.all(12),
                      children: [
                        Text(
                          '${searchResults.length} results for "${productProvider.searchQuery}"',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: searchResults.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.68,
                          ),
                          itemBuilder: (context, index) {
                            final product = searchResults[index];
                            return ProductCard(
                              product: product,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailScreen(productId: product.id),
                                  ),
                                );
                              },
                              onAddToCart: () {},
                            );
                          },
                        ),
                      ],
                    );
                  }

                  // Normal Amazon / Flipkart Homepage Layout
                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // 1. Horizontal Category Circles
                      CategoryCircleBar(
                        categories: productProvider.categories,
                        selectedCategory: productProvider.selectedCategory,
                        onSelectCategory: (cat) {
                          productProvider.selectCategory(cat);
                          if (widget.onNavigateTab != null && cat != 'all') {
                            widget.onNavigateTab!(1); // Go to Explore
                          }
                        },
                      ),

                      // 2. Promotional Deals Banner Carousel
                      const DealBannerCarousel(),

                      // 3. Lightning Deals Ribbon
                      DealHorizontalStrip(
                        title: 'Blockbuster Deals',
                        subtitle: 'Ends in 03h 22m • Grab Now',
                        products: allProducts,
                        onSeeAll: () {
                          if (widget.onNavigateTab != null) widget.onNavigateTab!(1);
                        },
                      ),

                      // 4. Amazon-style Quad Showcase (Electronics)
                      if (electronicProducts.isNotEmpty)
                        AmazonQuadShowcase(
                          title: 'Up to 60% off | Top tech & electronics',
                          products: electronicProducts,
                          onSeeMore: () {
                            productProvider.selectCategory("electronics");
                            if (widget.onNavigateTab != null) widget.onNavigateTab!(1);
                          },
                        ),

                      // 5. Customer Favorites (Rating 4.0+)
                      if (topRatedProducts.isNotEmpty)
                        DealHorizontalStrip(
                          title: 'Customer Most-Loved (4★+)',
                          subtitle: 'Top rated by thousands of buyers',
                          products: topRatedProducts,
                          onSeeAll: () {
                            if (widget.onNavigateTab != null) widget.onNavigateTab!(1);
                          },
                        ),

                      // 6. Amazon-style Quad Showcase (Fashion)
                      if (fashionProducts.isNotEmpty)
                        AmazonQuadShowcase(
                          title: 'Latest Trends in Fashion | Under \$50',
                          products: fashionProducts,
                          onSeeMore: () {
                            productProvider.selectCategory("men's clothing");
                            if (widget.onNavigateTab != null) widget.onNavigateTab!(1);
                          },
                        ),

                      // 7. Seller Add Product Action Card
                      Container(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            const Icon(Icons.storefront, color: AppColors.headerNavy, size: 32),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sell on Marketplace',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  Text(
                                    'Create & list new products using FakeStore API',
                                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.amazonOrange,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                minimumSize: Size.zero,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const AddEditProductScreen()),
                                );
                              },
                              child: const Text('Add Product', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
