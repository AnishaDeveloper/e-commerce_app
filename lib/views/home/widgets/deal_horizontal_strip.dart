import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/product.dart';
import '../../products/product_detail_screen.dart';

class DealHorizontalStrip extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Product> products;
  final VoidCallback onSeeAll;

  const DealHorizontalStrip({
    super.key,
    required this.title,
    required this.subtitle,
    required this.products,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.dealRed,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'DEAL',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: AppColors.discountGreen, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: onSeeAll,
                  child: const Text('See all', style: TextStyle(color: AppColors.linkBlue, fontSize: 13)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Horizontal Products List
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: products.take(8).length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final product = products[index];
                // Simulated strike price (20-40% higher)
                final strikePrice = product.price * 1.35;
                final discountPercent = 25 + (product.id % 20);

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(productId: product.id),
                      ),
                    );
                  },
                  child: Container(
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.cardBorder, width: 0.8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        Expanded(
                          child: Center(
                            child: Hero(
                              tag: 'strip_prod_${product.id}',
                              child: Image.network(
                                product.image,
                                fit: BoxFit.contain,
                                errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image, size: 36),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Discount pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: AppColors.dealRed,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            'Up to $discountPercent% off',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '\$${strikePrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
