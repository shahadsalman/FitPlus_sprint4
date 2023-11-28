import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitplus/firebase/fb_firestore.dart';
import 'package:fitplus/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class AverageRatingsWidget extends StatelessWidget {
  const AverageRatingsWidget({super.key, required this.gymId});
  final String gymId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FbFireStoreController().getGymsReviewStream(gymId: gymId),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data!.docs.isNotEmpty) {
            double totalRating = 0;
            for (final doc in snapshot.data!.docs) {
              final review = ReviewModel.fromJson(doc.data());
              totalRating += review.rating;
            }
            double avgRating = totalRating / snapshot.data!.docs.length;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmoothStarRating(
                  allowHalfRating: true,
                  onRatingChanged: (v) {},
                  starCount: 1,
                  rating: avgRating,
                  size: 20.0,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  color: Colors.yellow,
                  borderColor: Colors.yellow,
                  spacing: 0.0,
                ),
                Text("${avgRating.toStringAsFixed(1)}"),

              ],
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}
