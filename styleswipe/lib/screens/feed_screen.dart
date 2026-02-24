import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(controller),
          _buildSearchAndFilters(controller),
          _buildProductList(controller),
        ],
      ),
    );
  }

  Widget _buildAppBar(ProductController controller) {
    return SliverAppBar(
      floating: true,
      snap: true,
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: false,
      title: Row(
        children: [
          Image.asset(
            'assets/logo.png',
            height: 32,
          ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
          const SizedBox(width: 12),
          const Text(
            'StyleSwipe',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              letterSpacing: -0.5,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => controller.fetchProducts(),
          icon: const Icon(Icons.refresh_rounded, color: Color(0xFF64748B)),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchAndFilters(ProductController controller) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (val) => controller.searchQuery.value = val,
                decoration: InputDecoration(
                  hintText: 'Search style...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: Obx(
                () => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final cat = controller.categories[index];
                    return Obx(() {
                      final isSelected =
                          controller.selectedCategory.value == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat.capitalizeFirst!),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected)
                              controller.selectedCategory.value = cat;
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          checkmarkColor: Theme.of(context).colorScheme.primary,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade600,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.2)
                                  : Colors.grey.shade200,
                            ),
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(ProductController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.errorMessage.isNotEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(controller.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchProducts(),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.filteredProducts.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                const Text('No products found matching your search.'),
              ],
            ),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final product = controller.filteredProducts[index];
            return Obx(
              () =>
                  ProductCard(
                        product: product,
                        isLiked: controller.isLiked(product.id),
                        onTap: () =>
                            Get.to(() => ProductDetailScreen(product: product)),
                        onLike: () => controller.toggleLike(product),
                        onDislike: () => controller.dislikeProduct(product),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: (index * 50).ms)
                      .moveY(begin: 20, end: 0),
            );
          }, childCount: controller.filteredProducts.length),
        ),
      );
    });
  }
}
