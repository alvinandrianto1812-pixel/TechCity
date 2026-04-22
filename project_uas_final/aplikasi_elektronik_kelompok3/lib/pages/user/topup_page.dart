// import 'package:flutter/material.dart';

// class TopUpPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController amountController = TextEditingController();
//     double currentCredit = 630000; // Current credit amount
//     List<Map<String, dynamic>> transactionHistory = [
//       {"amount": -180000, "date": "2024-10-22"},
//       {"amount": -120000, "date": "2024-10-22"},
//       {"amount": -250000, "date": "2024-10-22"},
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Top Up Credit"),
//         backgroundColor: Color(0xFF4A148C), // Ungu serasi dengan logo
//         elevation: 0,
//       ),
//       body: Container(
//         color: Color(0xFFF5F5F5), // Latar belakang elegan
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Current Credit Display
//               Center(
//                 child: Column(
//                   children: [
//                     Text(
//                       "Current Credit:",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF4A148C),
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       formatCurrency(currentCredit.toInt()),
//                       style: TextStyle(
//                         fontSize: 36,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),

//               // Top Up Input Field
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10.0),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   controller: amountController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     hintText: "Enter Top Up Amount",
//                     contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),

//               // Top Up Button
//               ElevatedButton(
//                 onPressed: () {
//                   final amountText =
//                       amountController.text; // Mendapatkan input teks
//                   final int? amount =
//                       int.tryParse(amountText); // Mengonversi ke int
//                   if (amount != null && amount > 0) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                             "Top Up Successful! Amount: ${formatCurrency(amount)}"),
//                       ),
//                     );
//                     // Perbarui currentCredit
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text("Please enter a valid amount!"),
//                       ),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF4A148C),
//                   padding:
//                       EdgeInsets.symmetric(vertical: 14.0, horizontal: 32.0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//                 child: Text(
//                   "Top Up Credit",
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),

//               SizedBox(height: 20),

//               // Transaction History Section
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Transaction History",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF4A148C),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),

//               // Transaction History Items
//               ...transactionHistory.map((transaction) {
//                 return Container(
//                   margin: EdgeInsets.only(bottom: 10),
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Color(0xFFCE93D8),
//                     borderRadius: BorderRadius.circular(10.0),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.2),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             formatCurrency(transaction['amount']),
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: transaction['amount'] < 0
//                                   ? Colors.red
//                                   : Colors.green,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             "Date: ${transaction['date']}",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[800],
//                             ),
//                           ),
//                         ],
//                       ),
//                       Icon(Icons.receipt, color: Colors.white),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// String formatCurrency(int price) {
//   return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (Match m) => '${m[1]}.')}';
// }

import 'package:flutter/material.dart';
import 'package:aplikasi_elektronik_kelompok3/main.dart';
import 'package:aplikasi_elektronik_kelompok3/models/product_model.dart';

class TopUpPage extends StatefulWidget {
  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  String userId = supabase.auth.currentUser!.id; // ID pengguna saat ini
  final TextEditingController _topUpController = TextEditingController();
  int saldo = 0;
  List<historySaldo> historyList = []; // List to store history

  @override
  void initState() {
    super.initState();
    fetchSaldo();
    fetchHistory();
  }

  // Fungsi untuk mengambil saldo dari database
  Future<void> fetchSaldo() async {
    final data = await supabase
        .from('Pelanggan')
        .select('saldo')
        .eq('id', userId)
        .single();

    setState(() {
      saldo = data['saldo'];
    });
  }

  // Fungsi untuk mengambil history pembelian
  Future<void> fetchHistory() async {
    final data = await supabase
        .from('orders')
        .select('total_amount, ordered_at')
        .eq('user_id', userId)
        .eq('payment_method', 'credit');

    print(data);

    List<historySaldo> tempHistory = (data as List).map((order) {
      return historySaldo(
        saldoTerpakai: order['total_amount'],
        date: _formatDate(order['ordered_at']),
      );
    }).toList();

    // Mengurutkan dari yang paling baru ke paling lama
    tempHistory.sort((a, b) => b.date.compareTo(a.date));

    setState(() {
      historyList = tempHistory;
    });
  }

  // Fungsi untuk format tanggal tanpa dependencies tambahan
  String _formatDate(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)}';
  }

  // Fungsi untuk menambahkan '0' jika angka kurang dari 10
  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  // Fungsi untuk menambahkan saldo
  Future<void> _addBalance() async {
    setState(() {
      int topUpAmount = int.tryParse(_topUpController.text) ?? 0;
      saldo += topUpAmount;
    });

    await supabase
        .from('Pelanggan')
        .update({'saldo': saldo}).eq('id', userId);

    _topUpController.clear(); // Bersihkan kolom input setelah top up
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saldo berhasil ditambahkan!')),
    );
    fetchSaldo();
  }

  // Fungsi untuk format mata uang Rupiah
  String formatCurrency(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Top Up Credit',
          style: TextStyle(
            color: const Color(0xFF4A148C),
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        color: Color(0xFFF5F5F5),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Current Credit:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A148C),
              ),
            ),
            SizedBox(height: 10),
            Text(
              formatCurrency(saldo),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _topUpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Top Up Amount',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addBalance,
              child: Text(
                'Top Up Credit',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color(0xFF4A148C),
                elevation: 5,
                shadowColor: Color(0xFF4A148C).withOpacity(0.3),
              ),
            ),
            SizedBox(height: 20),

            // Transaction History Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Transaction History",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A148C),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: historyList.isEmpty
                  ? Center(child: Text('No purchase history available.'))
                  : ListView.builder(
                      itemCount: historyList.length,
                      itemBuilder: (context, index) {
                        final history = historyList[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFFCE93D8), // Background merah muda
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              formatCurrency(
                                  -history.saldoTerpakai), // Add minus sign
                              style: TextStyle(color: Colors.red),
                            ),
                            subtitle: Text('Date: ${history.date}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
