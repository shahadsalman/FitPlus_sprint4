import 'package:fitplus/screens/login&register/creategym.dart';
import 'package:fitplus/screens/login&register/signupuser.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class SignupPick extends StatelessWidget {
  const SignupPick({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        backgroundColor: const Color.fromARGB(255, 210, 199, 226),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/logo.png',
                width: 250,
                height: 250,
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign Up As?',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                  onPressed: () async {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => User_Signup(),));
                    Get.to(() => const User_Signup());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 210, 202, 221),
                    minimumSize: const Size(double.infinity, 70),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'New User',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  )),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                  onPressed: () async {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => Signup(),));
                    Get.to(() => CreateAccountManagerGym());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 210, 202, 221),
                    minimumSize: const Size(double.infinity, 70),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Gym Manager',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
