// import 'dart:ffi';
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'product_detail_page.dart';
// import 'package:aplikasi_elektronik_kelompok3/main.dart';
// import 'package:aplikasi_elektronik_kelompok3/models/product_model.dart';
// import 'package:aplikasi_elektronik_kelompok3/widgets/navbar_user.dart';

// class HomePage extends StatefulWidget {
//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int selectedIndex = 0;
//   final List<String> banners = [
//     'assets/banner1.png',
//     'assets/banner2.png',
//     'assets/banner3.png',
//     'assets/banner4.png',
//     'assets/banner5.png',
//   ];

//   List<Product> products = [];
//   String? selectedCategory;

//   void initState() {
//     super.initState();
//     fetchProducts();
//   }

//   Future<void> fetchProducts() async {
//     try {
//       products = [];
//       final response = await supabase.from('Produk').select();
//       final List data = response;
//       setState(() {
//         products = data.map((item) => Product.fromMap(item)).toList();
//       });
//     } catch (error) {
//       print('Error: $error');
//     }
//   }

//   // Filter products based on category and gender
//   List<Product> _getFilteredProducts() {
//     return products.where((product) {
//       bool matchesCategory =
//           (selectedCategory == null || product.category == selectedCategory);
//       return matchesCategory;
//     }).toList();
//   }

//   Future<double> fetchRating(Product product) async {
//     try {
//       final response = await supabase
//           .from('review')
//           .select(
//               'rating, review, Pelanggan(id, nama), order_items(isReviewed)')
//           .eq('product_id', product.id)
//           .eq('order_items.isReviewed', true);

//       if (response != null) {
//         double totalRating = 0;
//         int reviewCount = response.length;

//         response.forEach((review) {
//           totalRating += review['rating'];
//         });
//         return (reviewCount > 0 ? (totalRating / reviewCount) : 0);
//       }
//     } catch (e) {
//       print('Error fetch rating: $e');
//     }
//     return 0.0;
//   }

//   // Fetch products based on categories
//   List<Product> getExclusiveOffers() {
//     return _getFilteredProducts().take(1).toList();
//   }

//   List<Product> getBestSelling() {
//     return _getFilteredProducts().skip(13).take(4).toList();
//   }

//   Row buildRatingStars(double rating) {
//     int fullStars = rating.floor(); // Bintang penuh
//     bool hasHalfStar =
//         (rating - fullStars) >= 0.5; // Apakah ada setengah bintang
//     int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0); // Bintang kosong

//     return Row(
//       children: [
//         // Bintang penuh
//         for (int i = 0; i < fullStars; i++)
//           Icon(
//             Icons.star,
//             size: 14,
//             color: Colors.amber,
//           ),
//         // Setengah bintang
//         if (hasHalfStar)
//           Icon(
//             Icons.star_half,
//             size: 14,
//             color: Colors.amber,
//           ),
//         // Bintang kosong
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
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("TechCity",
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color(0xFFDAD5FB).withOpacity(0.9),
//                 Color(0xFFFFFFFF),
//               ],
//             ),
//           ),
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: [
//               // Drawer Header
//               DrawerHeader(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Color(0xFFDAD5FB).withOpacity(0.9),
//                       Color(0xFFFFFFFF),
//                     ],
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       'assets/logoname.png',
//                       height: 130,
//                       width: 130,
//                       fit: BoxFit.contain,
//                     ),
//                     SizedBox(height: 5),
//                   ],
//                 ),
//               ),

//               // ListTile untuk "Top Up Credit"
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

//               // ListTile untuk "History"
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

//               // ListTile untuk "About Us"
//               ListTile(
//                 leading: Icon(Icons.info_outline, color: Color(0xFF4A148C)),
//                 title: Text(
//                   "About Us",
//                   style: TextStyle(color: Color(0xFF4A148C)),
//                 ),
//                 onTap: () {
//                   Navigator.pushNamed(context, '/aboutus');
//                 },
//               ),

//               // ListTile untuk "Logout"
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

//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Carousel Banner
//             CarouselSlider(
//               items: banners.map((banner) {
//                 return Builder(
//                   builder: (BuildContext context) {
//                     return Container(
//                       width: MediaQuery.of(context).size.width,
//                       margin: EdgeInsets.symmetric(horizontal: 5.0),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12.0),
//                         image: DecorationImage(
//                           image: AssetImage(banner),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }).toList(),
//               options: CarouselOptions(
//                 height: 250.0,
//                 autoPlay: true,
//                 enlargeCenterPage: true,
//                 aspectRatio: 16 / 9,
//                 autoPlayInterval: Duration(seconds: 3),
//               ),
//             ),

//             // Exclusive Offer Section
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 "Exclusive Offers",
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF4A148C)),
//               ),
//             ),
//             buildProductGrid(getExclusiveOffers()),

//             // Best Selling Section
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 "Best Selling",
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF4A148C)),
//               ),
//             ),
//             buildProductGrid(getBestSelling()),
//           ],
//         ),
//       ),
//       // Add the BottomNavigationBar here
//       bottomNavigationBar: UserNavbar(
//         selectedIndex: selectedIndex,
//         onTap: (index) {
//           setState(() {
//             selectedIndex = index; // Update the selected index
//           });
//           if (index == 0) {
//             // Home Page (already on this page)
//           } else if (index == 1) {
//             Navigator.pushNamed(context, '/explore_page');
//           } else if (index == 2) {
//             Navigator.pushNamed(context, '/settings_page');
//           }
//         },
//       ),
//     );
//   }

