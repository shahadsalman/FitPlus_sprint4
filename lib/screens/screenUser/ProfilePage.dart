// ignore_for_file: use_build_context_synchronously


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import '../../value/constant.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  String? _emailErr;
  String? _phoneErr;
  String? _nationalIDErr;
  String? _fNameErr;
  String? _lNameErr;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nationalIDController = TextEditingController();
  String _dob = "";
  String? _dobErr;
  void _validateEmail() {
    if (emailController.text.isEmpty || !isValidEmail(emailController.text)) {
      _emailErr = "Invalid email";
    } else {
      _emailErr = null;
    }
  }


  void _validatePhone() {
    if (phoneNumberController.text.isEmpty || !isValidPhoneNumber(phoneNumberController.text)) {
      _phoneErr = "Invalid phone number";
    } else {
      _phoneErr = null;
    }
  }


  void _validateNationalID() {
    if (nationalIDController.text.isEmpty || !isValidNationalID(nationalIDController.text)) {
      _nationalIDErr = "Invalid National ID";
    } else {
      _nationalIDErr = null;
    }
  }


  void _validateFirstName() {
    if (fNameController.text.isEmpty) {
      _fNameErr = "Please enter your first name";
    } else {
      _fNameErr = null;
    }
  }


  void _validateLastName() {
    if (lNameController.text.isEmpty) {
      _lNameErr = "Please enter your last name";
    } else {
      _lNameErr = null;
    }
  }


  _dobValidator() {
    if (_dob.isEmpty) {
      _dobErr = "Please select your date of birth";
    } else {
      _dobErr = null;
    }
  }


  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );
    return emailRegex.hasMatch(email);
  }


  bool isValidPhoneNumber(String phoneNumber) {
    final RegExp regex = RegExp(
      r'^05\d{8}$',
    );
    return regex.hasMatch(phoneNumber);
  }


  bool isValidNationalID(String id) {
    final RegExp regex = RegExp(
      r'^[0-9]{10}$',
    );
    return regex.hasMatch(id);
  }


  bool isValidAge(String age) {
    final RegExp regex = RegExp(r'^\d{1,2}$');
    return regex.hasMatch(age);
  }


  bool _isEditing = false;
  bool _isLoading = false;
  late User _user;


  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _fetchUserProfile();
  }


  Future<void> _fetchUserProfile() async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(_user.uid).get();
    final userData = userDoc.data() as Map<String, dynamic>;
    fNameController.text = userData['FName'];
    lNameController.text = userData['LName'];
    emailController.text = userData['email'];
    phoneNumberController.text = userData['phone'];
    nationalIDController.text = userData['id'];
    _dob = userData['age'];
    setState(() {});
  }


  Future<void> _updateUserProfile() async {
    _dobValidator();
    setState(() {});
    _validateEmail();
    _validatePhone();
    _validateNationalID();
    _validateFirstName();
    _validateLastName();
    if (_emailErr == null && _phoneErr == null && _nationalIDErr == null && _fNameErr == null && _lNameErr == null) {
      if (_formKey.currentState!.validate() && _dobErr == null) {
        setState(() {
          _isLoading = true;
        });


        final updatedEmail = emailController.text;


        // Check if the edited email matches an existing email in the database
        bool emailExists = false;
        final snapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: updatedEmail).get();


        if (snapshot.docs.isNotEmpty) {
          for (final doc in snapshot.docs) {
            if (doc.id != _user.uid) {
              // Matching email found, but not for the current user
              emailExists = true;
              break;
            }
          }
        }


        if (emailExists) {
          setState(() {
            _isLoading = false;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Email Already Exists'),
                content: const Text('This email is already in use. Please use a different email.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          // No existing email found for another user, proceed with the update
          final updatedData = {
            'FName': fNameController.text,
            'LName': lNameController.text,
            'email': updatedEmail,
            'phone': phoneNumberController.text,
            'id': nationalIDController.text,
            'age': _dob,
          };


          await FirebaseFirestore.instance.collection('users')
              .doc(_user.uid)
              .update(updatedData);
        }
        setState(() {
          _isEditing = false;
          _isLoading = false;
        });
      }
    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 210, 199, 226),
        elevation: 20,
        centerTitle: true,
        title: const Text('Profile'),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 22),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _updateUserProfile,
            ),
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: fNameController,
                  enabled: _isEditing,
                  decoration: InputDecoration(labelText: 'First Name',errorText: _fNameErr),
                  onChanged: (val) {
                    if (_fNameErr != null) {
                      _validateFirstName();
                      setState(() {});
                    }
                  },


                ),
                TextFormField(
                  controller: lNameController,
                  enabled: _isEditing,
                  decoration:  InputDecoration(labelText: 'Last Name',errorText: _lNameErr),
                  onChanged: (val) {
                    if (_lNameErr != null) {
                      _validateLastName();
                      setState(() {});
                    }
                  },
                ),
                TextFormField(
                  controller: emailController,
                  enabled: _isEditing,
                  decoration:  InputDecoration(labelText: 'Email',errorText: _emailErr),
                  onChanged: (val) {
                    if (_emailErr != null) {
                      _validateEmail();
                      setState(() {});
                    }
                  },
                ),
                TextFormField(
                  controller: phoneNumberController,
                  enabled: _isEditing,
                  decoration:  InputDecoration(labelText: 'Phone number',errorText: _phoneErr),
                  keyboardType: TextInputType.number, // Ensure a numeric keyboard initially
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    LengthLimitingTextInputFormatter(10)
                  ],
                  onChanged: (val) {
                    if (_phoneErr != null) {
                      _validatePhone();
                      setState(() {});
                    }
                  },
                ),
                TextFormField(
                  controller: nationalIDController,
                  enabled: _isEditing,
                  decoration:  InputDecoration(labelText: 'National ID',errorText: _nationalIDErr),
                  keyboardType: TextInputType.number, // Ensure a numeric keyboard initially
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    LengthLimitingTextInputFormatter(10), // Set a limit of 10 characters
                  ],
                  onChanged: (val) {
                    if (_nationalIDErr != null) {
                      _validateNationalID();
                      setState(() {});
                    }
                  },


                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          _dobErr == null ? _dob : (_dobErr ?? "Select your date of birth"),
                          style: TextStyle(
                              fontSize: 16,
                              color: _isEditing
                                  ? _dobErr == null
                                  ? Colors.black
                                  : Colors.red
                                  : Colors.grey),
                        )),
                    const SizedBox(width: 10),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: _isEditing
                          ? () async {
                        final now = DateTime.now();
                        final temp = await showDatePicker(context: context, initialDate: DateTime(now.year - 15, now.month, now.day), firstDate: DateTime(now.year - 100, now.month, now.day), lastDate: DateTime(now.year - 15, now.month, now.day));
                        if (temp != null) {
                          _dob = "${temp.day}/${temp.month}/${temp.year}";
                          if (_dobErr != null) {
                            _dobValidator();
                          }
                          setState(() {});
                        }
                      }
                          : null,
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
                const SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

