// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:fitplus/firebase/fb_auth_controller.dart';
import 'package:fitplus/firebase/fb_firestore.dart';
import 'package:fitplus/screens/map_picker/map_picker_screen.dart';
import 'package:fitplus/src/controller/splash_screens_controller.dart';
import 'package:fitplus/value/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../firebase/fb_notifications.dart';
import '../map_picker/models/place_info.dart';
import 'login.dart';

class CreateAccountManagerGym extends StatefulWidget {
  CreateAccountManagerGym({Key? key}) : super(key: key);
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController commercial = TextEditingController();
  TextEditingController nameGym = TextEditingController();
  TextEditingController locationGym = TextEditingController();
  TextEditingController descriptionGym = TextEditingController();
  TextEditingController priceOneMonth = TextEditingController();
  TextEditingController priceThreeMonth = TextEditingController();
  TextEditingController priceSixMonth = TextEditingController();
  TextEditingController price12Month = TextEditingController();
  bool selectNewImage = false;
  bool availableWifi = false;
  bool availableBarking = false;
  String sundayFrom = 'From';
  String sundayTo = 'To';
  String mondayFrom = 'From';
  String mondayTo = 'To';
  String tuesdayFrom = 'From';
  String tuesdayTo = 'To';
  String wednesdayFrom = 'From';
  String wednesdayTo = 'To';
  String thursdayFrom = 'From';
  String thursdayTo = 'To';
  String fridayFrom = 'From';
  String fridayTo = 'To';
  String saturdayFrom = 'From';
  String saturdayTo = 'To';
  late XFile? _pickedFile;
  String urlImage = '';

  @override
  State<CreateAccountManagerGym> createState() => _CreateAccountManagerGymState();
}

class _CreateAccountManagerGymState extends State<CreateAccountManagerGym> {
  final TextEditingController confirmPass = TextEditingController();
  PlaceInfo? gymLocation;

  String? _imgErr;
  String? _emailErr;
  String? _pass1Err;
  String? _pass2Err;
  String? _phoneErr;
  String? _commercialErr;
  String? _nameErr;
  String? _descErr;
  String? _locErr;
  String? _priceErr;
  String? _sunErr;
  String? _monErr;
  String? _tueErr;
  String? _wedErr;
  String? _thuErr;
  String? _friErr;
  String? _satErr;

  bool get _canProceed => _imgErr == null && _emailErr == null && _pass1Err == null && _pass2Err == null && _phoneErr == null && _commercialErr == null && _nameErr == null && _descErr == null && _locErr == null && _priceErr == null && _sunErr == null && _monErr == null && _tueErr == null && _wedErr == null && _thuErr == null && _friErr == null && _satErr == null;

  _imgValidator() {
    if (widget.urlImage.isEmpty) {
      _imgErr = "Please Add Gym Image";
    } else {
      _imgErr = null;
    }
  }

  _emailValidator() {
    if (widget.email.text.trim().isEmpty) {
      _emailErr = "Please enter a valid email";
    } else if (!widget.email.text.isEmail) {
      _emailErr = "Please enter a valid email";
    } else {
      _emailErr = null;
    }
  }

  _pass1Validator() {
    if (widget.password.text.trim().length < 7) {
      _pass1Err = "Password length is short (minimum : 7)";
    } else if (!widget.password.text.contains(RegExp(r'[A-Z]'))) {
      _pass1Err = "At least one (special, lower, upper, number)";
    } else if (!widget.password.text.contains(RegExp(r'[a-z]'))) {
      _pass1Err = "At least one (special, lower, upper, number)";
    } else if (!widget.password.text.contains(RegExp(r'[0-9]'))) {
      _pass1Err = "At least one (special, lower, upper, number)";
    } else if (!widget.password.text.contains(RegExp(r'[_\-!@#$%^&*(),.?":{}|<>]'))) {
      _pass1Err = "At least one (special, lower, upper, number)";
    } else {
      _pass1Err = null;
    }
  }

