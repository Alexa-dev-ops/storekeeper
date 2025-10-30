import 'package:flutter/material.dart';
import 'package:storekeeper/database/db_helper.dart';
import 'package:storekeeper/models/product.dart';
import 'package:storekeeper/screens/add_edit_product.dart';
import 'package:storekeeper/screens/product_details_screen.dart';
import 'package:storekeeper/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final products = await DatabaseHelper.instance.getAllProducts();
    setState(() {
      _allProducts = products;
      _filteredProducts = products;
      _isLoading = false;
    });
  }

  void _filterProducts(String query) {
    final results =
        query.isEmpty
            ? _allProducts
            : _allProducts
                .where(
                  (p) => p.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
    setState(() => _filteredProducts = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterProducts,
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredProducts.isEmpty
                      ? const Center(child: Text('No products found.'))
                      : ListView.builder(
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ProductDetailsScreen(
                                        product: product,
                                      ),
                                ),
                              ).then((_) => _loadProducts());
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditProductScreen(),
            ),
          ).then((_) => _loadProducts());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
