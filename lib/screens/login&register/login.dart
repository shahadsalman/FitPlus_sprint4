import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitplus/firebase/fb_auth_controller.dart';
import 'package:fitplus/firebase/fb_notifications.dart';
import 'package:fitplus/screens/login&register/Pick.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'forgotpassword.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );
    return emailRegex.hasMatch(email);
  }

  //  User Account
  // jojo-17141@hotmail.com
  // 1234567

  //  Gym Manager
  // gymtest@test.com
  // 123456789

  // GoldsGym
  // goldgym@test.com
  // 123456789

  void signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((value) {
        print(value);
        setState(() {
          isLoading = false;
        });
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No user found for that email."),
          backgroundColor: Colors.redAccent,
        ));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Wrong password provided for that user."),
          backgroundColor: Colors.redAccent,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        backgroundColor: const Color.fromARGB(255, 210, 199, 226),
        title: const Text('Sign in'),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 250,
              margin: const EdgeInsets.fromLTRB(85, 60, 85, 0),
              child: Image.asset('assets/logo.png'),
            ),
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35),
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.black, fontSize: 25),
                          decoration: InputDecoration(
                              fillColor: const Color.fromARGB(255, 210, 202, 221),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 123, 108, 108),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Color.fromARGB(255, 86, 78, 78),
                              ),
                              hintText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextField(
                          controller: passwordController,
                          style: const TextStyle(color: Colors.black, fontSize: 25),
                          obscureText: true,
                          decoration: InputDecoration(
                              fillColor: const Color.fromARGB(255, 210, 202, 221),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 123, 108, 108),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 86, 78, 78)),
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                            onPressed: () {
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword(),));
                              Get.to(() => const ForgetPassword());
                            },
                            child: const Text(
                              'Forgot Password',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            )),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color.fromARGB(255, 179, 178, 178),
                              child: IconButton(
                                  color: Colors.white,
                                  onPressed: () async {
                                    // String text = '';
                                    // String password = await AppController.to.encryptData(plainText: text ,encryptData: false);
                                    // print(password);
                                    if (emailController.text.trim().isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Please enter a email"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    } else if (passwordController.text.trim().length < 6) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Password length is short (minimum : 6)"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    } else if (!isValidEmail(emailController.text.toString())) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Please enter a valid email"),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    } else {
                                      print(FbNotifications.getFcm());
                                      await FbAuthController().signIn(context, email: emailController.text, password: passwordController.text);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                  )),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Does not have an account?',
                              style: TextStyle(fontSize: 17),
                            ),
                            TextButton(
                              onPressed: () {
                                // print('here');
                                //Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupPick()));
                                Get.to(() => const SignupPick());
                              },
                              style: const ButtonStyle(),
                              child: const Text(
                                'Sign Up',
                                textAlign: TextAlign.left,
                                style: TextStyle(decoration: TextDecoration.underline, color: Colors.black, fontSize: 20),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (isLoading)
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