  _pass2Validator() {
    if (confirmPass.text.isEmpty) {
      _pass2Err = "This is a required field";
    } else if (confirmPass.text != widget.password.text) {
      _pass2Err = "Password does not match";
    } else {
      _pass2Err = null;
    }
  }

  _phoneValidator() {
    if (widget.phone.text.trim().isEmpty) {
      _phoneErr = "Please enter a Phone Number";
    } else if (widget.phone.text.trim().length != 10) {
      _phoneErr = "Please enter 10 digits Phone Number";
    } else if (!widget.phone.text.startsWith("05")) {
      _phoneErr = "The phone number must start with 05";
    } else {
      _phoneErr = null;
    }
  }

  _commercialNumValidator() {
    if (widget.commercial.text.trim().isEmpty) {
      _commercialErr = "Please enter a Commercial Record";
    } else if (widget.commercial.text.trim().length != 14) {
      _commercialErr = "Please enter a 14 digit Commercial Record";
    } else {
      _commercialErr = null;
    }
  }

  _nameValidator() {
    if (widget.nameGym.text.trim().isEmpty) {
      _nameErr = "Please Add GYM Name";
    } else {
      _nameErr = null;
    }
  }

  _descValidator() {
    if (widget.descriptionGym.text.trim().isEmpty) {
      _descErr = "Please Add Gym Description";
    } else {
      _descErr = null;
    }
  }

  _locationValidator() {
    if (gymLocation?.address.isEmpty ?? true) {
      _locErr = "Please select the gym location";
    } else {
      _locErr = null;
    }
  }

  _priceValidator() {
    if (widget.priceOneMonth.text.trim().isEmpty) {
      _priceErr = "Please Add Subscription Price For 1 Month";
    } else if (widget.priceThreeMonth.text.trim().isEmpty) {
      _priceErr = "Please Add Subscription Price For 3 Month";
    } else if (widget.priceSixMonth.text.trim().isEmpty) {
      _priceErr = "Please Add Subscription Price For 6 Month";
    } else if (widget.price12Month.text.trim().isEmpty) {
      _priceErr = "Please Add Subscription Price For 12 Month";
    } else if (int.parse(widget.priceOneMonth.text) < 1) {
      _priceErr = "Every Subscription Price should be more than 0";
    } else if (int.parse(widget.priceThreeMonth.text) < 1) {
      _priceErr = "Every Subscription Price should be more than 0";
    } else if (int.parse(widget.priceSixMonth.text) < 1) {
      _priceErr = "Every Subscription Price should be more than 0";
    } else if (int.parse(widget.price12Month.text) < 1) {
      _priceErr = "Every Subscription Price should be more than 0";
    } else {
      _priceErr = null;
    }
  }

  String? _timeValidator({required String fromString, required String toString}) {
    final now = DateTime.now();
    DateTime? from;
    DateTime? to;
    if (fromString.isNotEmpty) {
      final hour = int.parse(fromString.split(":").first);
      final minute = int.parse(fromString.split(":").last);
      from = DateTime(now.year, now.month, now.month, hour, minute);
    }
    if (toString.isNotEmpty) {
      final hour = int.parse(toString.split(":").first);
      final minute = int.parse(toString.split(":").last);
      to = DateTime(now.year, now.month, now.month, hour, minute);
    }
    if (from != null && to != null) {
      if (to.isBefore(from)) {
        return "Opening time should be before the closing time";
      }
    }
    return null;
  }

