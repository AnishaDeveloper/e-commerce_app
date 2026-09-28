import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageController;
  String _selectedCategory = "men's clothing";

  final List<String> _defaultCategories = [
    "men's clothing",
    "women's clothing",
    "jewelery",
    "electronics"
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product?.title ?? '');
    _priceController = TextEditingController(
      text: widget.product != null ? widget.product!.price.toString() : '',
    );
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _imageController = TextEditingController(
      text: widget.product?.image ?? 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
    );
    if (widget.product != null && widget.product!.category.isNotEmpty) {
      _selectedCategory = widget.product!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;

    bool success;
    if (widget.product == null) {
      success = await productProvider.addProduct(
        title: _titleController.text.trim(),
        price: price,
        description: _descriptionController.text.trim(),
        image: _imageController.text.trim(),
        category: _selectedCategory,
      );
    } else {
      final updated = widget.product!.copyWith(
        title: _titleController.text.trim(),
        price: price,
        description: _descriptionController.text.trim(),
        image: _imageController.text.trim(),
        category: _selectedCategory,
      );
      success = await productProvider.updateProduct(updated);
    }

    if (mounted) {
      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.product == null ? 'Product added successfully!' : 'Product updated successfully!',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Operation failed: ${productProvider.errorMessage}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    final productProvider = Provider.of<ProductProvider>(context);

    final categories = {..._defaultCategories, ...productProvider.categories}
        .where((c) => c != 'all')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add New Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Product Title *'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter title' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Price (\$)',
                  prefixText: '\$ ',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter price';
                  if (double.tryParse(val.trim()) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: categories.contains(_selectedCategory) ? _selectedCategory : categories.first,
                decoration: const InputDecoration(labelText: 'Category'),
                items: categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat[0].toUpperCase() + cat.substring(1)),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter image url' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter description' : null,
              ),
              const SizedBox(height: 28),

              ElevatedButton(
                onPressed: productProvider.isLoading ? null : _save,
                child: productProvider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(isEditing ? 'Save Changes' : 'Create Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
