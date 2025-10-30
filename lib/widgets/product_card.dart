import 'dart:io';

import 'package:flutter/material.dart';
import 'package:storekeeper/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading:
            product.imagePath != null
                ? CircleAvatar(
                  backgroundImage: FileImage(File(product.imagePath!)),
                )
                : CircleAvatar(child: Icon(Icons.inventory_2)),
        title: Text(product.name),
        subtitle: Text(
          'Qty: ${product.quantity} | ₦${product.price.toStringAsFixed(2)} ea',
        ),
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
