class ReviewModel {
  late final String reviewId;
  late final String gymId;
  late final String userName;
  late final String review;
  late final double rating;
  late final DateTime createdAt;

  ReviewModel.fromJson(Map<String, dynamic> json) {
    reviewId = json["reviewId"];
    gymId = json["gymId"];
    userName = json["userName"];
    review = json["review"];
    rating = json["rating"] / 1;
    createdAt = DateTime.parse(json["createdAt"]);
  }

  Map<String, dynamic> toJson() => {
        "reviewId": reviewId,
        "gymId": gymId,
        "userName": userName,
        "review": review,
        "rating": rating,
        "createdAt": createdAt,
      };
}
