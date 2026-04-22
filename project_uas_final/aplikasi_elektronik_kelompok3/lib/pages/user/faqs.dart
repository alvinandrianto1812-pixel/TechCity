import 'package:flutter/material.dart';

class FAQS extends StatelessWidget {
  FAQS({super.key});

  // List pertanyaan dan jawaban
  final List<Map<String, String>> faqs = [
    {
      'question': '1. Bagaimana cara memesan menu di GRANPA JOHN PIZZARIA?',
      'answer':
          'Untuk memesan, buka aplikasi, pilih kategori seperti pizza, pasta, atau minuman, tambahkan item yang diinginkan ke keranjang, lalu selesaikan pesanan dengan memilih metode pembayaran yang tersedia.'
    },
    {
      'question': '2. Apakah ada minimum order untuk pengiriman?',
      'answer':
          'Tidak, tidak ada minimum order untuk pengiriman gratis. Pesanan tidak akan dikenakan biaya pengiriman tambahan.'
    },
    {
      'question':
          '3. Jenis pizza apa saja yang tersedia di GRANPA JOHN PIZZARIA?',
      'answer':
          'Terdapat banyak jenis pizza yang bisa anda bisa pilih dari menu kami.'
    },
    {
      'question': '4. Apakah bisa menambah topping pada pizza?',
      'answer':
          'Saat memilih pizza, Anda tidak dapat menambahkan tambahan seperti keju ekstra, pepperoni, sosis, atau sayuran.'
    },
    {
      'question':
          '5. Apakah menu pasta di GRANPA JOHN PIZZARIA tersedia dalam porsi besar?',
      'answer': 'Semua menu pasta kami tersedia dalam porsi reguler.'
    },
    {
      'question': '6. Apakah ada menu vegetarian di GRANPA JOHN PIZZARIA?',
      'answer':
          'Ya, kami memiliki beberapa pilihan menu vegetarian seperti Vegetarian Pizza, Salad Segar, dan Pasta dengan saus tomat.'
    },
    {
      'question': '7. Bagaimana saya bisa melacak pesanan saya?',
      'answer':
          'Setelah melakukan pemesanan, Anda dapat melacak status pesanan Anda di menu "History" di aplikasi. Kami akan memberi Anda pembaruan langsung mengenai pengiriman pesanan.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFebeaf6),
      appBar: AppBar(
        title: Text(
          'FAQs',
          style: TextStyle(
            color: const Color(0xFFFFFBEF), // Mengubah warna teks menjadi putih
            fontWeight: FontWeight.bold, // Membuat teks menjadi bold
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A148C), // Warna AppBar
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Text(
                    faqs[index]['question']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Text(
                        faqs[index]['answer']!,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8), // Space between cards
              Divider(
                color: Colors.grey.shade400,
                thickness: 1.2,
              ),
            ],
          );
        },
      ),
    );
  }
}
