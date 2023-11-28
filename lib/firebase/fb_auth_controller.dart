import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitplus/firebase/fb_notifications.dart';
import 'package:fitplus/main.dart';
import 'package:fitplus/screens/home/mainGym.dart';
import 'package:fitplus/screens/home/mainUser.dart';
import 'package:fitplus/screens/login&register/login.dart';
import 'package:fitplus/src/controller/splash_screens_controller.dart';
import 'package:fitplus/value/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';

import 'fb_firestore.dart';

class FbAuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> createAccount(BuildContext context, {Map<String, dynamic>? user, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: user!['email'], password: password);

      user.addAll({'gymId': userCredential.user!.uid});

      bool stateCreate = await FbFireStoreController().createUser(context: context, user: user, uid: userCredential.user!.uid);
      if (stateCreate) {
        signIn(context, email: user['email'], password: password);
      }
      return true;
    } on FirebaseAuthException catch (e) {
      print('=======================> $e');
      _controlErrorCodes(context, e);
    } catch (e) {
      showMaterialDialog_login(context, 'There is a problem with the internet');
    }
    return false;
  }

  Future<bool> signIn(BuildContext context, {required String email, required String password}) async {
    try {
      loadingDialog(context, true);
      Map<String, dynamic> data = {};
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final DocumentReference document = FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid);
      userID=userCredential.user!.uid;
      await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
        data = snapshot.data() as Map<String, dynamic>;
        data.addAll({"userId": userCredential.user!.uid});
        AppController.to.loginMap.assignAll(data);
      });
      int type = data['typeAccount'];
      saveFcm(path: userCredential.user!.uid);
      goToScreen(context, type.toString());
      return true;
    } on FirebaseAuthException catch (e) {
      print('===== here 2 ===== $e');
      _controlErrorCodes(context, e);
    } catch (e) {
      showMaterialDialog_login(context, 'Make sure you are connected to the internet');
      print('Exception: $e');
    }
    return false;
  }

  void _controlErrorCodes(BuildContext context, FirebaseAuthException authException) {
    // showMaterialDialog_login(
    //     context: context, content: authException.message ?? '', error: true);
    print(authException.code);
    switch (authException.code) {
      case 'email-already-in-use':
        loadingDialog(context, false);
        showMaterialDialog_login(context, 'This email already exists');
        break;

      case 'invalid-email':
        loadingDialog(context, false);

        showMaterialDialog_login(
          context,
          'Enter a valid email',
        );
        break;

      case 'operation-not-allowed':
        loadingDialog(context, false);

        break;

      case 'weak-password':
        loadingDialog(context, false);

        showMaterialDialog_login(
          context,
          'The password used is weak',
        );

        break;

      case 'user-not-found':
        loadingDialog(context, false);

        showMaterialDialog_login(
          context,
          'Incorrect email or password',
        );

        break;

      case 'requires-recent-login':
        loadingDialog(context, false);

        break;

      case 'wrong-password':
        loadingDialog(context, false);

        showMaterialDialog_login(
          context,
          'Incorrect email or password',
        );
        break;

      case 'too-many-requests':
        loadingDialog(context, false);

        showMaterialDialog_login(context, 'sent a lot of requests');
        break;
    }
  }

  void goToScreen(BuildContext context, String type) {
    print(type);
    loadingDialog(context, false);
    if (type == '1') {
      Get.to(() => MainUser( ));
    } else {
      Get.offAll(() => HomePageGym());
    }
  }

  Future<bool> forgetPassword({required BuildContext context, required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      SVProgressHUD.dismiss();
      _controlErrorCodes(context, e);
    } catch (e) {
      SVProgressHUD.dismiss();
      print(e);
    }
    SVProgressHUD.dismiss();
    return false;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await FirebaseMessaging.instance.deleteToken();
    AppController.to.loginMap.clear();
    Get.offAll(() => const MyLogin());
  }

  void loadingDialog(BuildContext context, bool run) {
    if (run) {
      SVProgressHUD.show();
    } else {
      SVProgressHUD.dismiss();
    }
  }

  saveFcm({required String path}) async {
    String fcm = await FbNotifications.getFcm();
    FbFireStoreController().updateUser(data: {'fcm': fcm});
  }
}
