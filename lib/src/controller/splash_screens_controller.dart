// ignore_for_file: depend_on_referenced_packages, unused_import

import 'package:fitplus/screens/login&register/login.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:get/get.dart';

class AppController extends GetxController{
  static AppController get to => Get.put(AppController());


  RxBool animate = false.obs;
  var loginMap = {}.obs;


  Future<String> encryptData(
      {required String plainText, required bool encryptData}) async {
    final key = encrypt.Key.fromBase64('A93mv1np3scj1HC2s6n8dk7qQ7dFxZD9');
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    encrypt.Encrypted encrypted;
    String decrypted;
    if (encryptData) {
      encrypted = encrypter.encrypt(plainText, iv: iv);
      return encrypted.base64.toString();
    } else {
      decrypted =
          encrypter.decrypt(encrypt.Encrypted.from64(plainText), iv: iv);
      return decrypted.toString();
    }
  }

  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    animate.value = true;
    await Future.delayed(const Duration(milliseconds: 5000));
    Get.to(const MyLogin() );
  }
}