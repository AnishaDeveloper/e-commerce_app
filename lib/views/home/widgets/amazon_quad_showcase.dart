import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/product.dart';
import '../../products/product_detail_screen.dart';

class AmazonQuadShowcase extends StatelessWidget {
  final String title;
  final List<Product> products;
  final VoidCallback onSeeMore;

  const AmazonQuadShowcase({
    super.key,
    required this.title,
    required this.products,
    required this.onSeeMore,
  });

  @override
  Widget build(BuildContext context) {
    if (products.length < 4) return const SizedBox.shrink();
    final items = products.take(4).toList();

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // 2x2 Grid of products
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final product = items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(productId: product.id),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: Image.network(
                            product.image,
                            fit: BoxFit.contain,
                            errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'From ₹${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 11, color: AppColors.discountGreen, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onSeeMore,
            child: const Text(
              'Explore more deals',
              style: TextStyle(color: AppColors.linkBlue, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
