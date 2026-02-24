import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/history_controller.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'browser_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyController = Get.find<HistoryController>();
    final productController = Get.find<ProductController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Activity',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite_rounded, size: 18),
                    const SizedBox(width: 8),
                    const Text('Liked'),
                    const SizedBox(width: 4),
                    Obx(
                      () => Text(
                        '(${productController.likedProducts.length})',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.history_rounded, size: 18),
                    const SizedBox(width: 8),
                    const Text('Browsing'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () =>
                  _showClearConfirmation(context, historyController),
              icon: const Icon(Icons.delete_sweep_rounded, color: Colors.grey),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildLikedTab(productController),
            _buildBrowsingTab(historyController),
          ],
        ),
      ),
    );
  }

  Widget _buildLikedTab(ProductController controller) {
    return Obx(() {
      if (controller.likedProducts.isEmpty) {
        return _buildEmptyState(
          icon: Icons.favorite_border_rounded,
          message: 'No liked products yet',
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        itemCount: controller.likedProducts.length,
        itemBuilder: (context, index) {
          final product = controller.likedProducts[index];
          return ProductCard(
            product: product,
            isLiked: true,
            onTap: () => Get.to(() => ProductDetailScreen(product: product)),
            onLike: () => controller.toggleLike(product),
          );
        },
      );
    });
  }

  Widget _buildBrowsingTab(HistoryController controller) {
    return Obx(() {
      if (controller.history.isEmpty) {
        return _buildEmptyState(
          icon: Icons.history_rounded,
          message: 'No browsing history yet',
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: controller.history.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 24, indent: 64),
        itemBuilder: (context, index) {
          final entry = controller.history[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.language_rounded,
                color: Get.theme.colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text(
              entry.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy • hh:mm a').format(entry.timestamp),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                ),
              ],
            ),
            onTap: () =>
                Get.to(() => BrowserScreen(url: entry.url, title: entry.title)),
          );
        },
      );
    });
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmation(
    BuildContext context,
    HistoryController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Browsing History?'),
        content: const Text('This will delete all your visited URL history.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.clearHistory();
              Get.back();
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
