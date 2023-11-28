import 'package:fitplus/firebase/fb_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../value/constant.dart';

class ReviewDialog extends StatefulWidget {
  const ReviewDialog({required this.gymId, required this.userName, Key? key}) : super(key: key);
  final String gymId;
  final String userName;
  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  double? _rating;
  final _reviewController = TextEditingController();
  String? _ratingErr;
  String? _reviewErr;

  bool _isLoading = false;

  _ratingValidator() {
    if (_rating == null) {
      _ratingErr = "Please select rating stars";
    } else {
      _ratingErr = null;
    }
  }

  _reviewValidator() {
    if (_reviewController.text.isEmpty) {
      _reviewErr = "Please write a review";
    } else {
      _reviewErr = null;
    }
  }

  _fieldsValidator() {
    _ratingValidator();
    _reviewValidator();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Write Review',
                style: TextStyle(color: kPrimaryColor, fontSize: 20, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            SmoothStarRating(
                allowHalfRating: false,
                onRatingChanged: (v) {
                  _rating = v;
                  if (_ratingErr != null) {
                    _ratingValidator();
                  }
                  setState(() {});
                },
                starCount: 5,
                rating: _rating ?? 0,
                size: 30.0,
                filledIconData: Icons.star,
                halfFilledIconData: Icons.star_half,
                color: Colors.yellow,
                borderColor: Colors.yellow,
                spacing: 0.0),
            Text(_ratingErr ?? "", style: const TextStyle(fontSize: 10, color: Colors.red)),
            const SizedBox(height: 10),
            CupertinoTextField(
              placeholder: "Description",
              controller: _reviewController,
              onChanged: (v) {
                if (_reviewErr != null) {
                  _reviewValidator();
                  setState(() {});
                }
              },
              maxLines: 6,
              minLines: 3,
            ),
            const SizedBox(height: 2),
            Text(_reviewErr ?? "", style: const TextStyle(fontSize: 10, color: Colors.red)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    _fieldsValidator();
                    if (_reviewErr == null && _ratingErr == null) {
                      await _addReview();
                    }
                  },
                  child: Container(
                    height: 35,
                    width: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _addReview() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FbFireStoreController().addReview(gymId: widget.gymId, userName: widget.userName, review: _reviewController.text, rating: _rating!);
      Get.back();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review added')),
      );
    } catch (e) {
      showMaterialDialog_login(context, 'Make sure you are connected to the internet');
    }
    setState(() {
      _isLoading = false;
    });
  }
}
