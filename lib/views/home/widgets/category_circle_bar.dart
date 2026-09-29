import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CategoryCircleBar extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  const CategoryCircleBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  IconData _getIconForCategory(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('electronic')) return Icons.devices_other;
    if (cat.contains('jewel')) return Icons.diamond_outlined;
    if (cat.contains('men')) return Icons.male_outlined;
    if (cat.contains('women')) return Icons.female_outlined;
    if (cat == 'all') return Icons.grid_view_rounded;
    return Icons.category_outlined;
  }

  Color _getColorForCategory(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('electronic')) return const Color(0xFF1E88E5);
    if (cat.contains('jewel')) return const Color(0xFF8E24AA);
    if (cat.contains('men')) return const Color(0xFF00897B);
    if (cat.contains('women')) return const Color(0xFFE91E63);
    return AppColors.headerNavy;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 96,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedCategory == cat;
          final color = _getColorForCategory(cat);
          final title = cat == 'all'
              ? 'All'
              : cat
                  .split(' ')
                  .map((e) => e[0].toUpperCase() + e.substring(1))
                  .join(' ');

          return GestureDetector(
            onTap: () => onSelectCategory(cat),
            child: SizedBox(
              width: 64,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected ? color : color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.amazonOrange : Colors.transparent,
                        width: 2.2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    child: Icon(
                      _getIconForCategory(cat),
                      color: isSelected ? Colors.white : color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
