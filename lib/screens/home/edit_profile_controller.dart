import 'dart:io';

import 'package:fitplus/firebase/fb_firestore.dart';
import 'package:fitplus/screens/map_picker/models/place_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController commercial = TextEditingController();
  TextEditingController nameGym = TextEditingController();
  RxString locationGym = "".obs;
  TextEditingController descriptionGym = TextEditingController();
  RxBool selectNewImage = false.obs;
  RxBool availableWifi = false.obs;
  RxBool availableBarking = false.obs;
  RxString sundayFrom = 'From'.obs;
  RxString sundayTo = 'To'.obs;
  RxString mondayFrom = 'From'.obs;
  RxString mondayTo = 'To'.obs;
  RxString tuesdayFrom = 'From'.obs;
  RxString tuesdayTo = 'To'.obs;
  RxString wednesdayFrom = 'From'.obs;
  RxString wednesdayTo = 'To'.obs;
  RxString thursdayFrom = 'From'.obs;
  RxString thursdayTo = 'To'.obs;
  RxString fridayFrom = 'From'.obs;
  RxString fridayTo = 'To'.obs;
  RxString saturdayFrom = 'From'.obs;
  RxString saturdayTo = 'To'.obs;
  Rx<XFile>? pickedFile = XFile('').obs;
  RxString urlImage = ''.obs;
  PlaceInfo? gymLocation;

  Future<void> pickImageAfterSelect({required BuildContext context}) async {
    ImagePicker imagePicker = ImagePicker();

    pickedFile!.value = (await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    ))!;
    if (pickedFile != null) {
      /// here code upload image to firebase
      selectNewImage.value = true;

      File file = File(pickedFile!.value.path);
      urlImage.value = await FbFireStoreController().uploadFile(imageFile: file, fileName: pickedFile!.value.name);
    }
  }

  Future<String> selectTime({required BuildContext context}) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    if (picked != null) {
      // hiddenKeyboard(context);
      return '${picked.hour}:${picked.minute}';
    } else {
      return '';
    }
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final RegExp Regex = RegExp(
      r'^((?:[0]+)(?:[5]+)(?:\s?\d{8}))$',
    );
    return Regex.hasMatch(phoneNumber);
  }
}
