import 'package:flutter/material.dart';
import 'package:groomzy/view/widgets/rating/rating.dart';

class Rating extends StatelessWidget {
  final IconData ratingIcon;
  final Color ratingColor;
  final double ratingPercentage;
  final String ratingStatus;
  final double ratingCounts;
  final void Function(double)? onRatingUpdate;
  final int numberOfRatedBookings;

  const Rating({
    this.ratingIcon = Icons.star_border,
    this.ratingColor = Colors.grey,
    this.ratingCounts = 0,
    this.ratingPercentage = 0,
    this.ratingStatus = 'not rated',
    this.onRatingUpdate,
    required this.numberOfRatedBookings,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ratingCounts == 0
          ? null
          : Icon(
              ratingIcon,
              color: ratingColor,
            ),
      title: AndroidRating(
        ratingCounts: ratingCounts,
        onRatingUpdate: onRatingUpdate ?? (x) {},
        itemSize: 24,
        icon: Icons.star_outline,
        iconColor: ratingColor,
      ),
      subtitle: Text('$ratingPercentage% $ratingStatus service'),
      trailing: Column(
        children: [
          Text('$numberOfRatedBookings ratings'),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