//   Widget buildProductGrid(List<Product> products) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: products.length,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         mainAxisSpacing: 10,
//         crossAxisSpacing: 10,
//         childAspectRatio: 0.75,
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       itemBuilder: (context, index) {
//         final product = products[index];
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ProductDetailPage(product: product),
//               ),
//             );
//           },
//           child: Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//                   child: Image.network(
//                     product.imageUrl,
//                     height: 120,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         product.name,
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         product.description,
//                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         product.price.toString(),
//                         style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green),
//                       ),
//                       FutureBuilder<double>(
//                         future: fetchRating(product), // Menunggu hasil rating
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return Text(
//                                 'test'); // Menampilkan loading jika data belum tersedia
//                           } else if (snapshot.hasError) {
//                             return Text('Error: ${snapshot.error}');
//                           } else if (snapshot.hasData) {
//                             return buildRatingStars(
//                                 snapshot.data!); // Menampilkan rating bintang
//                           } else {
//                             return Text('No rating');
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Log Out"),
//           content: Text("Are you sure you want to log out?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text("No"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pushNamedAndRemoveUntil(
//                   context,
//                   '/login',
//                   (route) => false,
//                 );
//               },
//               child: Text("Yes"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'dart:ffi';
import 'package:aplikasi_elektronik_kelompok3/pages/user/history_page.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/login_page.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:aplikasi_elektronik_kelompok3/models/product_model.dart';
import 'package:aplikasi_elektronik_kelompok3/widgets/navbar_user.dart';
import 'product_detail_page.dart';
import 'package:aplikasi_elektronik_kelompok3/main.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/cart_page.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/explore_page.dart';
// import 'package:aplikasi_elektronik_kelompok3/pages/user/profile_page.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/aboutus_page.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/cart_tile.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/topup_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final List<String> banners = [
    'assets/banner1.png',
    'assets/banner2.png',
    'assets/banner3.png',
    'assets/banner4.png',
    'assets/banner5.png',
  ];

  List<Product> products = [];
  String? selectedCategory;
  bool isLoading = false; // Declare isLoading variable

  void initState() {
    super.initState();
    fetchProducts();
  }

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

  // Filter products based on category
  List<Product> _getFilteredProducts() {
    return products.where((product) {
      bool matchesCategory =
          (selectedCategory == null || product.category == selectedCategory);
      return matchesCategory;
    }).toList();
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

  // Get product lists
  List<Product> getExclusiveOffers() {
    return _getFilteredProducts().take(1).toList();
  }

  List<Product> getBestSelling() {
    return _getFilteredProducts().skip(13).take(4).toList();
  }

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

  // Drawer Item Widget
  Widget _buildDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap,
      Color iconColor = const Color.fromARGB(221, 59, 41, 93)}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, size: 30, color: iconColor),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(221, 59, 41, 93),
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        tileColor: const Color.fromARGB(255, 118, 0, 139),
        selectedTileColor: const Color(0xFF5f4296),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TechCity",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Color(0xFF4A148C),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () async {
              // Pindah ke halaman Cart
              await Navigator.pushNamed(context, '/cart');

              // Setelah kembali dari Cart, refresh produk
              fetchProducts();
            },
          )
        ],
      ),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Carousel Banner
                    CarouselSlider(
                      items: banners.map((banner) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                image: DecorationImage(
                                  image: AssetImage(banner),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 250.0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        autoPlayInterval: Duration(seconds: 3),
                      ),
                    ),

                    // Exclusive Offers Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Exclusive Offers",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A148C)),
                      ),
                    ),
                    buildProductGrid(getExclusiveOffers()),

                    // Best Selling Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Best Selling",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A148C)),
                      ),
                    ),
                    buildProductGrid(getBestSelling()),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildProductGrid(List<Product> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(product: product),
              ),
            );
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    product.imageUrl,
                    height: 120,
                    width: double.infinity,
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
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        product.description,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 4),
                      Text(
                        product.price.toString(),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Log Out"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: signOut,
              child: Text("Yes"),
            ),
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

  Widget _buildDrawer() {
    return Drawer(
      // Ganti backgroundColor dengan decoration
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFDAD5FB).withOpacity(0.9),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/logo.png'),
                          ),
                        ),
                      ),
                      SizedBox(height: 0),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Item-item drawer
              _buildDrawerItem(
                icon: Icons.add_card_rounded,
                text: 'Top Up Credit',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TopUpPage()));
                },
              ),
              _buildDrawerItem(
                icon: Icons.info,
                text: 'About Us',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutUsPage()));
                },
              ),
              _buildDrawerItem(
                icon: Icons.history,
                text: 'History',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OrdersPage()));
                },
              ),

              _buildDrawerItem(
                icon: Icons.logout,
                text: 'Logout',
                iconColor: Colors.redAccent,
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Format currency as per the existing function
  String formatCurrency(int price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (Match m) => '${m[1]}.')}';
  }
}
