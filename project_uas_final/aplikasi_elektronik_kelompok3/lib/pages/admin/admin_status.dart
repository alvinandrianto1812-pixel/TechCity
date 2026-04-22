// import 'package:flutter/material.dart';

// class AdminStatusPage extends StatelessWidget {
//   final List<Map<String, dynamic>> orders = [
//     {
//       "name": "Large Pizza",
//       "category": "Food",
//       "details": "Pepperoni Pizza",
//       "quantity": 1,
//       "price": 180000,
//       "status": "Processing"
//     },
//     {
//       "name": "Personal Pizza",
//       "category": "Food",
//       "details": "Pepperoni Pizza",
//       "quantity": 2,
//       "price": 120000,
//       "status": "Processing"
//     },
//     {
//       "name": "Large Pizza",
//       "category": "Food",
//       "details": "Pepperoni Pizza",
//       "quantity": 1,
//       "price": 180000,
//       "status": "Done"
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Status',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.deepPurple, // Warna mewah
//         elevation: 0,
//       ),
//       backgroundColor: Color(0xFFF3F4F9), // Warna background terang
//       body: ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: orders.length,
//         itemBuilder: (context, index) {
//           final order = orders[index];
//           return Card(
//             margin: EdgeInsets.only(bottom: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             elevation: 4,
//             child: Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: _getStatusColor(order['status']),
//                   width: 2,
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Status: ${order['status']}",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: _getStatusColor(order['status']),
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.grey[200],
//                         ),
//                         child: Icon(
//                           Icons.shopping_bag,
//                           color: Colors.deepPurple,
//                           size: 40,
//                         ),
//                       ),
//                       SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               order['name'],
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             Text(
//                               "Category: ${order['category']}",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                             Text(
//                               "Details: ${order['details']}",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                             Text(
//                               "Qty: ${order['quantity']}",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Column(
//                         children: [
//                           Text(
//                             "Rp ${order['price']}",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           _buildStatusButton(order, index),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildStatusButton(Map<String, dynamic> order, int index) {
//     final List<String> statusOptions = ["Processing", "Delivering", "Done"];
//     return DropdownButton<String>(
//       value: order['status'],
//       items: statusOptions
//           .map((status) => DropdownMenuItem(
//                 value: status,
//                 child: Text(
//                   status,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: _getStatusColor(status),
//                   ),
//                 ),
//               ))
//           .toList(),
//       onChanged: (value) {
//         // Logika untuk memperbarui status pesanan
//         order['status'] = value!;
//         // Tambahkan setState jika Anda menggunakan StatefulWidget
//       },
//       underline: SizedBox(), // Menghapus garis bawah dropdown
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Done":
//         return Colors.green;
//       case "Delivering":
//         return Colors.blue;
//       case "Processing":
//         return Colors.orange;
//       default:
//         return Colors.grey;
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:aplikasi_elektronik_kelompok3/main.dart';

class AdminStatusPage extends StatefulWidget {
  @override
  State<AdminStatusPage> createState() => _AdminStatusPageState();
}

class _AdminStatusPageState extends State<AdminStatusPage> {
  List<Map<String, dynamic>> orders = [];

  Future<void> fetchOrders() async {
    try {
      var query = supabase.from('orders').select(
          '*, order_items(*, Produk(id, nama, desc, harga, category, ImageUrl))');

      final response = await query;
      setState(() {
        orders = List<Map<String, dynamic>>.from(response);
        // Sort orders by status
        orders.sort((a, b) =>
            _statusToInt(a['status']).compareTo(_statusToInt(b['status'])));
      });
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() {});
    }
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    try {
      var response = await supabase
          .from('orders')
          .update({'status': status}).eq('id', orderId);

      if (response.error == null) {
        print('Order status updated successfully');
      } else {
        print('Error updating status: ${response.error!.message}');
      }
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  // Helper function to convert status to integer for sorting
  int _statusToInt(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return 1;
      case 'delivering':
        return 2;
      case 'done':
        return 3;
      default:
        return 4;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Status',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF3F4F9),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
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
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _getStatusColor(status),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status: ${status[0].toUpperCase() + status.substring(1)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _getStatusColor(status),
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
                  Divider(color: _getStatusColor(status), thickness: 1),
                  SizedBox(height: 8),

                  // Menampilkan produk per kategori
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
                            subtitle: Text("Qty: ${item['qty']}"),
                            trailing: Text(
                              'Rp ${product['harga'] * item['qty']}',
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
                      'Total: Rp ${order['total_amount']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  SizedBox(height: 8),
                  _buildStatusButton(order, index),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusButton(Map<String, dynamic> order, int index) {
    if (order['status'] == 'done') {
      return SizedBox(); // No button for 'done' status
    }

    String nextStatus = '';
    Color buttonColor = Colors.blueAccent;
    if (order['status'] == 'processing') {
      nextStatus = 'delivering';
    } else if (order['status'] == 'delivering') {
      nextStatus = 'done';
      buttonColor = Colors.green; // Green button for 'done'
    }

    return ElevatedButton(
      onPressed: () {
        // Update status in Supabase and locally
        updateOrderStatus(order['id'], nextStatus);
        setState(() {
          order['status'] = nextStatus;
        });
      },
      child: Text('Mark as $nextStatus'),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor, // Dynamically set button color
        foregroundColor: Colors.white,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "done":
        return Colors.green;
      case "delivering":
        return Colors.blue;
      case "processing":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
