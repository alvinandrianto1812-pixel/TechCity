// import 'package:flutter/material.dart';
// import 'product_detail_page.dart';

// class ExplorePage extends StatefulWidget {
//   @override
//   _ExplorePageState createState() => _ExplorePageState();
// }

// class _ExplorePageState extends State<ExplorePage> {
//   final List<Map<String, dynamic>> categories = [
//     {
//       "name": "Laptops",
//       "products": [
//         {
//           "name": "Laptop A",
//           "description": "High performance laptop",
//           "price": "Rp 10.000.000",
//           "rating": 4.5,
//           "image": "assets/logo.png",
//         },
//         {
//           "name": "Laptop B",
//           "description": "Portable and powerful",
//           "price": "Rp 8.500.000",
//           "rating": 5.0,
//           "image": "assets/logo.png",
//         },
//       ],
//     },
//     {
//       "name": "Smartphones",
//       "products": [
//         {
//           "name": "Smartphone X",
//           "description": "Latest smartphone model",
//           "price": "Rp 5.000.000",
//           "rating": 4.9,
//           "image": "assets/logo.png",
//         },
//         {
//           "name": "Smartphone Y",
//           "description": "Affordable and reliable",
//           "price": "Rp 3.500.000",
//           "rating": 4.0,
//           "image": "assets/logo.png",
//         },
//       ],
//     },
//     {
//       "name": "Televisi",
//       "products": [
//         {
//           "name": "Televisi Ultra HD",
//           "description": "4K Ultra HD with vibrant colors",
//           "price": "Rp 7.000.000",
//           "rating": 5.0,
//           "image": "assets/logo.png",
//         },
//         {
//           "name": "Televisi OLED",
//           "description": "High contrast OLED display",
//           "price": "Rp 10.000.000",
//           "rating": 4.8,
//           "image": "assets/logo.png",
//         },
//       ],
//     },
//     {
//       "name": "Smartwatch",
//       "products": [
//         {
//           "name": "Smartwatch Pro",
//           "description": "Smart and stylish",
//           "price": "Rp 3.000.000",
//           "rating": 4.9,
//           "image": "assets/logo.png",
//         },
//         {
//           "name": "Smartwatch Fit",
//           "description": "Perfect for fitness tracking",
//           "price": "Rp 2.500.000",
//           "rating": 4.5,
//           "image": "assets/logo.png",
//         },
//       ],
//     },
//     {
//       "name": "Tablet",
//       "products": [
//         {
//           "name": "Tablet Z",
//           "description": "Perfect for entertainment",
//           "price": "Rp 4.500.000",
//           "rating": 4.9,
//           "image": "assets/logo.png",
//         },
//         {
//           "name": "Tablet Pro",
//           "description": "High performance tablet",
//           "price": "Rp 6.000.000",
//           "rating": 4.6,
//           "image": "assets/logo.png",
//         },
//       ],
//     },
//     {
//       "name": "Console",
//       "products": [
//         {
//           "name": "Game Console X",
//           "description": "High performance gaming",
//           "price": "Rp 8.000.000",
//           "rating": 5.0,
//           "image": "assets/logo.png",
//         },
//         {
//           "name": "Game Console Y",
//           "description": "Compact and affordable",
//           "price": "Rp 5.500.000",
//           "rating": 4.3,
//           "image": "assets/logo.png",
//         },
//       ],
//     },
//   ];

//   String searchQuery = ""; // Variabel untuk kata kunci pencarian

//   Row buildRatingStars(double rating) {
//     int fullStars = rating.floor();
//     bool hasHalfStar = (rating - fullStars) >= 0.5;
//     int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

