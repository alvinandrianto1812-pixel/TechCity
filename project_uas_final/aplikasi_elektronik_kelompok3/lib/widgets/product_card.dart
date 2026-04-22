import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final VoidCallback onTap;

  const ProductCard({
    required this.name,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: Icon(Icons.devices, size: 40, color: Colors.deepPurple),
          title: Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          subtitle: Text(price, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.deepPurple),
        ),
      ),
    );
  }
}
