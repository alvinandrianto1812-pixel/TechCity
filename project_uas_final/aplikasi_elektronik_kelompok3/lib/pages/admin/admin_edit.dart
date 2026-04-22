import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:aplikasi_elektronik_kelompok3/models/product_model.dart';
import 'admin_home_page.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;
  final Function(Product) onEdit;

  EditProductScreen({required this.product, required this.onEdit});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _productName = '';
  String _productDescription = '';
  int _productPrice = 0;
  String? _selectedCategory;
  File? _selectedImage;
  bool _isLoading = false;
  String? _imageUrl;
  bool _isImageUpdated = false;
  int stok = 0; // Field untuk stok produk

  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _productName = widget.product.name;
    _productDescription = widget.product.description;
    _productPrice = widget.product.price;
    _selectedCategory = widget.product.category;
    _imageUrl = widget.product.imageUrl;
    stok = widget.product.stok; // Set nilai stok dari produk yang diedit
  }

  Future<void> _editProductInSupabase(Product product) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      // Jika gambar di-update, upload gambar baru
      if (_isImageUpdated && _selectedImage != null) {
        _imageUrl = await _uploadImageToSupabase(_selectedImage!);
      }

      // Siapkan data untuk update
      final Map<String, dynamic> updateData = {
        'nama': _productName,
        'desc': _productDescription,
        'harga': _productPrice,
        'category': _selectedCategory,
        'stok': stok, // Sertakan stok dalam data update
        'ImageUrl': _imageUrl, // Sertakan imageUrl, baik baru atau lama
      };

      // Update produk di Supabase
      await _supabase
          .from('Produk')
          .update(updateData)
          .eq('id', widget.product.id);

      Product editedProduct = Product(
        id: widget.product.id,
        name: _productName,
        description: _productDescription,
        price: _productPrice,
        imageUrl: _imageUrl ?? widget.product.imageUrl,
        category: _selectedCategory,
        stok: stok, // Pastikan stok terupdate
      );

      widget.onEdit(editedProduct);
    } catch (error) {
      print('Error: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
        _isImageUpdated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf3f4f9),
      appBar: AppBar(
        title: Text("Edit Product",
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                TextFormField(
                  initialValue: _productName,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                SizedBox(height: 15),

                // Description
                TextFormField(
                  initialValue: _productDescription,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                SizedBox(height: 15),

                // Price
                TextFormField(
                  initialValue: _productPrice.toString(),
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productPrice = int.parse(value!);
                  },
                ),
                SizedBox(height: 15),

                // Stok
                TextFormField(
                  initialValue: stok.toString(),
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                    stok = int.parse(value!);
                  },
                ),
                SizedBox(height: 15),

                // Category
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                      _selectedCategory = newValue;
                    });
                  },
                ),
                SizedBox(height: 20),

                // Image Display
                Center(
                  child: _selectedImage == null
                      ? Image.network(
                          _imageUrl ?? widget.product.imageUrl,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                                'https://via.placeholder.com/200');
                          },
                        )
                      : Image.file(
                          _selectedImage!,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image),
                    label: Text('Pick Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Save Button
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              Product editedProduct = Product(
                                id: widget.product.id,
                                name: _productName,
                                description: _productDescription,
                                price: _productPrice,
                                imageUrl: _imageUrl!,
                                category: _selectedCategory,
                                stok: stok, // Pastikan stok terupdate
                              );
                              _editProductInSupabase(editedProduct);
                              widget.onEdit(
                                  editedProduct); // Panggil callback onEdit
                              Navigator.of(context).pop(editedProduct);
                            }
                          },
                          icon: Icon(Icons.save),
                          label: Text('Save Changes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF56C26),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