//     return Row(
//       children: [
//         for (int i = 0; i < fullStars; i++)
//           Icon(
//             Icons.star,
//             size: 14,
//             color: Colors.amber,
//           ),
//         if (hasHalfStar)
//           Icon(
//             Icons.star_half,
//             size: 14,
//             color: Colors.amber,
//           ),
//         for (int i = 0; i < emptyStars; i++)
//           Icon(
//             Icons.star_border,
//             size: 14,
//             color: Colors.grey,
//           ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Filter kategori dan produk berdasarkan pencarian
//     final filteredCategories = categories
//         .map((category) {
//           final filteredProducts = category["products"]
//               .where((product) => product["name"]
//                   .toString()
//                   .toLowerCase()
//                   .contains(searchQuery.toLowerCase()))
//               .toList();
//           return {
//             "name": category["name"],
//             "products": filteredProducts,
//           };
//         })
//         .where((category) => category["products"].isNotEmpty)
//         .toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "TechCity",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Color(0xFF4A148C),
//         centerTitle: true,
//         iconTheme: IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.shopping_cart),
//             onPressed: () {
//               Navigator.pushNamed(context, '/cart'); // Navigasi ke CartPage
//             },
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: Container(
//           color: Color(0xFFFDF5E6),
//           child: ListView(
//             children: [
//               DrawerHeader(
//                 decoration: BoxDecoration(color: Color(0xFFFDF5E6)),
//                 child: Center(
//                   child: Column(
//                     children: [
//                       Image.asset(
//                         'assets/logoname.png',
//                         height: 130,
//                         width: 130,
//                         fit: BoxFit.contain,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               ListTile(
//                 leading: Icon(Icons.account_balance_wallet,
//                     color: Color(0xFF4A148C)),
//                 title: Text(
//                   "Top Up Credit",
//                   style: TextStyle(color: Color(0xFF4A148C)),
//                 ),
//                 onTap: () {
//                   Navigator.pushNamed(context, '/topup');
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.history, color: Color(0xFF4A148C)),
//                 title: Text(
//                   "History",
//                   style: TextStyle(color: Color(0xFF4A148C)),
//                 ),
//                 onTap: () {
//                   Navigator.pushNamed(context, '/history');
//                 },
//               ),
//               ListTile(
//                   leading: Icon(Icons.info_outline,
//                       color: Color(0xFF4A148C)), // Ikon About Us
//                   title: Text(
//                     "About Us",
//                     style: TextStyle(color: Color(0xFF4A148C)),
//                   ),
//                   onTap: () {
//                     Navigator.pushNamed(context, '/aboutus');
//                   }),
//               ListTile(
//                 leading: Icon(Icons.logout, color: Colors.red),
//                 title: Text(
//                   "Logout",
//                   style: TextStyle(color: Colors.red),
//                 ),
//                 onTap: () {
//                   _showLogoutDialog(context);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Widget Pencarian
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: (value) {
//                 setState(() {
//                   searchQuery = value;
//                 });
//               },
//               decoration: InputDecoration(
//                 prefixIcon: Icon(Icons.search),
//                 hintText: "Search products here",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: EdgeInsets.all(10.0),
//               itemCount: filteredCategories.length,
//               itemBuilder: (context, index) {
//                 final category = filteredCategories[index];
//                 return Card(
//                   elevation: 4,
//                   margin: EdgeInsets.only(bottom: 16.0),
//                   child: ExpansionTile(
//                     title: Text(
//                       category["name"],
//                       style: TextStyle(
//                         fontSize: 25,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF4A148C),
//                       ),
//                     ),
//                     children: category["products"].map<Widget>((product) {
//                       return Card(
//                         elevation: 2,
//                         margin:
//                             EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: ListTile(
//                           contentPadding: EdgeInsets.all(12.0),
//                           leading: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.asset(
//                               product["image"],
//                               width: 60,
//                               height: 60,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           title: Text(
//                             product["name"],
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Color.fromARGB(255, 104, 84, 129),
//                             ),
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(height: 4),
//                               Text(
//                                 product["description"],
//                                 style: TextStyle(color: Colors.grey[700]),
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 product["price"],
//                                 style: TextStyle(
//                                   color: Colors.green[700],
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               buildRatingStars(product["rating"]),
//                             ],
//                           ),
//                           trailing: Icon(
//                             Icons.arrow_forward_ios,
//                             color: Color(0xFF4A148C),
//                           ),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     ProductDetailPage(product: product),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void _showLogoutDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("Log Out"),
//         content: Text("Are you sure you want to log out?"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text("No"),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pushNamedAndRemoveUntil(
//                 context,
//                 '/login',
//                 (route) => false,
//               );
//             },
//             child: Text("Yes"),
//           ),
//         ],
//       );
//     },
//   );
// }
import 'package:aplikasi_elektronik_kelompok3/pages/user/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:aplikasi_elektronik_kelompok3/widgets/navbar_user.dart';
import 'package:aplikasi_elektronik_kelompok3/models/product_model.dart';
import 'product_detail_page.dart';
import 'package:aplikasi_elektronik_kelompok3/main.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int selectedIndex = 1;
  // To store categories and products
  List<Product> products = [];
  String searchQuery = ""; // For search filtering

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Load products from Supabase
  }

  // Fetch products from Supabase
  Future<void> fetchProducts() async {
    try {
      products = [];
      final response = await supabase.from('Produk').select().gt('stok', 0);
      final List data = response;
      setState(() {
        products = data.map((item) => Product.fromMap(item)).toList();
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  // Build rating stars based on rating value
  Row buildRatingStars(double rating) {
    int fullStars = rating.floor(); // Full stars
    bool hasHalfStar = (rating - fullStars) >= 0.5; // Half star
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0); // Empty stars

    return Row(
      children: [
        // Full stars
        for (int i = 0; i < fullStars; i++)
          Icon(Icons.star, size: 14, color: Colors.amber),
        // Half star
        if (hasHalfStar) Icon(Icons.star_half, size: 14, color: Colors.amber),
        // Empty stars
        for (int i = 0; i < emptyStars; i++)
          Icon(Icons.star_border, size: 14, color: Colors.grey),
      ],
    );
  }

  Future<double> fetchRating(Product product) async {
    try {
      final response = await supabase
          .from('review')
          .select(
              'rating, review, Pelanggan(id, nama), order_items(isReviewed)')
          .eq('product_id', product.id)
          .eq('order_items.isReviewed', true);

      if (response != null) {
        double totalRating = 0;
        int reviewCount = response.length;

        response.forEach((review) {
          totalRating += review['rating'];
        });
        return (reviewCount > 0 ? (totalRating / reviewCount) : 0);
      }
    } catch (e) {
      print('Error fetch rating: $e');
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    // Group products by category
    final Map<String?, List<Product>> groupedProducts = {};
    for (var product in products) {
      if (groupedProducts[product.category] == null) {
        groupedProducts[product.category] = [];
      }
      groupedProducts[product.category]?.add(product);
    }

    // Filter products based on search query
    final filteredProducts = products
        .where((product) =>
            product.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Color(0xFFebeaf6), // Set background color here
      appBar: AppBar(
        title: Text("Explore Products",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF4A148C),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                child: Center(
                    child: Image.asset('assets/logoname.png',
                        height: 130, width: 130))),
            ListTile(
                title: Text("Top Up Credit"),
                onTap: () => Navigator.pushNamed(context, '/topup')),
            ListTile(
                title: Text("History"),
                onTap: () => Navigator.pushNamed(context, '/history')),
            ListTile(
                title: Text("About Us"),
                onTap: () => Navigator.pushNamed(context, '/aboutus')),
            ListTile(
                title: Text("Logout"), onTap: () => _showLogoutDialog(context)),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search products here",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: groupedProducts.length,
              itemBuilder: (context, index) {
                final category = groupedProducts.keys.toList()[index];
                final categoryProducts = groupedProducts[category];

                return Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: ExpansionTile(
                    title: Text(
                      category as String,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A148C),
                      ),
                    ),
                    children: categoryProducts?.map<Widget>((product) {
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(12.0),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(product.imageUrl,
                                    width: 60, height: 60, fit: BoxFit.cover),
                              ),
                              title: Text(
                                product.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A148C),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(product.description,
                                      style:
                                          TextStyle(color: Colors.grey[700])),
                                  SizedBox(height: 4),
                                  Text("Rp ${product.price}",
                                      style: TextStyle(
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.bold)),
                                  FutureBuilder<double>(
                                    future: fetchRating(product),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else if (snapshot.hasData) {
                                        return buildRatingStars(snapshot.data!);
                                      } else {
                                        return Text('No rating');
                                      }
                                    },
                                  ),
                                ],
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: Color(0xFF4A148C)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailPage(product: product),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList() ??
                        [],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Log Out"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("No")),
            TextButton(onPressed: () => signOut, child: Text("Yes")),
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
}
