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
      color: AppColors.headerNavy,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Search Bar
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
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
                          hintText: 'Search ',
                          hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          prefixIcon: const Icon(Icons.search, color: AppColors.headerNavy),
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
                              const Icon(Icons.camera_alt_outlined, color: Colors.grey, size: 20),
                              const SizedBox(width: 8),
                              const Icon(Icons.mic_none, color: Colors.grey, size: 20),
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

            // Location Strip (Amazon style "Deliver to ...")
            Container(
              width: double.infinity,
              color: AppColors.locationBar,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Deliver to $firstName - $city $zip',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
