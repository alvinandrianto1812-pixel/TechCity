// import 'package:flutter/material.dart';

// class HistoryPage extends StatefulWidget {
//   @override
//   _HistoryPageState createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   final List<Map<String, dynamic>> historyItems = [
//     {
//       "id": 5,
//       "name": "Large Pizza",
//       "status": "Processing",
//       "description": "Pizza : Pepperoni Pizza",
//       "quantity": 1,
//       "price": 180000,
//       "rating": 0,
//       "review": "",
//     },
//     {
//       "id": 6,
//       "name": "Personal Pizza",
//       "status": "Delivering",
//       "description": "Pizza : Pepperoni Pizza",
//       "quantity": 2,
//       "price": 120000,
//       "rating": 0,
//       "review": "",
//     },
//     {
//       "id": 7,
//       "name": "Large Pizza",
//       "status": "Done",
//       "description": "Pizza : Pepperoni Pizza",
//       "quantity": 1,
//       "price": 180000,
//       "rating": 0,
//       "review": "",
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF5F5F5),
//       appBar: AppBar(
//         title: Text("Orders History"),
//         backgroundColor: Color(0xFF4A148C),
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: Colors.white,
//           labelColor: Colors.white,
//           unselectedLabelColor: Colors.grey[400],
//           labelStyle: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//           ),
//           unselectedLabelStyle: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.normal,
//           ),
//           tabs: [
//             Tab(text: "All"),
//             Tab(text: "Processing"),
//             Tab(text: "Delivering"),
//             Tab(text: "Done"),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           buildOrderList("All"),
//           buildOrderList("Processing"),
//           buildOrderList("Delivering"),
//           buildOrderList("Done"),
//         ],
//       ),
//     );
//   }

//   Widget buildOrderList(String filter) {
//     final filteredItems = filter == "All"
//         ? historyItems
//         : historyItems.where((item) => item["status"] == filter).toList();

//     if (filteredItems.isEmpty) {
//       return Center(
//         child: Text(
//           "No orders in this category.",
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.grey,
//             fontStyle: FontStyle.italic,
//           ),
//         ),
//       );
//     }

//     return ListView.builder(
//       itemCount: filteredItems.length,
//       itemBuilder: (context, index) {
//         final item = filteredItems[index];
//         Color statusColor;

//         switch (item["status"]) {
//           case "Processing":
//             statusColor = Colors.orange;
//             break;
//           case "Delivering":
//             statusColor = Colors.blue;
//             break;
//           case "Done":
//             statusColor = Colors.green;
//             break;
//           default:
//             statusColor = Colors.grey;
//         }

//         return Container(
//           margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           padding: EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             color: statusColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12.0),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.3),
//                 blurRadius: 6.0,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Status: ${item["status"]}",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: statusColor,
//                     ),
//                   ),
//                   Text(
//                     "Order ID: ${item["id"]}",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                 ],
//               ),
//               Divider(color: statusColor),
//               SizedBox(height: 8),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8.0),
//                     child: Image.asset(
//                       'assets/logo.png',
//                       height: 60,
//                       width: 60,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           item["name"],
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           item["description"],
//                           style:
//                               TextStyle(fontSize: 14, color: Colors.grey[700]),
//                         ),
//                         Text(
//                           "Qty: ${item["quantity"]}",
//                           style:
//                               TextStyle(fontSize: 14, color: Colors.grey[700]),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Text(
//                     formatCurrency(item["price"]),
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[800],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 12),
//               if (item["status"] == "Done")
//                 ElevatedButton(
//                   onPressed: () {
//                     _showReviewDialog(context, item);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                   child: Text(
//                     item["review"].isEmpty ? "Review Product" : "See Review",
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showReviewDialog(BuildContext context, Map<String, dynamic> item) {
//     double tempRating =
//         item["rating"].toDouble(); // Gunakan sementara untuk interaksi langsung
//     TextEditingController reviewController =
//         TextEditingController(text: item["review"]);

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
//       ),
//       builder: (_) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Padding(
//               padding: EdgeInsets.fromLTRB(
//                   16.0, 16.0, 16.0, MediaQuery.of(context).viewInsets.bottom),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Rate and Review",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(5, (index) {
//                       return IconButton(
//                         onPressed: () {
//                           // Perbarui rating langsung di modal
//                           setModalState(() {
//                             tempRating = index + 1.0;
//                           });
//                         },
//                         icon: Icon(
//                           Icons.star,
//                           color:
//                               index < tempRating ? Colors.amber : Colors.grey,
//                           size: 32, // Ukuran bintang
//                         ),
//                       );
//                     }),
//                   ),
//                   TextField(
//                     controller: reviewController,
//                     decoration: InputDecoration(
//                       labelText: "Write your review",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Simpan nilai rating dan review ke item
//                       setState(() {
//                         item["rating"] = tempRating;
//                         item["review"] = reviewController.text;
//                       });

//                       // Respon berdasarkan rating
//                       _showRatingResponse(context, tempRating);

//                       Navigator.pop(context);
//                     },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orange),
//                     child: Text("Done"),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

// // Fungsi untuk menampilkan respon berdasarkan rating
//   void _showRatingResponse(BuildContext context, double rating) {
//     String message;
//     IconData icon;
//     Color iconColor;
//     Color backgroundColor;
//     Color textColor = Colors.white; // Warna teks yang selalu terlihat jelas

//     if (rating <= 2) {
//       message = "We're sorry to hear that! How can we improve?";
//       icon = Icons.sentiment_dissatisfied;
//       iconColor = Colors.red;
//       backgroundColor = Colors.red.shade700; // Latar merah untuk rating rendah
//     } else if (rating <= 4) {
//       message = "Thank you for your feedback!";
//       icon = Icons.sentiment_satisfied;
//       iconColor = Colors.amber;
//       backgroundColor =
//           Colors.orange.shade600; // Latar oranye untuk rating menengah
//     } else {
//       message = "Thank you! We're glad you loved it!";
//       icon = Icons.sentiment_very_satisfied;
//       iconColor = Colors.green;
//       backgroundColor =
//           Colors.green.shade700; // Latar hijau untuk rating tinggi
//     }

//     // Menampilkan SnackBar
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(icon, color: iconColor),
//             SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 message,
//                 style: TextStyle(fontSize: 16, color: textColor), // Teks putih
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: backgroundColor,
//         behavior: SnackBarBehavior.floating,
//         duration: Duration(seconds: 3),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//       ),
//     );
//   }

// // Fungsi untuk menampilkan SnackBar
//   void _showSnackbar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.amber,
//         behavior: SnackBarBehavior.floating,
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }
// }

