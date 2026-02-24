import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:swipe_cards/swipe_cards.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class ProductController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = Get.find<StorageService>();

  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxList<Product> likedProducts = <Product>[].obs;
  final RxList<int> likedIds = <int>[].obs;
  final RxList<int> dislikedIds = <int>[].obs;

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // Search and Filtering
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxList<String> categories = <String>['All'].obs;

  // For Swipe UI
  final RxList<SwipeItem> swipeItems = <SwipeItem>[].obs;
  late MatchEngine matchEngine;
  final RxBool isSwipeInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadStoredPreferences();
    fetchProducts();

    // Setup reactive filtering
    debounce(searchQuery, (_) => filterProducts(), time: 300.milliseconds);
    ever(selectedCategory, (_) => filterProducts());
  }

  void filterProducts() {
    var result = products.toList();

    // Category Filter
    if (selectedCategory.value != 'All') {
      result = result
          .where((p) => p.category == selectedCategory.value)
          .toList();
    }

    // Search Filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result
          .where(
            (p) =>
                p.title.toLowerCase().contains(query) ||
                p.description.toLowerCase().contains(query),
          )
          .toList();
    }

    filteredProducts.assignAll(result);
  }

  void loadStoredPreferences() {
    likedIds.assignAll(_storageService.getLikedProductIds());
    dislikedIds.assignAll(_storageService.getDislikedProductIds());
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      errorMessage('');
      final fetchedProducts = await _apiService.fetchProducts();
      products.assignAll(fetchedProducts);

      // Extract unique categories
      final uniqueCategories = products.map((p) => p.category).toSet().toList();
      categories.assignAll(['All', ...uniqueCategories]);

      // Initialize filtered list
      filteredProducts.assignAll(products);

      // Update likedProducts list from fetched components
      likedProducts.assignAll(
        products.where((p) => likedIds.contains(p.id)).toList(),
      );

      _initializeSwipeItems();
    } catch (e) {
      errorMessage('Failed to load products. Please check your connection.');
    } finally {
      isLoading(false);
    }
  }

  void _initializeSwipeItems() {
    // Only products NOT liked or disliked yet for the swipe deck
    final availableProducts = products
        .where((p) => !likedIds.contains(p.id) && !dislikedIds.contains(p.id))
        .toList();

    swipeItems.assignAll(
      availableProducts.map((product) {
        return SwipeItem(
          content: product,
          likeAction: () => likeProduct(product),
          nopeAction: () => dislikeProduct(product),
        );
      }).toList(),
    );

    matchEngine = MatchEngine(swipeItems: swipeItems);
    isSwipeInitialized(true);
  }

  void toggleLike(Product product) {
    HapticFeedback.mediumImpact();
    if (likedIds.contains(product.id)) {
      likedIds.remove(product.id);
      likedProducts.removeWhere((p) => p.id == product.id);
      _storageService.removeLikedProductId(product.id);
    } else {
      likedIds.add(product.id);
      likedProducts.add(product);
      _storageService.saveLikedProductId(product.id);

      // Remove from disliked if it was there
      if (dislikedIds.contains(product.id)) {
        dislikedIds.remove(product.id);
      }
    }
    // Refresh swipe cards if needed (optional, depends on UX)
  }

  void likeProduct(Product product) {
    HapticFeedback.heavyImpact();
    if (!likedIds.contains(product.id)) {
      likedIds.add(product.id);
      likedProducts.add(product);
      _storageService.saveLikedProductId(product.id);
      dislikedIds.remove(product.id);
    }
  }

  void dislikeProduct(Product product) {
    HapticFeedback.lightImpact();
    if (!dislikedIds.contains(product.id)) {
      dislikedIds.add(product.id);
      _storageService.saveDislikedProductId(product.id);

      if (likedIds.contains(product.id)) {
        likedIds.remove(product.id);
        likedProducts.removeWhere((p) => p.id == product.id);
        _storageService.removeLikedProductId(product.id);
      }
    }
  }

  bool isLiked(int id) => likedIds.contains(id);
}
