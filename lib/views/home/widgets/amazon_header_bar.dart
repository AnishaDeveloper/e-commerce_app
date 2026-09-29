import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';

class AmazonHeaderBar extends StatelessWidget {
  final AuthProvider authProvider;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchSubmitted;

  const AmazonHeaderBar({
    super.key,
    required this.authProvider,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final user = authProvider.currentUser;
    final city = user?.address.city.isNotEmpty == true ? user!.address.city : 'New York';
    final zip = user?.address.zipcode.isNotEmpty == true ? user!.address.zipcode : '10001';
    final firstName = user?.name.firstname.isNotEmpty == true ? user!.name.firstname : 'Customer';

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // White container with clean Search Bar matching reference image
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300, width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: onSearchChanged,
                      onSubmitted: (_) => onSearchSubmitted(),
                      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade700, size: 22),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (searchController.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                                onPressed: () {
                                  searchController.clear();
                                  onSearchChanged('');
                                },
                              ),
                            Icon(Icons.camera_alt_outlined, color: Colors.grey.shade600, size: 20),
                            const SizedBox(width: 8),
                            Icon(Icons.mic_none, color: Colors.grey.shade600, size: 20),
                            const SizedBox(width: 10),
                          ],
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Location Strip ("Deliver to ...")
          Container(
            width: double.infinity,
            color: const Color(0xFFC7EDE8), // Soft cyan/teal tint matching Amazon India
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: Colors.black87),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Deliver to $firstName - $city $zip',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black87),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