  _hoursValidator() {
    if (widget.sundayFrom == 'From' ||
        widget.sundayTo == 'To' ||
        widget.mondayFrom == 'From' ||
        widget.mondayTo == 'To' ||
        widget.tuesdayFrom == 'From' ||
        widget.tuesdayTo == 'To' ||
        widget.wednesdayFrom == 'From' ||
        widget.wednesdayTo == 'To' ||
        widget.thursdayFrom == 'From' ||
        widget.thursdayTo == 'To' ||
        widget.fridayFrom == 'From' ||
        widget.fridayTo == 'To' ||
        widget.saturdayFrom == 'From' ||
        widget.saturdayTo == 'To') {
      if (widget.sundayFrom == 'From' || widget.sundayTo == 'To') {
        _sunErr = "Please Add Working Hours GYM In Sunday";
      }
      if (widget.mondayFrom == 'From' || widget.mondayTo == 'To') {
        _monErr = "Please Add Working Hours GYM In monday";
      }
      if (widget.tuesdayFrom == 'From' || widget.tuesdayTo == 'To') {
        _tueErr = "Please Add Working Hours GYM In tuesday";
      }
      if (widget.wednesdayFrom == 'From' || widget.wednesdayTo == 'To') {
        _wedErr = "Please Add Working Hours GYM In wednesday";
      }
      if (widget.thursdayFrom == 'From' || widget.thursdayTo == 'To') {
        _thuErr = "Please Add Working Hours GYM In thursday";
      }
      if (widget.fridayFrom == 'From' || widget.fridayTo == 'To') {
        _friErr = "Please Add Working Hours GYM In friday";
      }
      if (widget.saturdayFrom == 'From' || widget.saturdayTo == 'To') {
        _satErr = "Please Add Working Hours GYM In saturday";
      }
    } else {
      _sunErr = null;
      _monErr = null;
      _tueErr = null;
      _wedErr = null;
      _thuErr = null;
      _friErr = null;
      _satErr = null;
    }
  }

