// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:storekeeper/database/db_helper.dart';
import 'package:storekeeper/models/product.dart';
import 'package:storekeeper/screens/add_edit_product.dart';

import 'dart:io';

import 'package:storekeeper/widgets/custom_app_bar.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Product Details'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child:
                  product.imagePath != null
                      ? Image.file(File(product.imagePath!), fit: BoxFit.cover)
                      : Center(
                        child: Icon(Icons.image, size: 64, color: Colors.grey),
                      ),
            ),
            SizedBox(height: 24),

            // TITLE
            Text(
              product.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8),
            Text('SKU: ${product.id}', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 24),

            // DETAILS GRID
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'In Stock',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text('${product.quantity} Units'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text('₦${product.price.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text('Added On', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(product.addedOn.toLocal().toString().split(' ')[0]),

            Spacer(),

            // EDIT & DELETE BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  AddEditProductScreen(product: product),
                        ),
                      ).then((_) {
                        Navigator.pop(context, true);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 2, 51, 92),
                    ),
                    child: Text('Edit Product'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await DatabaseHelper.instance.deleteProduct(product.id!);
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[300],
                    ),
                    child: Text('Delete Product'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
