import 'package:flutter/material.dart';
import 'package:aplikasi_elektronik_kelompok3/models/product_model.dart';
import 'package:aplikasi_elektronik_kelompok3/main.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  ProductDetailPage({required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  double? averageRating;
  String userId = supabase.auth.currentUser!.id;
  int? totalSold;

  List<Map<String, dynamic>> reviews = [];

  // Fungsi untuk mengambil review dari Supabase
  Future<void> fetchReviews() async {
    final response = await supabase
        .from('review')
        .select('rating, review, Pelanggan(id, nama), order_items(isReviewed)')
        .eq('product_id', widget.product.id)
        .eq('order_items.isReviewed', true);

    if (response != null && response.isNotEmpty) {
      double totalRating = 0;
      int reviewCount = response.length;

      response.forEach((review) {
        // Ensure the rating is a double
        totalRating += (review['rating'] is int)
            ? (review['rating'] as int).toDouble()
            : review['rating'];
        reviews.add({
          'nama': review['Pelanggan']['nama'], // Mengambil nama dari Pelanggan
          'rating': review['rating'], // Mengambil rating
          'review': review['review'], // Mengambil isi review
        });
      });

      setState(() {
        averageRating = reviewCount > 0 ? (totalRating / reviewCount) : 0;
      });
    }
  }

  void _showAddToCartSplash(BuildContext context, String productName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        return AlertDialog(
          content: Row(
            children: [
              Icon(
                Icons.shopping_cart,
                color: Colors.green,
                size: 40,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$productName added to your cart!',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> addProductToCart(String userId, int id) async {
    try {
      await supabase
          .from('cart_items')
          .insert({'qty': 1, 'user_id': userId, 'product_id': id});
    } catch (e) {
      print('error in adding to cart : $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchReviews(); // Memanggil fungsi fetchReviews pada saat halaman pertama kali di-load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9E7F5), // Set background color here
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: Color(0xFF4A148C),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Gambar Produk
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black54, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Produk
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A148C),
                    ),
                  ),
                  SizedBox(height: 8),

                  // Harga Produk
                  Text(
                    widget.product.price.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 8),

                  // Rating dan Stok Produk
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          buildRatingStars(averageRating?.toDouble() ?? 0.0),
                          SizedBox(width: 8),
                          Text(
                            "${(averageRating ?? 0.0).toStringAsFixed(1)}",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Text(
                        "Stock: 10", // Contoh jumlah stok
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Deskripsi Produk
                  Text(
                    "Deskripsi Produk:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A148C),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 24),

                  // Tombol "Add to Cart"
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        addProductToCart(userId, widget.product.id);
                        _showAddToCartSplash(context, widget.product.name);
                      },
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.white, // Set the icon color to white
                      ),
                      label: Text(
                        "Add to Cart",
                        style: TextStyle(
                          color: Colors.white, // Set the text color to white
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4A148C),
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Bagian Review
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reviews",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A148C),
                    ),
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      print(review['nama']);
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.purple[100],
                            child: Text(
                              review['nama'][
                                  0], // Menampilkan huruf pertama dari username
                              style: TextStyle(color: Color(0xFF4A148C)),
                            ),
                          ),
                          title: Text(
                            review['nama'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildRatingStars(
                                  averageRating?.toDouble() ?? 0.0),
                              SizedBox(height: 4),
                              Text(review['review'] ?? 'No review'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membangun bintang rating
  Row buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      children: [
        for (int i = 0; i < fullStars; i++)
          Icon(
            Icons.star,
            size: 18,
            color: Colors.amber,
          ),
        if (hasHalfStar)
          Icon(
            Icons.star_half,
            size: 18,
            color: Colors.amber,
          ),
        for (int i = 0; i < emptyStars; i++)
          Icon(
            Icons.star_border,
            size: 18,
            color: Colors.grey,
          ),
      ],
    );
  }
}
