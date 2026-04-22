import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final double rating;

  const RatingWidget({required this.rating});

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor(); // Bintang penuh
    bool hasHalfStar = (rating - fullStars) >= 0.5; // Bintang setengah

    return Row(
      children: List.generate(
        5,
        (index) {
          if (index < fullStars) {
            return Icon(Icons.star, color: Colors.amber, size: 20);
          } else if (index == fullStars && hasHalfStar) {
            return Icon(Icons.star_half, color: Colors.amber, size: 20);
          } else {
            return Icon(Icons.star_border, color: Colors.amber, size: 20);
          }
        },
      ),
    );
  }
}
