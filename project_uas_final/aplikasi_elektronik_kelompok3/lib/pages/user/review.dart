import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Assumes Supabase is already set up

class ReviewPage extends StatefulWidget {
  final List<Map<String, dynamic>> orderItems;
  final String orderId;

  ReviewPage({required this.orderItems, required this.orderId});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final supabase = Supabase.instance.client;
  int _rating = 0;
  String _reviewText = '';

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    // Loop over each orderItem to fetch the corresponding review from Supabase
    for (var orderItem in widget.orderItems) {
      final response = await supabase
          .from('review')
          .select()
          .eq('order_item_id', orderItem['id'])
          .maybeSingle(); // Fetch a single review, if exists

      if (response != null) {
        orderItem['isReviewed'] = true;
        orderItem['rating'] = response['rating'];
        orderItem['review'] = response['review'];
      } else {
        orderItem['isReviewed'] = false;
      }
    }

    // Refresh the UI after fetching data
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Review Order ${widget.orderId}'),
        backgroundColor: Color(0xFF4A148C),
      ),
      body: ListView.builder(
        itemCount: widget.orderItems.length,
        itemBuilder: (context, index) {
          final orderItem = widget.orderItems[index];
          final product = orderItem['Produk'];
          final isReviewed = orderItem['isReviewed'] ?? false;
          final rating = orderItem['rating'] ?? 0;
          final reviewText = orderItem['review'] ?? '';

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product['ImageUrl'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(product['nama']),
              subtitle: isReviewed
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display rating stars
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                            );
                          }),
                        ),
                        SizedBox(height: 8),
                        Text('Review: $reviewText'),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () => _showReviewModal(context, orderItem),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('Review Product'),
                    ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showReviewModal(
      BuildContext context, Map<String, dynamic> orderItem) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: StatefulBuilder(
            builder: (context, modalSetState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rate and Review',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            iconSize: 40,
                            icon: Icon(
                              index < _rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              modalSetState(() {
                                _rating = index + 1;
                              });
                            },
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      onChanged: (value) {
                        modalSetState(() {
                          _reviewText = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Write your review',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF56C26),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          await _submitReview(orderItem, context, _rating);
                          Navigator.pop(context);
                          _fetchReviews(); // Refresh reviews after submission
                        },
                        child: Text('Done'),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _submitReview(
      Map<String, dynamic> orderItem, BuildContext context, int rating) async {
    try {
      await supabase.from('review').insert({
        'user_id': supabase.auth.currentUser!.id,
        'product_id': orderItem['Produk']['id'],
        'rating': _rating,
        'review': _reviewText,
        'order_item_id': orderItem['id'],
      });

      await supabase
          .from('order_items')
          .update({'isReviewed': true}).eq('id', orderItem['id']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review submitted successfully')),
      );
    } catch (e) {
      print('error at review: $e');
    }
    String message;
    IconData icon;
    Color iconColor;
    Color backgroundColor;
    Color textColor = Colors.white; // Warna teks yang selalu terlihat jelas

    if (rating <= 2) {
      message = "We're sorry to hear that! How can we improve?";
      icon = Icons.sentiment_dissatisfied;
      iconColor = Colors.red;
      backgroundColor = Colors.red.shade700; // Latar merah untuk rating rendah
    } else if (rating <= 4) {
      message = "Thank you for your feedback!";
      icon = Icons.sentiment_satisfied;
      iconColor = Colors.amber;
      backgroundColor =
          Colors.orange.shade600; // Latar oranye untuk rating menengah
    } else {
      message = "Thank you! We're glad you loved it!";
      icon = Icons.sentiment_very_satisfied;
      iconColor = Colors.green;
      backgroundColor =
          Colors.green.shade700; // Latar hijau untuk rating tinggi
    }

    // Menampilkan SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: iconColor),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 16, color: textColor), // Teks putih
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
