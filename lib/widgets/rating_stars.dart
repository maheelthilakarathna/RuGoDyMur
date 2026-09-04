import 'package:flutter/material.dart';

import '../utils/theme.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final double size;

  const RatingStars({super.key, required this.rating, required this.reviewCount, this.size = 16});

  @override
  Widget build(BuildContext context) {
    final fullStars = rating.floor();
    final hasHalf = rating - fullStars >= 0.5;
    return Row(
      children: [
        for (var i = 0; i < 5; i++)
          Icon(
            i < fullStars
                ? Icons.star
                : (i == fullStars && hasHalf ? Icons.star_half : Icons.star_border),
            color: AppColors.star,
            size: size,
          ),
        const SizedBox(width: 6),
        Text(
          '$rating ($reviewCount reviews)',
          style: TextStyle(fontSize: size * 0.7, color: Colors.grey),
        ),
      ],
    );
  }
}
