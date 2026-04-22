import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:aplikasi_elektronik_kelompok3/main.dart';

class AdminProfitPage extends StatefulWidget {
  @override
  _AdminProfitPageState createState() => _AdminProfitPageState();
}

class _AdminProfitPageState extends State<AdminProfitPage> {
  List<Map<String, dynamic>> orderChart = []; // State untuk data pesanan
  bool isLoading = true; // Menambahkan indikator loading

  @override
  void initState() {
    super.initState();
    fetchChart(); // Memanggil fungsi untuk mengambil data pesanan
  }

  Future<void> fetchChart() async {
    try {
      var query = supabase.from('orders').select('total_amount, ordered_at');
      final response = await query;

      setState(() {
        orderChart = List<Map<String, dynamic>>.from(response);
        isLoading = false; // Menandakan data sudah selesai diambil
      });
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() {
        isLoading = false; // Jika error, hentikan loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F4F9),
      appBar: AppBar(
        title: Text(
          'Profit Overview',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Total Profit: Rp 1.235.000", // Bisa diubah jika data dari API sudah siap
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          SizedBox(height: 20),
          // Menampilkan grafik profit
          Center(
            child: isLoading
                ? CircularProgressIndicator() // Menampilkan indikator loading
                : Container(
                    height: 250,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: 200,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  'Rp ${value.toInt()}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  'Day ${value.toInt()}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border:
                              Border.all(color: Colors.grey[300]!, width: 1),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots:
                                _getProfitData(), // Menggunakan data profit yang sudah diolah
                            isCurved: true,
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepPurple,
                                Colors.deepPurpleAccent
                              ],
                            ),
                            barWidth: 4,
                            isStrokeCapRound: true,
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurple.withOpacity(0.3),
                                  Colors.deepPurple.withOpacity(0.1),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          SizedBox(height: 30),
          // Menampilkan status pesanan
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatusCard(
                  icon: Icons.chat_bubble_outline,
                  label: 'Processing',
                  count: 3, // Mengambil data dari API jika sudah tersedia
                  color: Colors.orange,
                ),
                _buildStatusCard(
                  icon: Icons.delivery_dining,
                  label: 'Delivering',
                  count: 1, // Mengambil data dari API jika sudah tersedia
                  color: Colors.blue,
                ),
                _buildStatusCard(
                  icon: Icons.check_circle_outline,
                  label: 'Done',
                  count: 3, // Mengambil data dari API jika sudah tersedia
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk mendapatkan data profit
  List<FlSpot> _getProfitData() {
    Map<String, int> profitMap = {};

    for (var order in orderChart) {
      // Memperbaiki format tanggal agar selalu ada dua digit untuk bulan dan hari
      DateTime orderDate = DateTime.parse(_formatDate(order['ordered_at']));
      int totalAmount = order['total_amount'] ?? 0;

      // Membuat key berdasarkan tanggal
      String monthDayKey =
          "${orderDate.year}-${orderDate.month.toString().padLeft(2, '0')}-${orderDate.day.toString().padLeft(2, '0')}";

      if (profitMap.containsKey(monthDayKey)) {
        profitMap[monthDayKey] = profitMap[monthDayKey]! + totalAmount;
      } else {
        profitMap[monthDayKey] = totalAmount;
      }
    }

    List<MapEntry<String, int>> sortedEntries = profitMap.entries.toList()
      ..sort((a, b) => DateTime.parse(a.key).compareTo(DateTime.parse(b.key)));

    List<FlSpot> profitData = [];
    for (int index = 0; index < sortedEntries.length; index++) {
      profitData
          .add(FlSpot(index.toDouble(), sortedEntries[index].value.toDouble()));
    }

    return profitData;
  }

// Fungsi untuk memformat tanggal yang diterima
  String _formatDate(String date) {
    // Mengubah tanggal agar selalu memiliki dua digit untuk bulan dan hari
    List<String> parts = date.split('-');
    if (parts.length == 2) {
      // Format yang salah misalnya '2024-12-1' diubah menjadi '2024-12-01'
      return '${parts[0]}-${parts[1].padLeft(2, '0')}-01';
    }
    return date;
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: color),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
