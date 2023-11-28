import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitplus/src/controller/splash_screens_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/review_model.dart';
import 'fb_notifications.dart';

class FbFireStoreController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> read({required String nameCollection, required String orderBy, required bool descending}) async* {
    yield* _firebaseFirestore.collection(nameCollection).orderBy(orderBy, descending: descending).snapshots();
  }

  Future<bool> createUser({required BuildContext context, required var user, required String uid}) async {
    return await _firebaseFirestore.collection('users').doc(uid).set(user).then((value) {
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Future<bool> updateUser({
    required var data,
  }) async {
    var token = FirebaseAuth.instance.currentUser!.uid;
    return await _firebaseFirestore.collection('users').doc(token).update(data).then((value) {
      fitchUserData();
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Future<bool> checkExists({required String collection, required String doc}) async {
    var a = await _firebaseFirestore.collection(collection).doc(doc).get();
    if (a.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> fitchUserData() async {
    var token = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> data;
    final DocumentReference document = FirebaseFirestore.instance.collection('users').doc(token);
    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      data = snapshot.data() as Map<String, dynamic>;
      AppController.to.loginMap.assignAll(data);
      print(data);
    });
    return true;
  }

  Future<String> uploadFile({required File imageFile, required String fileName}) async {
    Reference reference;
    reference = FirebaseStorage.instance.ref().child(fileName);
    TaskSnapshot storageTaskSnapshot = await reference.putFile(imageFile);
    String dowUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return dowUrl;
  }

  Future<bool> createDocument({required String nameCollection, required var data, required String uid}) async {
    return await _firebaseFirestore.collection(nameCollection).doc(uid).set(data).then((value) {
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Future<bool> updateDocument({required String nameCollection, required var data, required String uid}) async {
    return await _firebaseFirestore.collection(nameCollection).doc(uid).update(data).then((value) {
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Future<bool> updateArray({required String nameDoc, required List<String> data, required String nameCollection, required String nameList}) async {
    return await _firebaseFirestore.collection(nameCollection).doc(nameDoc).update({nameList: FieldValue.arrayUnion(data)}).then((value) => true).catchError((error) => false);
  }

  addOffer({
    required String offerName,
    required String month,
    required String price,
    required String gymName
  }) async {
    return _firebaseFirestore.collection("offers").doc(DateTime.now().millisecondsSinceEpoch.toString()).set({
      "gymId": FirebaseAuth.instance.currentUser!.uid,
      "offer_name": offerName,
      "month": month,
      "price": price,
      "gymName": gymName,
    });

  }

  updateOffer({
    required String docId,
    required String offerName,
    required String month,
    required String price,
  }) async {
    return _firebaseFirestore.collection("offers").doc(docId).update({
      "gymId": FirebaseAuth.instance.currentUser!.uid,
      "offer_name": offerName,
      "month": month,
      "price": price,
    });
  }

  deleteOffer({required String docId}) async {
    return _firebaseFirestore.collection("offers").doc(docId).delete();
  }

  addToFavorite({required List<String> favId, required String userId}) async {
    return _firebaseFirestore.collection("users").doc(userId).update({
      "listFavorite": favId,
    });
  }

  Future<void> addReview({required String gymId, required String userName, required String review, required double rating}) async {
    final reviewDoc = _firebaseFirestore.collection("users").doc(gymId).collection("reviews").doc();
    await reviewDoc.set({
      "reviewId": reviewDoc.id,
      "gymId": gymId,
      "userName": userName,
      "review": review,
      "rating": rating,
      "createdAt": DateTime.now().toString(),
    });
  }

  Future<void> deleteReview({required ReviewModel review}) async {
    await _firebaseFirestore.collection("users").doc(review.gymId).collection("reviews").doc(review.reviewId).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getGymsReviewStream({required String gymId}) {
    return _firebaseFirestore.collection("users").doc(gymId).collection("reviews").snapshots().distinct();
  }

  Future<void> deleteFileFromFirebaseByUrl(String urlFile) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(urlFile);
      await ref.delete();
    } catch (e) {
      print(e);
    }
  }
}
