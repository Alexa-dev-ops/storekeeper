// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:storekeeper/database/db_helper.dart';
import 'package:storekeeper/models/product.dart';
import 'package:storekeeper/utils/image_picker_helper.dart';
import 'package:storekeeper/widgets/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _quantity;
  late String _price;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _name = widget.product?.name ?? '';
    _quantity = widget.product?.quantity.toString() ?? '';
    _price = widget.product?.price.toString() ?? '';
    _imagePath = widget.product?.imagePath;
  }

  Future<void> _pickImage(ImageSource source) async {
    final path = await ImagePickerHelper.pickImage(source);
    if (path != null) {
      setState(() {
        _imagePath = path;
      });
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id,
        name: _name,
        quantity: int.tryParse(_quantity) ?? 0,
        price: double.tryParse(_price) ?? 0.0,
        imagePath: _imagePath,
        addedOn: widget.product?.addedOn ?? DateTime.now(),
      );

      try {
        final dbHelper = DatabaseHelper();

        if (widget.product == null) {
          print('Creating new product...');
          await dbHelper.createProduct(product);
          print('Product created!');
        } else {
          print('✏️ Updating product...');
          await dbHelper.updateProduct(product);
          print('Product updated!');
        }

        Navigator.pop(context, true);
      } catch (e) {
        print('Save failed: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save product: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.product == null ? 'Add New Product' : 'Edit Product',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE UPLOAD
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    _imagePath == null
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Add product image',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tap to choose photo from library',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 8,
                                ),
                              ),
                              child: Text('Upload Image'),
                            ),
                          ],
                        )
                        : Stack(
                          children: [
                            Image.file(
                              File(_imagePath!),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                onPressed:
                                    () => setState(() => _imagePath = null),
                                icon: Icon(Icons.close, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
              ),
              SizedBox(height: 24),

              // PRODUCT NAME
              TextFormField(
                decoration: InputDecoration(labelText: 'Product Name'),
                initialValue: _name,
                onChanged: (v) => _name = v,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16),

              // QUANTITY & PRICE
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                      initialValue: _quantity,
                      onChanged: (v) => _quantity = v,
                      validator:
                          (v) =>
                              v!.isEmpty || int.tryParse(v) == null
                                  ? 'Invalid number'
                                  : null,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      initialValue: _price,
                      onChanged: (v) => _price = v,
                      validator:
                          (v) =>
                              v!.isEmpty || double.tryParse(v) == null
                                  ? 'Invalid price'
                                  : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),

              // SAVE & CANCEL BUTTONS
              ElevatedButton(
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  widget.product == null ? 'Save Product' : 'Update Product',
                ),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
