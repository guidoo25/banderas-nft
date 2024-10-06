import 'package:NFT/models/nft_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductNotifier extends StateNotifier<List<NFT>> {
  ProductNotifier() : super([]);
  List<NFT> productss = [];
  List<NFT> _productoss = [];

  String _searchQuery = '';

  void searchProducts(String query) {
    _searchQuery = query;
    state = state;
  }

  List<NFT> get products {
    if (_searchQuery.isEmpty) {
      return _productoss;
    } else {
      return _productoss
          .where((product) => product.description!
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  void addProduct(NFT product) {
    state = List.from(state)..add(product);
  }

  void removeProduct(String productId) {
    state = List.from(state)
      ..removeWhere((product) => product.nftId == productId);
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, List<NFT>>(
    (ref) => ProductNotifier());
