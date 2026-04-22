// import 'package:flutter/material.dart';
// import 'package:aplikasi_elektronik_kelompok3/pages/admin/admin_profit.dart';
// import 'package:aplikasi_elektronik_kelompok3/pages/admin/admin_status.dart';
// import 'package:aplikasi_elektronik_kelompok3/widgets/admin_navbar.dart';
// import 'package:aplikasi_elektronik_kelompok3/main.dart';
// import 'package:aplikasi_elektronik_kelompok3/models/product_model.dart';

// class AdminHomePage extends StatefulWidget {
//   @override
//   _AdminHomePageState createState() => _AdminHomePageState();
// }

// class _AdminHomePageState extends State<AdminHomePage> {
//   int _selectedIndex = 0;
//   List<Product> products = [];

//   // Menyimpan halaman yang akan dirender
//   final List<Widget> pages = [];

//   // Fungsi untuk mengambil produk dari Supabase
//   Future<void> fetchProducts() async {
//     try {
//       products = [];
//       final response = await supabase.from('Produk').select();
//       final List data = response;
//       print(data);
//       setState(() {
//         products = data.map((item) => Product.fromMap(item)).toList();
//       });
//     } catch (error) {
//       print('Error: $error');
//     }
//   }

//   // Mengubah halaman yang ditampilkan saat item bottom navbar ditekan
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchProducts(); // Memanggil fetchProducts saat halaman pertama kali di-load
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Menunggu data produk selesai di-fetch
//     if (products.isEmpty) {
//       return Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     // Mengupdate pages setelah produk di-fetch
//     pages.clear();
//     pages.add(AdminProductPage(
//         products: products)); // Menambahkan AdminProductPage dengan data produk
//     pages.add(AdminStatusPage());
//     pages.add(AdminProfitPage());

//     return Scaffold(
//       body: pages[
//           _selectedIndex], // Menampilkan halaman yang dipilih berdasarkan index
//       bottomNavigationBar: AdminNavbar(
//         selectedIndex: _selectedIndex,
//         onTap: _onItemTapped, // Menangani tap pada navbar
//       ),
//     );
//   }
// }

// class AdminProductPage extends StatefulWidget {
//   final List<Product> products; // Menerima data produk sebagai parameter

//   AdminProductPage(
//       {required this.products}); // Konstruktor untuk menerima produk

//   @override
//   State<AdminProductPage> createState() => _AdminProductPageState();
// }

// class _AdminProductPageState extends State<AdminProductPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Product List',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.deepPurple,
//         elevation: 0,
//       ),
//       backgroundColor: Color(0xFFF3F4F9),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Tambahkan fungsi untuk menambah produk
//         },
//         backgroundColor: Colors.deepOrange,
//         child: Icon(Icons.add),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: GridView.builder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//             childAspectRatio: 0.75,
//           ),
//           itemCount: widget
//               .products.length, // Menggunakan widget.products untuk data produk
//           itemBuilder: (context, index) {
//             final product =
//                 widget.products[index]; // Mengakses produk dari widget
//             return Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   ClipRRect(
//                     borderRadius:
//                         BorderRadius.vertical(top: Radius.circular(16)),
//                     child: Image.network(
//                       product.imageUrl, // Mengakses imageUrl produk
//                       height: 120,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           product.name, // Mengakses nama produk
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           '\$${product.price}', // Mengakses harga produk
//                           style: TextStyle(
//                             color: Colors.grey[700],
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Spacer(),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 8.0, vertical: 4.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             // Fungsi untuk edit produk
//                           },
//                           icon: Icon(Icons.edit, color: Colors.blue),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             // Fungsi untuk delete produk
//                           },
//                           icon: Icon(Icons.delete, color: Colors.red),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:aplikasi_elektronik_kelompok3/pages/admin/admin_add.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/admin/admin_edit.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/admin/admin_profit.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/admin/admin_status.dart';
import 'package:aplikasi_elektronik_kelompok3/widgets/admin_navbar.dart';
import 'package:aplikasi_elektronik_kelompok3/main.dart';
import 'package:aplikasi_elektronik_kelompok3/models/product_model.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/login_page.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;
  List<Product> products = [];

  final List<Widget> _pages = [
    AdminProductPage(),
    AdminStatusPage(),
    AdminProfitPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: AdminNavbar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AdminProductPage extends StatefulWidget {
  @override
  State<AdminProductPage> createState() => _AdminProductPageState();
}

class _AdminProductPageState extends State<AdminProductPage> {
  List<Product> products = [];
  @override
  void initState() {
    super.initState();
    fetchProducts(); // Memanggil fetchProducts saat halaman pertama kali di-load
  }

  // Fungsi untuk mengambil produk dari Supabase
  Future<void> fetchProducts() async {
    try {
      products = [];
      final response = await supabase.from('Produk').select();
      final List data = response;
      setState(() {
        products = data.map((item) => Product.fromMap(item)).toList();
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  void deleteProduct(Product product) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Product'),
        content: Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      try {
        await supabase.from('Produk').delete().eq('id', product.id);
        setState(() {
          fetchProducts();
        });
        print('Product deleted successfully!');
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  void editProduct(Product product) async {
    final updatedProduct = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProductScreen(
          product: product,
          onEdit: (editedProduct) {
            setState(() {
              final index =
                  products.indexWhere((p) => p.id == editedProduct.id);
              if (index != -1) {
                products[index] = editedProduct;
              }
            });
          },
        ),
      ),
    );

    setState(() {
      fetchProducts();
    });
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(text: 'Are you sure you want to '),
                TextSpan(
                  text: 'log out?',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(child: const Text('Yes'), onPressed: signOut),
          ],
        );
      },
    );
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: _showLogoutDialog,
          ),
        ],
        backgroundColor: Colors.deepPurple, // Warna mewah
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF3F4F9),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddProductScreen(),
            ),
          );
          if (result == true) {
            setState(() {
              fetchProducts();
            });
          }
        },
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      product.imageUrl,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          product.price.toString(),
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            editProduct(product);
                          },
                          icon: Icon(Icons.edit, color: Colors.blue),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteProduct(product);
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
