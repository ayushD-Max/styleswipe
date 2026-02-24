import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_cards/swipe_cards.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class SwipeScreen extends StatelessWidget {
  const SwipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Discover',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Obx(() {
        if (!controller.isSwipeInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.swipeItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.done_all_rounded,
                    size: 64,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "All Caught Up!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "You've explored all current products.",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchProducts(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Refresh Feed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    side: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.2),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: SwipeCards(
                matchEngine: controller.matchEngine,
                itemBuilder: (context, index) {
                  final product =
                      controller.swipeItems[index].content as Product;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProductCard(
                      product: product,
                      onTap: () =>
                          Get.to(() => ProductDetailScreen(product: product)),
                    ),
                  );
                },
                onStackFinished: () {
                  controller.swipeItems.clear();
                },
                itemChanged: (item, index) {},
                upSwipeAllowed: false,
                fillSpace: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SwipeActionButton(
                    icon: Icons.close_rounded,
                    color: Colors.red.shade400,
                    onPressed: () => controller.matchEngine.currentItem?.nope(),
                  ),
                  const SizedBox(width: 48),
                  _SwipeActionButton(
                    icon: Icons.favorite_rounded,
                    color: Colors.pink.shade400,
                    onPressed: () => controller.matchEngine.currentItem?.like(),
                    isPrimary: true,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _SwipeActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _SwipeActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            padding: EdgeInsets.all(isPrimary ? 20 : 16),
            child: Icon(icon, color: color, size: isPrimary ? 32 : 28),
          ),
        ),
      ),
    );
  }
}
