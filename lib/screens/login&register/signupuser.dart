// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:fitplus/firebase/fb_auth_controller.dart';
import 'package:fitplus/firebase/fb_notifications.dart';
import 'package:fitplus/screens/login&register/login.dart';
import 'package:fitplus/src/controller/splash_screens_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../value/constant.dart';

class User_Signup extends StatefulWidget {
  const User_Signup({super.key});

  @override
  _UserSignupState createState() => _UserSignupState();
}

class _UserSignupState extends State<User_Signup> {
  bool isLoading = false;
  TextEditingController FNameController = TextEditingController();
  TextEditingController LNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController NationalIDController = TextEditingController();
  TextEditingController BirthDateController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  DateTime? _dob;

  String? _fNameErr;
  String? _lNameErr;
  String? _emailErr;
  String? _pass1Err;
  String? _pass2Err;
  String? _phoneErr;
  String? _nationalIdErr;
  String? _dobErr;

  bool get _canProceed => _emailErr == null && _pass1Err == null && _pass2Err == null && _phoneErr == null && _nationalIdErr == null && _fNameErr == null && _lNameErr == null && _dobErr == null;

  _emailValidator() {
    if (emailController.text.trim().isEmpty) {
      _emailErr = "Please enter a valid email";
    } else if (!emailController.text.isEmail) {
      _emailErr = "Please enter a valid email";
    } else {
      _emailErr = null;
    }
  }

  _pass1Validator() {
    if (passwordController.text.trim().length < 7) {
      _pass1Err = "Password length is short (minimum : 7)";
    } else if (!passwordController.text.contains(RegExp(r'[A-Z]'))) {
      _pass1Err = "At least one (special, lower, upper, number)";
    } else if (!passwordController.text.contains(RegExp(r'[a-z]'))) {
      _pass1Err = "At least one (special, lower, upper, number)";
    } else if (!passwordController.text.contains(RegExp(r'[0-9]'))) {
      _pass1Err = "At least one (special, lower, upper, number)";
    } else if (!passwordController.text.contains(RegExp(r'[_\-!@#$%^&*(),.?":{}|<>]'))) {
      _pass1Err = "At least one (special, lower, upper, number)";
    } else {
      _pass1Err = null;
    }
  }

  _pass2Validator() {
    if (confirmPassController.text.isEmpty) {
      _pass2Err = "This is a required field";
    } else if (confirmPassController.text != passwordController.text) {
      _pass2Err = "Password does not match";
    } else {
      _pass2Err = null;
    }
  }

  _phoneValidator() {
    if (phonenumberController.text.trim().isEmpty) {
      _phoneErr = "Please enter a Phone Number";
    } else if (phonenumberController.text.trim().length != 10) {
      _phoneErr = "Please enter 10 digits Phone Number";
    } else if (!phonenumberController.text.startsWith("05")) {
      _phoneErr = "The phone number must start with 05";
    } else {
      _phoneErr = null;
    }
  }

  _nationalIdValidator() {
    if (NationalIDController.text.trim().isEmpty) {
      _nationalIdErr = "Please enter your National Id";
    } else if (NationalIDController.text.trim().length < 10) {
      _nationalIdErr = "Please enter a 10 digit National Id";
    } else {
      _nationalIdErr = null;
    }
  }

  _fNameValidator() {
    if (FNameController.text.trim().isEmpty) {
      _fNameErr = "Please enter a First Name";
    } else {
      _fNameErr = null;
    }
  }

  _lNameValidator() {
    if (LNameController.text.trim().isEmpty) {
      _lNameErr = "Please enter a Last Name";
    } else {
      _lNameErr = null;
    }
  }

  _dobValidator() {
    if (_dob == null) {
      _dobErr = "Please select your date of birth";
    } else {
      _dobErr = null;
    }
  }