  _fieldsValidator() {
    _imgValidator();
    _emailValidator();
    _pass1Validator();
    _pass2Validator();
    _phoneValidator();
    _commercialNumValidator();
    _nameValidator();
    _descValidator();
    _locationValidator();
    _priceValidator();
    _hoursValidator();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 20, backgroundColor: const Color.fromARGB(255, 210, 199, 226), title: const Text('Create Gym'), centerTitle: true, titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20)),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  /// change image logo
                  pickImageAfterSelect(context: context);
                },
                child: Container(
                  height: 150,
                  width: 150,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                  child: Center(
                    child: widget.selectNewImage
                        ? Image.file(
                            File(widget._pickedFile!.path),
                            fit: BoxFit.fill,
                            height: 150,
                          )
                        : const Icon(Icons.camera_alt, size: 50),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 30,
              child: Text(
                _imgErr ?? "",
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            margin: const EdgeInsets.only(left: 35, right: 35),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: TextField(
                controller: widget.email,
                style: const TextStyle(color: Colors.black, fontSize: 25),
                keyboardType: TextInputType.emailAddress,
                onChanged: (val) {
                  if (_emailErr != null) {
                    _emailValidator();
                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 210, 202, 221),
                  filled: true,
                  hintText: 'Email',
                  errorText: _emailErr,
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                )),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 60,
            width: double.infinity,
            margin: const EdgeInsets.only(left: 35, right: 35),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: TextField(
                controller: widget.password,
                style: const TextStyle(color: Colors.black, fontSize: 25),
                obscureText: true,
                onChanged: (val) {
                  if (_pass1Err != null) {
                    _pass1Validator();
                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 210, 202, 221),
                  filled: true,
                  hintText: 'Password',
                  errorText: _pass1Err,
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                )),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 60,
            width: double.infinity,
            margin: const EdgeInsets.only(left: 35, right: 35),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: TextField(
                controller: confirmPass,
                style: const TextStyle(color: Colors.black, fontSize: 25),
                obscureText: true,
                onChanged: (val) {
                  if (_pass2Err != null) {
                    _pass2Validator();
                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 210, 202, 221),
                  filled: true,
                  hintText: 'Confirm Password',
                  errorText: _pass2Err,
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                )),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 60,
            width: double.infinity,
            margin: const EdgeInsets.only(left: 35, right: 35),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: TextField(
                controller: widget.phone,
                style: const TextStyle(color: Colors.black, fontSize: 25),
                keyboardType: TextInputType.phone,
                inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                onChanged: (val) {
                  if (_phoneErr != null) {
                    _phoneValidator();
                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 210, 202, 221),
                  filled: true,
                  hintText: 'Phone Number',
                  errorText: _phoneErr,
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                )),
          ),
          const SizedBox(height: 30),
          Container(
            height: 80,
            width: double.infinity,
            margin: const EdgeInsets.only(left: 35, right: 35),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: TextField(
                maxLength: 14,
                controller: widget.commercial,
                style: const TextStyle(color: Colors.black, fontSize: 25),
                keyboardType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(14), FilteringTextInputFormatter.digitsOnly],
                onChanged: (val) {
                  if (_commercialErr != null) {
                    _commercialNumValidator();
                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 210, 202, 221),
                  filled: true,
                  hintText: 'Commercial Record ',
                  errorText: _commercialErr,
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                )),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 60,
            width: double.infinity,
            margin: const EdgeInsets.only(left: 35, right: 35),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: TextField(
                controller: widget.nameGym,
                style: const TextStyle(color: Colors.black, fontSize: 25),
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.deny(RegExp(r'[0-9]'))],
                onChanged: (val) {
                  if (_nameErr != null) {
                    _nameValidator();
                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 210, 202, 221),
                  filled: true,
                  hintText: 'Name Gym',
                  errorText: _nameErr,
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                )),
          ),
          const SizedBox(
            height: 30,
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 35, right: 35),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: TextField(
                maxLength: 2000,
                maxLines: 3,
                controller: widget.descriptionGym,
                style: const TextStyle(color: Colors.black, fontSize: 25),
                onChanged: (val) {
                  if (_descErr != null) {
                    _descValidator();
                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 210, 202, 221),
                  filled: true,
                  hintText: 'Description Of Gym',
                  errorText: _descErr,
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                )),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Expanded(
                  child: Text('Available Wifi In GYM ?', style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
                Switch(
                  value: widget.availableWifi,
                  onChanged: (value) {
                    setState(() {
                      widget.availableWifi = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Expanded(
                  child: Text('Available Parking In GYM ?', style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
                Switch(
                  value: widget.availableBarking,
                  onChanged: (value) {
                    setState(() {
                      widget.availableBarking = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text('Working Hours', style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Expanded(
                  child: Text('Sunday', style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
                GestureDetector(
                  onTap: () async {
                    widget.sundayFrom = await selectTime(context: context);
                    _sunErr = _timeValidator(toString: widget.sundayTo, fromString: widget.sundayFrom);
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(widget.sundayFrom),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    widget.sundayTo = await selectTime(context: context);
                    _sunErr = _timeValidator(toString: widget.sundayTo, fromString: widget.sundayFrom);
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(widget.sundayTo),
                    ),
                  ),
                )
              ],
            ),
          ),
          if (_sunErr != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(_sunErr ?? "", style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Expanded(
                  child: Text('Monday', style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
                GestureDetector(
                  onTap: () async {
                    widget.mondayFrom = await selectTime(context: context);
                    _monErr = _timeValidator(toString: widget.mondayTo, fromString: widget.mondayFrom);
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(widget.mondayFrom),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    widget.mondayTo = await selectTime(context: context);
                    _monErr = _timeValidator(toString: widget.mondayTo, fromString: widget.mondayFrom);
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(widget.mondayTo),
                    ),
                  ),
                )
              ],
            ),
          ),
          if (_monErr != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(_monErr ?? "", style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Expanded(
                  child: Text('tuesday', style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
                GestureDetector(
                  onTap: () async {
                    widget.tuesdayFrom = await selectTime(context: context);
                    _tueErr = _timeValidator(toString: widget.tuesdayTo, fromString: widget.tuesdayFrom);
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(widget.tuesdayFrom),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    widget.tuesdayTo = await selectTime(context: context);
                    _tueErr = _timeValidator(toString: widget.tuesdayTo, fromString: widget.tuesdayFrom);
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(widget.tuesdayTo),
                    ),
                  ),
                )
              ],
            ),
          ),
          if (_tueErr != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(_tueErr ?? "", style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Expanded(
                  child: Text('wednesday', style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
                GestureDetector(
                  onTap: () async {
                    widget.wednesdayFrom = await selectTime(context: context);
                    _wedErr = _timeValidator(toString: widget.wednesdayTo, fromString: widget.wednesdayFrom);
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(widget.wednesdayFrom),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    widget.wednesdayTo = await selectTime(context: context);
                    _wedErr = _timeValidator(toString: widget.wednesdayTo, fromString: widget.wednesdayFrom);
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(widget.wednesdayTo),
                    ),
                  ),
                )
              ],
            ),
          ),
          if (_wedErr != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(_wedErr ?? "", style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Expanded(
                  child: Text('thursday', style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
                GestureDetector(
                  onTap: () async {
                    widget.thursdayFrom = await selectTime(context: context);
                    _thuErr = _timeValidator(toString: widget.thursdayTo, fromString: widget.thursdayFrom);
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(widget.thursdayFrom),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    widget.thursdayTo = await selectTime(context: context);
                    _thuErr = _timeValidator(toString: widget.thursdayTo, fromString: widget.thursdayFrom);
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(widget.thursdayTo),
                    ),
                  ),
                )
              ],
            ),
          ),
          if (_thuErr != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(_thuErr ?? "", style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Expanded(
                  child: Text('friday', style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
                GestureDetector(
                  onTap: () async {
                    widget.fridayFrom = await selectTime(context: context);
                    _friErr = _timeValidator(toString: widget.fridayTo, fromString: widget.fridayFrom);
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(widget.fridayFrom),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    widget.fridayTo = await selectTime(context: context);
                    _friErr = _timeValidator(toString: widget.fridayTo, fromString: widget.fridayFrom);
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(widget.fridayTo),
                    ),
                  ),
                )
              ],
            ),
          ),
          if (_friErr != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(_friErr ?? "", style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Expanded(
                  child: Text('saturday', style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
                GestureDetector(
                  onTap: () async {
                    widget.saturdayFrom = await selectTime(context: context);
                    _satErr = _timeValidator(toString: widget.saturdayTo, fromString: widget.saturdayFrom);
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(widget.saturdayFrom),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    widget.saturdayTo = await selectTime(context: context);
                    _satErr = _timeValidator(toString: widget.saturdayTo, fromString: widget.saturdayFrom);
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(widget.saturdayTo),
                    ),
                  ),
                )
              ],
            ),
          ),
          if (_satErr != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(_satErr ?? "", style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Subscription Price',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ],
            ),
          ),
          if (_priceErr != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _priceErr ?? "",
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: TextField(
                      controller: widget.priceOneMonth,
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      inputFormatters: [LengthLimitingTextInputFormatter(4), FilteringTextInputFormatter.digitsOnly],
                      onChanged: (val) {
                        if (_priceErr != null) {
                          _priceValidator();
                          setState(() {});
                        }
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: '1 month',
                        hintStyle: const TextStyle(fontSize: 12),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 1, color: Colors.blue)),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: TextField(
                        controller: widget.priceThreeMonth,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        inputFormatters: [LengthLimitingTextInputFormatter(4), FilteringTextInputFormatter.digitsOnly],
                        onChanged: (val) {
                          if (_priceErr != null) {
                            _priceValidator();
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: '3 month',
                          hintStyle: const TextStyle(fontSize: 12),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 1, color: Colors.blue)),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        )),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: TextField(
                        controller: widget.priceSixMonth,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        inputFormatters: [LengthLimitingTextInputFormatter(4), FilteringTextInputFormatter.digitsOnly],
                        onChanged: (val) {
                          if (_priceErr != null) {
                            _priceValidator();
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: '6 month',
                          hintStyle: const TextStyle(fontSize: 12),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 1, color: Colors.blue)),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        )),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: TextField(
                      controller: widget.price12Month,
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      inputFormatters: [LengthLimitingTextInputFormatter(4), FilteringTextInputFormatter.digitsOnly],
                      onChanged: (val) {
                        if (_priceErr != null) {
                          _priceValidator();
                          setState(() {});
                        }
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: '12 month',
                        hintStyle: const TextStyle(fontSize: 12),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 1, color: Colors.blue)),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  _locErr ?? gymLocation?.address ?? "Select gym location here",
                  maxLines: 2,
                  style: TextStyle(fontSize: 16, color: _locErr == null ? Colors.black : Colors.red),
                )),
                const SizedBox(width: 10),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    final PlaceInfo? result = await Get.to(
                      () => MapPickerScreen(
                        lat: gymLocation?.latLng.latitude,
                        lng: gymLocation?.latLng.longitude,
                        countries: const ["SA"],
                      ),
                    );
                    print(result);
                    print(result?.address.isNotEmpty);
                    if (result != null && result.address.isNotEmpty) {
                      _locErr = null;
                      gymLocation = result;
                      setState(() {});
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.white, size: 18),
                        SizedBox(width: 5),
                        Text("Choose", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                        SizedBox(width: 3),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                onPressed: () async {
                  /// save all data in firebase (create account)
                  _fieldsValidator();
                  print("_canProceed $_canProceed");
                  if (_canProceed) {
                    String fcm = await FbNotifications.getFcm();
                    bool state = await FbAuthController().createAccount(context,
                        user: {
                          'fcm': fcm,
                          'logo': widget.urlImage,
                          'logo2': '',
                          'nameGym': widget.nameGym.text,
                          'locationGym': gymLocation!.address,
                          'gymLat': gymLocation!.latLng.latitude,
                          'gymLng': gymLocation!.latLng.longitude,
                          'descriptionGym': widget.descriptionGym.text,
                          'email': widget.email.text,
                          'password': await AppController.to.encryptData(plainText: widget.password.text, encryptData: true),
                          'phone': widget.phone.text,
                          'commercial': widget.commercial.text,
                          'typeAccount': 2,
                          'availableWifi': widget.availableWifi,
                          'availableBarking': widget.availableBarking,
                          'workingHours': [
                            {'name': 'Sunday', 'Time': '${widget.sundayFrom} - ${widget.sundayTo}'},
                            {'name': 'Monday', 'Time': '${widget.mondayFrom} - ${widget.mondayTo}'},
                            {'name': 'Tuesday', 'Time': '${widget.tuesdayFrom} - ${widget.tuesdayTo}'},
                            {'name': 'Wednesday', 'Time': '${widget.wednesdayFrom} - ${widget.wednesdayTo}'},
                            {'name': 'Thursday', 'Time': '${widget.thursdayFrom} - ${widget.thursdayTo}'},
                            {'name': 'Friday', 'Time': '${widget.fridayFrom} - ${widget.fridayTo}'},
                            {'name': 'Saturday', 'Time': '${widget.saturdayFrom} - ${widget.saturdayTo}'},
                          ],
                          'price': {
                            '1': widget.priceOneMonth.text,
                            '3': widget.priceThreeMonth.text,
                            '6': widget.priceSixMonth.text,
                            '12': widget.price12Month.text,
                          },
                          'reviews': [],
                          'offers': [],
                          'images': [],
                          'listSubscribe': [],
                        },
                        password: widget.password.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 179, 178, 178),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Save',
                      textAlign: TextAlign.center,
                      style: TextStyle(),
                    ),
                  ],
                )),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'If already have an account ',
                style: TextStyle(fontSize: 17),
              ),
              TextButton(
                onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupPick()));
                  Get.offAll(() => const MyLogin());
                },
                style: const ButtonStyle(),
                child: const Text(
                  'Log in',
                  textAlign: TextAlign.left,
                  style: TextStyle(decoration: TextDecoration.underline, color: Colors.black, fontSize: 20),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }

  Future<void> pickImageAfterSelect({required BuildContext context}) async {
    ImagePicker imagePicker = ImagePicker();

    widget._pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    if (widget._pickedFile != null) {
      /// here code upload image to firebase
      setState(() {
        widget.selectNewImage = true;
        _imgErr = null;
      });
      File file = File(widget._pickedFile!.path);
      widget.urlImage = await FbFireStoreController().uploadFile(imageFile: file, fileName: widget._pickedFile!.name);
      setState(() {});
    }
  }

  Future<String> selectTime({
    required BuildContext context,
  }) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    if (picked != null) {
      hiddenKeyboard(context);
      return '${picked.hour}:${picked.minute}';
    } else {
      return '';
    }
  }
}