// String formatCurrency(int price) {
//   return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (Match m) => '${m[1]}.')}';
// }

import 'package:flutter/material.dart';
import 'package:aplikasi_elektronik_kelompok3/main.dart';
import 'review.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String userId = supabase.auth.currentUser!.id;
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchOrders();
  }

  // Function to fetch orders from Supabase
  Future<void> fetchOrders() async {
    try {
      var query = supabase
          .from('orders')
          .select(
              '*, order_items(*, Produk(id, nama, desc, harga, category, ImageUrl))')
          .eq('user_id', userId);

      final response = await query;
      setState(() {
        orders = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'processing':
        return Colors.orange;
      case 'delivering':
        return Colors.blue;
      case 'done':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Orders History',
          style: TextStyle(
            color: const Color(0xFFFFFBEF),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF4A148C),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[400],
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: "All"),
            Tab(text: "Processing"),
            Tab(text: "Delivering"),
            Tab(text: "Done"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildOrderList("all"),
          buildOrderList("processing"),
          buildOrderList("delivering"),
          buildOrderList("done"),
        ],
      ),
    );
  }

  Widget buildOrderList(String statusFilter) {
    final filteredOrders = statusFilter == 'all'
        ? orders
        : orders.where((order) => order['status'] == statusFilter).toList();

    if (filteredOrders.isEmpty) {
      return Center(
        child: Text(
          "No orders found.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        final orderItems = order['order_items'];
        final status = order['status'];

        Map<String, List<Map<String, dynamic>>> itemsByCategory = {};
        for (var item in orderItems) {
          final category = item['Produk']['category'];
          if (!itemsByCategory.containsKey(category)) {
            itemsByCategory[category] = [];
          }
          itemsByCategory[category]!.add(item);
        }

        return Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: getStatusColor(status),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey[200]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status: ${order['status'][0].toUpperCase() + order['status'].substring(1)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: getStatusColor(status),
                        ),
                      ),
                      Text(
                        'Order ID: ${order['id']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Divider(color: getStatusColor(status), thickness: 1),
                  SizedBox(height: 8),

                  ...itemsByCategory.keys.map((category) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: 8),
                        ...itemsByCategory[category]!.map((item) {
                          final product = item['Produk'];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product['ImageUrl'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              product['nama'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              formatCurrency(product['harga'] * item['qty']),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                          );
                        }).toList(),
                        Divider(color: Colors.grey[400], thickness: 1),
                        SizedBox(height: 8),
                      ],
                    );
                  }).toList(),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Total: ${formatCurrency(order['total_amount'])}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  if (status == 'done')
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          print(orderItems);
                          print(order['id']);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewPage(
                                orderItems: List<Map<String, dynamic>>.from(orderItems),
                                orderId: order['id'].toString(),
                              ),
                            ),
                          );
                        },
                        child: Text('See Review'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

String formatCurrency(int price) {
  return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (Match m) => '${m[1]}.')}';
}
