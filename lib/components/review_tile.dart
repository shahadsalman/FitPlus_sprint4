import 'package:fitplus/models/review_model.dart';
import 'package:fitplus/value/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../firebase/fb_firestore.dart';
import '../src/controller/splash_screens_controller.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile({required this.review, Key? key}) : super(key: key);
  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    final userData = AppController.to.loginMap;
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: kPrimaryColor.withOpacity(0.5),
          )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review.userName, style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 15),
                SmoothStarRating(
                  allowHalfRating: false,
                  onRatingChanged: (v) {},
                  starCount: 5,
                  rating: review.rating,
                  size: 20.0,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  color: Colors.yellow,
                  borderColor: Colors.yellow,
                  spacing: 0.0,
                ),
                const SizedBox(height: 5),
                Text(review.review, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          if (review.userName == "${userData["FName"]} ${userData["LName"]}")
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 15),
                                const Text("Are you sure you want to delete this review?"),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ButtonStyle(
                                            elevation: MaterialStateProperty.all<double>(10),
                                            backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 210, 202, 221)),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ))),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text("Cancel"),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          FbFireStoreController().deleteReview(review: review);
                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        style: ButtonStyle(
                                            elevation: MaterialStateProperty.all<double>(10),
                                            backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 210, 202, 221)),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ))),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text("Delete Review"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                icon: const Icon(Icons.delete, color: Colors.black))
        ],
      ),
    );
  }
}