  _fieldsValidator() {
    _fNameValidator();
    _lNameValidator();
    _emailValidator();
    _pass1Validator();
    _pass2Validator();
    _phoneValidator();
    _nationalIdValidator();
    _dobValidator();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(elevation: 20, backgroundColor: const Color.fromARGB(255, 210, 199, 226), title: const Text('Create Account'), centerTitle: true, titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20)),
        backgroundColor: const Color.fromARGB(255, 255, 251, 251),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 250,
                margin: const EdgeInsets.fromLTRB(80, 30, 85, 0),
                child: Image.asset('assets/logo.png'),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.deny(RegExp(r'[0-9]'))],
                            style: const TextStyle(color: Colors.black, fontSize: 25),
                            onChanged: (val) {
                              if (_fNameErr != null) {
                                _fNameValidator();
                                setState(() {});
                              }
                            },
                            decoration: InputDecoration(
                              fillColor: const Color.fromARGB(255, 210, 202, 221),
                              filled: true,
                              errorText: _fNameErr,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "First Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            controller: FNameController,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                            ],
                            style: const TextStyle(color: Colors.black, fontSize: 25),
                            onChanged: (val) {
                              if (_lNameErr != null) {
                                _lNameValidator();
                                setState(() {});
                              }
                            },
                            decoration: InputDecoration(
                              fillColor: const Color.fromARGB(255, 210, 202, 221),
                              filled: true,
                              errorText: _lNameErr,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "Last Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            controller: LNameController,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            style: const TextStyle(color: Colors.black, fontSize: 25),
                            //obscureText: true,
                            onChanged: (val) {
                              if (_emailErr != null) {
                                _emailValidator();
                                setState(() {});
                              }
                            },
                            decoration: InputDecoration(
                              errorText: _emailErr,
                              fillColor: const Color.fromARGB(255, 210, 202, 221),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            controller: emailController,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
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
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorText: _pass1Err,
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            controller: passwordController,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
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
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorText: _pass2Err,
                              hintText: "Confirm Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            controller: confirmPassController,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            style: const TextStyle(color: Colors.black, fontSize: 25),
                            onChanged: (val) {
                              if (_phoneErr != null) {
                                _phoneValidator();
                                setState(() {});
                              }
                            },
                            keyboardType: TextInputType.phone,
                            inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              fillColor: const Color.fromARGB(255, 210, 202, 221),
                              filled: true,
                              errorText: _phoneErr,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "Phone number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            controller: phonenumberController,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            maxLength: 10,
                            style: const TextStyle(color: Colors.black, fontSize: 25),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                            onChanged: (val) {
                              if (_nationalIdErr != null) {
                                _nationalIdValidator();
                                setState(() {});
                              }
                            },
                            decoration: InputDecoration(
                              fillColor: const Color.fromARGB(255, 210, 202, 221),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "National ID",
                              errorText: _nationalIdErr,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            controller: NationalIDController,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                _dob != null ? "${_dob!.day}/${_dob!.month}/${_dob!.year}" : (_dobErr ?? "Select your date of birth"),
                                maxLines: 2,
                                style: TextStyle(fontSize: 16, color: _dobErr == null ? Colors.black : Colors.red),
                              )),
                              const SizedBox(width: 10),
                              InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  final now = DateTime.now();
                                  final temp = await showDatePicker(context: context, initialDate: DateTime(now.year - 15, now.month, now.day), firstDate: DateTime(now.year - 100, now.month, now.day), lastDate: DateTime(now.year - 15, now.month, now.day));
                                  if (temp != null) {
                                    _dob = temp;
                                  }
                                  if (_dobErr != null) {
                                    _dobValidator();
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
                                      Icon(Icons.calendar_month, color: Colors.white, size: 18),
                                      SizedBox(width: 5),
                                      Text("Birth Date", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                                      SizedBox(width: 3),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color.fromARGB(255, 179, 178, 178),
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: () async {
                                    _fieldsValidator();

                                    if (_canProceed) {
                                      String fcm = await FbNotifications.getFcm();
                                      bool state = await FbAuthController().createAccount(context,
                                          user: {
                                            'fcm': fcm,
                                            'FName': FNameController.text,
                                            'LName': LNameController.text,
                                            'email': emailController.text,
                                            'password': await AppController.to.encryptData(plainText: passwordController.text, encryptData: true),
                                            'phone': phonenumberController.text,
                                            'id': NationalIDController.text,
                                            // 'age': BirthDateController.text,
                                            'age': "${_dob!.day}/${_dob!.month}/${_dob!.year}",
                                            'typeAccount': 1,
                                            'listSubscribe': [],
                                          },
                                          password: passwordController.text);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
