import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:aplikasi_elektronik_kelompok3/models/product_model.dart';
import 'admin_home_page.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _productName = '';
  String _productDescription = '';
  int _productPrice = 0;
  int _productStock = 0; // Add stock variable
  String? _selectedCategory;
  File? _selectedImage; // This will store the selected image
  bool _isLoading = false;

  // Supabase client
  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  Future<void> _addProductToSupabase(Product product) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await _uploadImageToSupabase(_selectedImage!);
      }
      final tempId = await _supabase
          .from('Produk')
          .select('id')
          .order('id', ascending: false)
          .limit(1)
          .single();

      final response = await _supabase
          .from('Produk')
          .insert({
            'id': tempId['id'] + 1,
            'nama': product.name,
            'desc': product.description,
            'harga': product.price,
            'category': product.category.toString().split('.').last,
            'stok': product.stok, // Add stock to the insert
            'ImageUrl': imageUrl,
          })
          .select()
          .single();

      if (response != null) {
        print('Product added successfully!');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _uploadImageToSupabase(File image) async {
    try {
      String fileName = const Uuid().v4() + extension(image.path);

      final storageResponse = await _supabase.storage
          .from('product-images')
          .upload(fileName, image);

      if (storageResponse != null) {
        final String publicUrl =
            _supabase.storage.from('product-images').getPublicUrl(fileName);
        print('Image uploaded: $publicUrl');
        return publicUrl;
      } else {
        print('Image upload failed');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf3f4f9),
      appBar: AppBar(
        title: Text("Add New Product",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFFFBEF),
            )),
        backgroundColor: const Color(0xFF673ab7),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: Icon(Icons.edit),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productName = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productDescription = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productPrice = int.parse(value!);
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Stock Quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: Icon(Icons.production_quantity_limits),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null) {
                      return 'Please enter a valid stock quantity';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productStock = int.parse(value!);
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  hint: Text('Select Category'),
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: [
                    'Smartphone',
                    'Laptop',
                    'Television',
                    'Console',
                    'Smartwatch',
                    'Tablet'
                  ].map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue; // Reset subcategory
                    });
                  },
                ),
                SizedBox(height: 16),
                _selectedImage == null
                    ? Text('No image selected.')
                    : Image.file(_selectedImage!, height: 200),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Choose Image',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.green,
                  ),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            Product newProduct = Product(
                              id: 0,
                              name: _productName,
                              description: _productDescription,
                              price: _productPrice,
                              imageUrl: '',
                              category: _selectedCategory,
                              stok: _productStock, // Add stock to the product
                            );

                            _addProductToSupabase(newProduct).then((_) {
                              if (mounted) {
                                Navigator.pop(context, true);
                              }
                            });
                          }
                        },
                        child: Text('Add Product',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Color(0xFFF56C26),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
