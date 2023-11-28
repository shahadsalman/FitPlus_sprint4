import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitplus/screens/home/edit_profile_controller.dart';
import 'package:fitplus/screens/map_picker/map_picker_screen.dart';
import 'package:fitplus/screens/map_picker/models/lat_lng_model.dart';
import 'package:fitplus/value/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../map_picker/models/place_info.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final controller = Get.put(EditProfileController());

  bool _isLoading = true;

  String? _emailErr;
  String? _phoneErr;
  String? _commercialErr;
  String? _nameErr;
  String? _descErr;
  String? _sunErr;
  String? _monErr;
  String? _tueErr;
  String? _wedErr;
  String? _thuErr;
  String? _friErr;
  String? _satErr;

  bool get _canProceed => _emailErr == null && _phoneErr == null && _commercialErr == null && _nameErr == null && _descErr == null && _sunErr == null && _monErr == null && _tueErr == null && _wedErr == null && _thuErr == null && _friErr == null && _satErr == null;

  @override
  initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    final userData = snapshot.data() as Map<String, dynamic>;
    controller.urlImage.value = userData['logo'];
    controller.nameGym.text = userData['nameGym'];
    controller.locationGym.value = userData['locationGym'];
    controller.gymLocation = PlaceInfo(latLng: LatLng(latitude: userData.containsKey('gymLat') ? userData['gymLat'] : 37.764870, longitude: userData.containsKey('gymLng') ? userData['gymLng'] : 73.74894));
    controller.descriptionGym.text = userData['descriptionGym'];
    controller.email.text = userData['email'];
    controller.phone.text = userData['phone'];
    controller.commercial.text = userData.containsKey('commercial') ? userData!['commercial'] : "";
    controller.availableWifi.value = userData['availableWifi'];
    controller.availableBarking.value = userData['availableBarking'];
    controller.sundayFrom.value = userData['workingHours'][0]['Time'].toString().split('-').first;
    controller.sundayTo.value = userData['workingHours'][0]['Time'].toString().split('-').last;
    controller.mondayFrom.value = userData['workingHours'][1]['Time'].toString().split('-').first;
    controller.mondayTo.value = userData['workingHours'][1]['Time'].toString().split('-').last;
    controller.tuesdayFrom.value = userData['workingHours'][2]['Time'].toString().split('-').first;
    controller.tuesdayTo.value = userData['workingHours'][2]['Time'].toString().split('-').last;
    controller.wednesdayFrom.value = userData['workingHours'][3]['Time'].toString().split('-').first;
    controller.wednesdayTo.value = userData['workingHours'][3]['Time'].toString().split('-').last;
    controller.thursdayFrom.value = userData['workingHours'][4]['Time'].toString().split('-').first;
    controller.thursdayTo.value = userData['workingHours'][4]['Time'].toString().split('-').last;
    controller.fridayFrom.value = userData['workingHours'][5]['Time'].toString().split('-').first;
    controller.fridayTo.value = userData['workingHours'][5]['Time'].toString().split('-').last;
    controller.saturdayFrom.value = userData['workingHours'][6]['Time'].toString().split('-').first;
    controller.saturdayTo.value = userData['workingHours'][6]['Time'].toString().split('-').last;
    setState(() {
      _isLoading = false;
    });
  }

  _emailValidator() {
    if (controller.email.text.trim().isEmpty) {
      _emailErr = "Please enter a valid email";
    } else if (!controller.email.text.isEmail) {
      _emailErr = "Please enter a valid email";
    } else {
      _emailErr = null;
    }
  }

  _phoneValidator() {
    if (controller.phone.text.trim().isEmpty) {
      _phoneErr = "Please enter a Phone Number";
    } else if (controller.phone.text.trim().length != 10) {
      _phoneErr = "Please enter 10 digits Phone Number";
    } else if (!controller.phone.text.startsWith("05")) {
      _phoneErr = "The phone number must start with 05";
    } else {
      _phoneErr = null;
    }
  }

  _commercialNumValidator() {
    if (controller.commercial.text.trim().isEmpty) {
      _commercialErr = "Please enter a Commercial Record";
    } else if (controller.commercial.text.trim().length != 14) {
      _commercialErr = "Please enter a 14 digit Commercial Record";
    } else {
      _commercialErr = null;
    }
  }

  _nameValidator() {
    if (controller.nameGym.text.trim().isEmpty) {
      _nameErr = "Please Add GYM Name";
    } else {
      _nameErr = null;
    }
  }

  _descValidator() {
    if (controller.descriptionGym.text.trim().isEmpty) {
      _descErr = "Please add Gym Description";
    } else {
      _descErr = null;
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
    if (controller.sundayFrom.value == 'From' ||
        controller.sundayTo.value == 'To' ||
        controller.mondayFrom.value == 'From' ||
        controller.mondayTo.value == 'To' ||
        controller.tuesdayFrom.value == 'From' ||
        controller.tuesdayTo.value == 'To' ||
        controller.wednesdayFrom.value == 'From' ||
        controller.wednesdayTo.value == 'To' ||
        controller.thursdayFrom.value == 'From' ||
        controller.thursdayTo.value == 'To' ||
        controller.fridayFrom.value == 'From' ||
        controller.fridayTo.value == 'To' ||
        controller.saturdayFrom.value == 'From' ||
        controller.saturdayTo.value == 'To') {
      if (controller.sundayFrom.value == 'From' || controller.sundayTo.value == 'To') {
        _sunErr = "Please Add Working Hours GYM In Sunday";
      }
      if (controller.mondayFrom.value == 'From' || controller.mondayTo.value == 'To') {
        _monErr = "Please Add Working Hours GYM In monday";
      }
      if (controller.tuesdayFrom.value == 'From' || controller.tuesdayTo.value == 'To') {
        _tueErr = "Please Add Working Hours GYM In tuesday";
      }
      if (controller.wednesdayFrom.value == 'From' || controller.wednesdayTo.value == 'To') {
        _wedErr = "Please Add Working Hours GYM In wednesday";
      }
      if (controller.thursdayFrom.value == 'From' || controller.thursdayTo.value == 'To') {
        _thuErr = "Please Add Working Hours GYM In thursday";
      }
      if (controller.fridayFrom.value == 'From' || controller.fridayTo.value == 'To') {
        _friErr = "Please Add Working Hours GYM In friday";
      }
      if (controller.saturdayFrom.value == 'From' || controller.saturdayTo.value == 'To') {
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
    _emailValidator();
    _phoneValidator();
    _commercialNumValidator();
    _nameValidator();
    _descValidator();
    _hoursValidator();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 20,
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.arrow_back)),
          backgroundColor: const Color.fromARGB(255, 210, 199, 226),
          title: const Text('Edit Profile'),
          centerTitle: true,
          titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20)),
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
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
                      controller.pickImageAfterSelect(context: context);
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                      child: Obx(() => Center(
                            child: controller.urlImage.value != ""
                                ? Image.network(
                                    controller.urlImage.value,
                                    fit: BoxFit.fill,
                                    height: 150,
                                  )
                                : const Icon(Icons.camera_alt, size: 50),
                          )),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 80,
                width: double.infinity,
                margin: const EdgeInsets.only(left: 35, right: 35),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: TextField(
                    controller: controller.email,
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
                height: 80,
                width: double.infinity,
                margin: const EdgeInsets.only(left: 35, right: 35),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: TextField(
                    maxLength: 10,
                    controller: controller.phone,
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
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 80,
                width: double.infinity,
                margin: const EdgeInsets.only(left: 35, right: 35),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: TextField(
                    maxLength: 14,
                    controller: controller.commercial,
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
                    controller: controller.nameGym,
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
                    controller: controller.descriptionGym,
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
                    Obx(() => Switch(
                          value: controller.availableWifi.value,
                          onChanged: (value) {
                            controller.availableWifi.value = value;
                          },
                        )),
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
                    Obx(() => Switch(
                          value: controller.availableBarking.value,
                          onChanged: (value) {
                            controller.availableBarking.value = value;
                          },
                        )),
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
                        controller.sundayFrom.value = await controller.selectTime(context: context);
                        _sunErr = _timeValidator(toString: controller.sundayTo.value, fromString: controller.sundayFrom.value);
                        setState(() {});
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Obx(() => Text(controller.sundayFrom.value)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        controller.sundayTo.value = await controller.selectTime(context: context);
                        _sunErr = _timeValidator(toString: controller.sundayTo.value, fromString: controller.sundayFrom.value);
                        setState(() {});
                        // if (_sunErr != null) {
                        //   _sunErr = null;
                        // }
                        // setState(() {});
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Obx(() => Text(controller.sundayTo.value)),
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
                        controller.mondayFrom.value = await controller.selectTime(context: context);
                        _monErr = _timeValidator(toString: controller.mondayTo.value, fromString: controller.mondayFrom.value);
                        setState(() {});
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Obx(() => Text(controller.mondayFrom.value)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        controller.mondayTo.value = await controller.selectTime(context: context);
                        _monErr = _timeValidator(toString: controller.mondayTo.value, fromString: controller.mondayFrom.value);
                        setState(() {});
                        // if (_monErr != null) {
                        //   _monErr = null;
                        //   setState(() {});
                        // }
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Obx(() => Text(controller.mondayTo.value)),
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
                        controller.tuesdayFrom.value = await controller.selectTime(context: context);
                        _tueErr = _timeValidator(toString: controller.tuesdayTo.value, fromString: controller.tuesdayFrom.value);
                        setState(() {});
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Obx(() => Text(controller.tuesdayFrom.value)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        controller.tuesdayTo.value = await controller.selectTime(context: context);
                        _tueErr = _timeValidator(toString: controller.tuesdayTo.value, fromString: controller.tuesdayFrom.value);
                        setState(() {});
                        // if (_tueErr != null) {
                        //   _tueErr = null;
                        //   setState(() {});
                        // }
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Obx(() => Text(controller.tuesdayTo.value)),
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
                        controller.wednesdayFrom.value = await controller.selectTime(context: context);
                        _wedErr = _timeValidator(toString: controller.wednesdayTo.value, fromString: controller.wednesdayFrom.value);
                        setState(() {});
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Obx(() => Text(controller.wednesdayFrom.value)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        controller.wednesdayTo.value = await controller.selectTime(context: context);
                        _wedErr = _timeValidator(toString: controller.wednesdayTo.value, fromString: controller.wednesdayFrom.value);
                        setState(() {});
                        // if (_wedErr != null) {
                        //   _wedErr = null;
                        //   setState(() {});
                        // }
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Obx(() => Text(controller.wednesdayTo.value)),
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
                        controller.thursdayFrom.value = await controller.selectTime(context: context);
                        _thuErr = _timeValidator(toString: controller.thursdayTo.value, fromString: controller.thursdayFrom.value);
                        setState(() {});
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Obx(() => Text(controller.thursdayFrom.value)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        controller.thursdayTo.value = await controller.selectTime(context: context);
                        _thuErr = _timeValidator(toString: controller.thursdayTo.value, fromString: controller.thursdayFrom.value);
                        setState(() {});
                        // if (_thuErr != null) {
                        //   _thuErr = null;
                        //   setState(() {});
                        // }
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Obx(() => Text(controller.thursdayTo.value)),
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
                        controller.fridayFrom.value = await controller.selectTime(context: context);
                        _friErr = _timeValidator(toString: controller.fridayTo.value, fromString: controller.fridayFrom.value);
                        setState(() {});
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Obx(() => Text(controller.fridayFrom.value)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        controller.fridayTo.value = await controller.selectTime(context: context);
                        _friErr = _timeValidator(toString: controller.fridayTo.value, fromString: controller.fridayFrom.value);
                        setState(() {});
                        // if (_friErr != null) {
                        //   _friErr = null;
                        //   setState(() {});
                        // }
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Obx(() => Text(controller.fridayTo.value)),
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
                        controller.saturdayFrom.value = await controller.selectTime(context: context);
                        _satErr = _timeValidator(toString: controller.saturdayTo.value, fromString: controller.saturdayFrom.value);
                        setState(() {});
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Obx(() => Text(controller.saturdayFrom.value)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        controller.saturdayTo.value = await controller.selectTime(context: context);
                        _satErr = _timeValidator(toString: controller.saturdayTo.value, fromString: controller.saturdayFrom.value);
                        setState(() {});
                        // if (_satErr != null) {
                        //   _satErr = null;
                        //   setState(() {});
                        // }
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Obx(() => Text(controller.saturdayTo.value)),
                        ),
                      ),
                    ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: Obx(() => Text(
                              controller.locationGym.value,
                              maxLines: 2,
                              style: const TextStyle(fontSize: 16),
                            ))),
                    const SizedBox(width: 10),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        final PlaceInfo? result = await Get.to(
                          () => MapPickerScreen(
                            lat: controller.gymLocation != null ? controller.gymLocation!.latLng.latitude : 37.764870,
                            lng: controller.gymLocation != null ? controller.gymLocation!.latLng.longitude : 73.74894,
                            countries: const ["SA"],
                          ),
                        );
                        if (result != null && result.address.isNotEmpty) {
                          controller.gymLocation = result;
                          controller.locationGym.value = result.address;
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
                      if (_canProceed) {
                        await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                          'logo': controller.urlImage.value,
                          'nameGym': controller.nameGym.text,
                          'locationGym': controller.gymLocation!.address,
                          'gymLat': controller.gymLocation!.latLng.latitude,
                          'gymLng': controller.gymLocation!.latLng.longitude,
                          'descriptionGym': controller.descriptionGym.text,
                          'email': controller.email.text,
                          'phone': controller.phone.text,
                          'commercial': controller.commercial.text,
                          'availableWifi': controller.availableWifi.value,
                          'availableBarking': controller.availableBarking.value,
                          'workingHours': [
                            {'name': 'Sunday', 'Time': '${controller.sundayFrom.value} - ${controller.sundayTo.value}'},
                            {'name': 'Monday', 'Time': '${controller.mondayFrom.value} - ${controller.mondayTo.value}'},
                            {'name': 'Tuesday', 'Time': '${controller.tuesdayFrom.value} - ${controller.tuesdayTo.value}'},
                            {'name': 'Wednesday', 'Time': '${controller.wednesdayFrom.value} - ${controller.wednesdayTo.value}'},
                            {'name': 'Thursday', 'Time': '${controller.thursdayFrom.value} - ${controller.thursdayTo.value}'},
                            {'name': 'Friday', 'Time': '${controller.fridayFrom.value} - ${controller.fridayTo.value}'},
                            {'name': 'Saturday', 'Time': '${controller.saturdayFrom.value} - ${controller.saturdayTo.value}'},
                          ],
                        });
                        showMaterialDialog_login(context, 'Data Updated Successfully');
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
              const SizedBox(
                height: 80,
              ),
            ],
          );
        },
      ),
    );
  }
}
